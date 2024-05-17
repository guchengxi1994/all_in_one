use std::{collections::HashMap, sync::RwLock};

use futures::StreamExt;
use langchain_rust::{
    chain::{Chain, LLMChainBuilder, SequentialChainBuilder},
    language_models::llm::LLM,
    llm::{Config, OpenAI},
    prompt::{HumanMessagePromptTemplate, PromptTemplate, TemplateFormat},
    prompt_args,
    schemas::Message,
    template_jinja2,
};

use crate::{errors::RustError, frb_generated::StreamSink};

use super::{app_flowy_model::AttributeType, plugins::chat_file::get_file_content, OPENAI};

pub enum TemplateRunningStage {
    Format,
    Eval,
    Optimize,
    Done,
}

impl TemplateRunningStage {
    pub fn change_stage(stage: TemplateRunningStage) {
        match TEMPLATE_STATE_SINK.try_read() {
            Ok(s) => match s.as_ref() {
                Some(s0) => {
                    let _ = s0.add(stage);
                }
                None => {
                    println!("[rust-error] Stream is None");
                }
            },
            Err(_) => {
                println!("[rust-error] Stream read error");
            }
        }
    }

    pub fn finish() {
        Self::change_stage(TemplateRunningStage::Done)
    }
}

pub struct AppFlowyTemplate {
    pub items: Vec<TemplateItem>,
}

#[derive(Debug, Clone)]
pub struct TemplateItem {
    pub prompt: String,
    pub index: u32,
    pub next: Option<u32>,
    pub attr_type: AttributeType,
    pub extra: Option<String>,
}

impl TemplateItem {
    pub fn from(i: (String, u32, Option<u32>, AttributeType, Option<String>)) -> Self {
        Self {
            prompt: i.0,
            index: i.1,
            next: i.2,
            attr_type: i.3,
            extra: i.4,
        }
    }
}

pub fn generate_template_items_from_list(
    list: Vec<(String, u32, Option<u32>, AttributeType, Option<String>)>,
) -> Vec<TemplateItem> {
    let mut v = Vec::new();
    for i in list {
        v.push(TemplateItem::from(i));
    }

    v
}

pub static TEMPLATE_MESSAGE_SINK: RwLock<Option<StreamSink<TemplateResult>>> = RwLock::new(None);

pub static TEMPLATE_STATE_SINK: RwLock<Option<StreamSink<TemplateRunningStage>>> =
    RwLock::new(None);

#[derive(Debug, Clone)]
pub struct TemplateResult {
    pub prompt: String,
    pub index: u32,
    pub response: String,
}

pub async fn optimize_doc(doc: String) -> String {
    println!("[rust] optimize doc : {:?}",doc);

    TemplateRunningStage::change_stage(TemplateRunningStage::Optimize);

    let open_ai;
    {
        open_ai = OPENAI.read().unwrap();
    }

    let out = open_ai
        .clone()
        .generate(&[
            Message::new_system_message("你是一个专业的作家，适合优化文章脉络和措辞，使得文章表达更加详实、具体，观点清晰。"),
            Message::new_human_message("请帮我改写优化以下文章。注意：1.进行文章改写时请尽量使用简体中文。\n2.只改写优化<rewrite> </rewrite>标签中的部分。\n3.保留<keep> </keep>标签中的内容。\n4.最终结果中删除<rewrite> </rewrite> <keep> </keep>标签。"),
            Message::new_human_message(doc),
        ])
        .await;

    TemplateRunningStage::change_stage(TemplateRunningStage::Done);

    if let Err(e) = out {
        let mut errmsg: RustError = RustError::default();
        errmsg.errmsg = "结果优化失败".to_owned();
        errmsg.context = Some(format!("[traceback] {:?}", e));
        errmsg.send_to_dart();
        return "".to_owned();
    }

    out.unwrap().generation
}

impl AppFlowyTemplate {
    pub fn from(v: Vec<TemplateItem>) -> Self {
        Self { items: v }
    }

    pub fn into_multiple(&mut self) -> Vec<Vec<&TemplateItem>> {
        self.items.sort_by(|a, b| a.index.cmp(&b.index));
        let mut vecs: Vec<Vec<&TemplateItem>> = Vec::new();
        let mut saved: Vec<u32> = Vec::new();

        let mut i = 0;
        while i < self.items.len() {
            let mut item = self.items.get(i).unwrap();
            if saved.contains(&item.index) {
                i += 1;
                continue;
            }

            let mut sub_vec = Vec::new();
            sub_vec.push(item);
            i = i + 1;
            if item.next == None {
                saved.push(item.index);
                vecs.push(sub_vec);
            } else {
                for next in &self.items {
                    if saved.contains(&next.index) {
                        continue;
                    }
                    if item.next == None {
                        saved.push(item.index);
                        // vecs.push(sub_vec);
                        break;
                    }

                    if next.index == item.next.unwrap() {
                        sub_vec.push(next);
                        saved.push(next.index);
                        item = next;
                    }
                }

                vecs.push(sub_vec);
            }
        }
        vecs
    }

    pub async fn execute(&mut self, enable_plugin: bool) {
        TemplateRunningStage::change_stage(TemplateRunningStage::Format);

        let separated_vecs = self.into_multiple();
        println!("[rust] separated_vecs length {}", separated_vecs.len());
        if separated_vecs.is_empty() {
            TemplateRunningStage::change_stage(TemplateRunningStage::Done);
            return;
        }

        let open_ai;
        {
            open_ai = OPENAI.read().unwrap();
        }
        
        TemplateRunningStage::change_stage(TemplateRunningStage::Eval);

        for i in separated_vecs {
            println!("[rust] chain length {}", i.len());
            let s;
            if !enable_plugin {
                s = items_to_chain(&i, open_ai.clone());
            } else {
                s = items_to_chain_with_plugins(&i, open_ai.clone()).await;
            }

            Self::execute_worker(s, i).await;
        }
    }

    async fn execute_worker(s: (Option<Box<dyn Chain>>, Option<String>), i: Vec<&TemplateItem>) {
        let mut err_msg: RustError = RustError::default();

        if let Some(c) = s.0 {
            if let Some(p) = s.1 {
                let out = c
                    .execute(prompt_args! {
                        "input0" => p
                    })
                    .await;

                if let Err(_out) = out {
                    err_msg.errmsg = "chain初始化失败".to_owned();
                    err_msg.context = Some(format!("[traceback] {:?}", _out));
                    err_msg.send_to_dart();
                    TemplateRunningStage::finish();
                    return;
                }

                let output = out.unwrap().clone();

                // println!("output {:?}", output);
                let mut index = 0;
                let mut map: HashMap<String, String> = HashMap::new();
                // map.insert("input0".to_owned(), p.clone());
                while index < i.len() {
                    let key = format!("input{}", index + 1);
                    let value = output.get(&key).unwrap();
                    map.insert(i.get(index).unwrap().prompt.clone(), value.to_string());
                    index += 1;
                }

                println!("map {:?}", map);

                index = 0;
                for kv in map.into_iter() {
                    let template_result = TemplateResult {
                        prompt: kv.0,
                        index: index.try_into().unwrap(),
                        response: kv.1,
                    };

                    match TEMPLATE_MESSAGE_SINK.try_read() {
                        Ok(s) => match s.as_ref() {
                            Some(s0) => {
                                let _ = s0.add(template_result.clone());
                            }
                            None => {
                                println!("[rust-error] Stream is None");
                            }
                        },
                        Err(_) => {
                            println!("[rust-error] Stream read error");
                        }
                    }

                    index += 1;
                }

                // stream not implemented for seq-chain

                // let mut stream = c
                //     .stream(prompt_args! {
                //         "input0" => p
                //     })
                //     .await
                //     .unwrap();

                // while let Some(result) = stream.next().await {
                //     match result {
                //         Ok(value) => value.to_stdout().unwrap(),
                //         Err(e) => panic!("Error invoking LLMChain: {:?}", e),
                //     }
                // }
            } else {
                let mut template_result = TemplateResult {
                    prompt: i.first().unwrap().prompt.clone(),
                    index: i.first().unwrap().index,
                    response: "".to_string(),
                };
                let st = c.stream(HashMap::new()).await;

                match st {
                    Ok(mut stream) => {
                        while let Some(result) = stream.next().await {
                            match result {
                                Ok(value) => {
                                    // value.to_stdout().unwrap();
                                    template_result.response += &value.content;
                                    match TEMPLATE_MESSAGE_SINK.try_read() {
                                        Ok(s) => match s.as_ref() {
                                            Some(s0) => {
                                                let _ = s0.add(template_result.clone());
                                            }
                                            None => {
                                                println!("[rust-error] Stream is None");
                                            }
                                        },
                                        Err(_) => {
                                            println!("[rust-error] Stream read error");
                                        }
                                    }
                                }
                                Err(e) => panic!("Error invoking LLMChain: {:?}", e),
                            }
                        }
                    }
                    Err(_e) => {
                        err_msg.errmsg = "stream 错误".to_owned();
                        err_msg.context = Some(format!("[traceback] {:?}", _e));
                        err_msg.send_to_dart();
                        TemplateRunningStage::finish();
                    }
                }
            }
        }
    }
}

fn items_to_chain<C: Config + Send + Sync + 'static>(
    items: &Vec<&TemplateItem>,
    llm: OpenAI<C>,
) -> (Option<Box<dyn Chain>>, Option<String>) {
    if items.is_empty() {
        return (None, None);
    }

    if items.len() == 1 {
        // 返回一般的LLMChain
        let prompt = HumanMessagePromptTemplate::new(PromptTemplate::new(
            items.first().unwrap().prompt.clone(),
            vec![],
            TemplateFormat::FString,
        ));
        let normal_chain = LLMChainBuilder::new()
            .prompt(prompt)
            .llm(llm.clone())
            .build()
            .unwrap();
        return (Some(Box::new(normal_chain)), None);
    }

    if items.len() > 1 {
        // let mut chains: Vec<LLMChain> = Vec::new();
        let mut seq_chain_builder = SequentialChainBuilder::new();
        let mut i = 0;
        while i < items.len() {
            let input = format!("input{}", i);
            let output = format!("input{}", i + 1);
            let prompt_str;
            if i == 0 {
                prompt_str =
                    "请根据以下要求，帮我生成对应的文案。 {{".to_owned() + &input + "}}";
            } else {
                prompt_str = "请根据以下内容和额外要求，帮我生成对应的文案。内容: {{".to_owned()
                    + &input
                    + "}}, 额外要求: "
                    + &items.get(i).unwrap().prompt;
            }

            let prompt = HumanMessagePromptTemplate::new(template_jinja2!(prompt_str, input));
            let c = LLMChainBuilder::new()
                .prompt(prompt)
                .llm(llm.clone())
                .output_key(output)
                .build()
                .unwrap();
            // chains.push(c);
            seq_chain_builder = seq_chain_builder.add_chain(c);
            i += 1;
        }

        let seq_chain = seq_chain_builder.build();
        return (
            Some(Box::new(seq_chain)),
            Some(items.first().unwrap().prompt.clone()),
        );
    }

    (None, None)
}

/// TODO: 暂时sql和文件问答不支持顺序链
async fn items_to_chain_with_plugins<C: Config + Send + Sync + 'static>(
    items: &Vec<&TemplateItem>,
    llm: OpenAI<C>,
) -> (Option<Box<dyn Chain>>, Option<String>) {
    if items.is_empty() {
        return (None, None);
    }

    if items.len() == 1 {
        let mut extra_content = "".to_owned();
        let item = items.get(0).unwrap();
        // sql

        // file
        if item.attr_type == AttributeType::File {
            let file_content = get_file_content(item.extra.clone().unwrap_or("".to_owned())).await;
            match file_content {
                Ok(_f) => {
                    extra_content = _f;
                }
                Err(_e) => {
                    println!("[rust-error] file content is None");
                    return (None, None);
                }
            }
        }

        // 返回一般的LLMChain
        let prompt = HumanMessagePromptTemplate::new(PromptTemplate::new(
            items.first().unwrap().prompt.clone() + &extra_content,
            vec![],
            TemplateFormat::FString,
        ));
        let normal_chain = LLMChainBuilder::new()
            .prompt(prompt)
            .llm(llm.clone())
            .build()
            .unwrap();
        return (Some(Box::new(normal_chain)), None);
    }

    if items.len() > 1 {
        // let mut chains: Vec<LLMChain> = Vec::new();
        let mut seq_chain_builder = SequentialChainBuilder::new();
        let mut i = 0;
        while i < items.len() {
            let input = format!("input{}", i);
            let output = format!("input{}", i + 1);
            let prompt_str;
            if i == 0 {
                prompt_str =
                    "请根据以下要求，帮我生成对应的文案。 {{".to_owned() + &input + "}}";
            } else {
                prompt_str = "请根据以下内容和额外要求，帮我生成对应的文案。内容: {{".to_owned()
                    + &input
                    + "}}, 额外要求: "
                    + &items.get(i).unwrap().prompt;
            }

            let prompt = HumanMessagePromptTemplate::new(template_jinja2!(prompt_str, input));
            let c = LLMChainBuilder::new()
                .prompt(prompt)
                .llm(llm.clone())
                .output_key(output)
                .build()
                .unwrap();
            // chains.push(c);
            seq_chain_builder = seq_chain_builder.add_chain(c);
            i += 1;
        }

        let seq_chain = seq_chain_builder.build();
        return (
            Some(Box::new(seq_chain)),
            Some(items.first().unwrap().prompt.clone()),
        );
    }

    (None, None)
}

#[allow(unused_imports)]
mod tests {
    use std::{
        any::{Any, TypeId},
        collections::HashMap,
    };

    use futures::StreamExt;
    use langchain_rust::{
        chain::LLMChain,
        llm::{OpenAI, OpenAIConfig},
        prompt_args,
    };

    use crate::llm::{app_flowy_model::AttributeType, template::items_to_chain};

    use super::{AppFlowyTemplate, TemplateItem};

    #[tokio::test]
    async fn test_item_to_chain() {
        let mut app_flowy_template = AppFlowyTemplate {
            items: vec![
                TemplateItem {
                    prompt: "请帮我生成一份rust学习计划".to_string(),
                    index: 1,
                    next: Some(2),
                    attr_type: AttributeType::Prompt,
                    extra: None,
                },
                TemplateItem {
                    prompt: "请帮我分析学习计划中的难点".to_string(),
                    index: 2,
                    next: Some(3),
                    attr_type: AttributeType::Prompt,
                    extra: None,
                },
            ],
        };

        let separated_vecs = app_flowy_template.into_multiple();

        println!("length {:?}", separated_vecs.len());
        if separated_vecs.len() > 0 {
            let map = crate::llm::env_parse("env".to_owned()).unwrap();

            let base = map.get("LLM_BASE").unwrap();
            println!("base {:?}", base);
            let name = map.get("LLM_MODEL_NAME").unwrap();
            println!("name {:?}", name);
            let binding = "".to_string();
            let sk = map.get("LLM_SK").unwrap_or(&binding);
            println!("sk {:?}", sk);

            let llm = OpenAI::default()
                .with_config(OpenAIConfig::new().with_api_base(base).with_api_key(sk))
                .with_model(name);
            let s = items_to_chain(separated_vecs.first().unwrap(), llm);

            if let Some(c) = s.0 {
                // if let Some(_nc) = c.downcast_ref::<LLMChain>(){}
                // let type_id = (*c).type_id();
                // if type_id == TypeId::of::<LLMChain>() {

                //     let out =
                // }
                if let Some(p) = s.1 {
                    let output = c
                        .execute(prompt_args! {
                            "input0" => p
                        })
                        .await
                        .unwrap();

                    println!("{:?}", output);

                    let mut index = 0;
                    let mut map: HashMap<String, String> = HashMap::new();
                    // map.insert("input0".to_owned(), p.clone());
                    while index < separated_vecs.get(0).unwrap().len() {
                        let key = format!("input{}", index + 1);
                        let value = output.get(&key).unwrap();
                        map.insert(
                            separated_vecs
                                .get(0)
                                .unwrap()
                                .get(index)
                                .unwrap()
                                .prompt
                                .clone(),
                            value.to_string(),
                        );
                        index += 1;
                    }

                    println!("map {:?}", map);
                }
            }
        }
    }

    #[tokio::test]
    async fn test_item_to_chain_2() {
        let mut app_flowy_template = AppFlowyTemplate {
            items: vec![TemplateItem {
                prompt: "请帮我生成一份rust学习计划".to_string(),
                index: 1,
                next: None,
                attr_type: AttributeType::Prompt,
                extra: None,
            }],
        };

        let map = crate::llm::env_parse("env".to_owned()).unwrap();

        let base = map.get("LLM_BASE").unwrap();
        println!("base {:?}", base);
        let name = map.get("LLM_MODEL_NAME").unwrap();
        println!("name {:?}", name);
        let binding = "".to_string();
        let sk = map.get("LLM_SK").unwrap_or(&binding);
        println!("sk {:?}", sk);

        let llm = OpenAI::default()
            .with_config(OpenAIConfig::new().with_api_base(base).with_api_key(sk))
            .with_model(name);

        let separated_vecs = app_flowy_template.into_multiple();

        println!("length {:?}", separated_vecs.len());

        for i in separated_vecs {
            println!("[rust] chain length {}", i.len());
            let s = items_to_chain(&i, llm.clone());
            if let Some(c) = s.0 {
                if let Some(p) = s.1 {
                    let output = c
                        .execute(prompt_args! {
                            "input0" => p
                        })
                        .await
                        .unwrap();

                    println!("{:?}", output);
                } else {
                    let mut stream = c.stream(HashMap::new()).await.unwrap();

                    while let Some(result) = stream.next().await {
                        match result {
                            Ok(value) => value.to_stdout().unwrap(),
                            Err(e) => panic!("Error invoking LLMChain: {:?}", e),
                        }
                    }
                }
            }
        }
    }

    #[test]
    fn test_flow() {
        println!("app_flowy_template");
        let mut app_flowy_template = AppFlowyTemplate {
            items: vec![
                TemplateItem {
                    prompt: "First".to_string(),
                    index: 1,
                    next: Some(2),
                    attr_type: AttributeType::Prompt,
                    extra: None,
                },
                TemplateItem {
                    prompt: "Second".to_string(),
                    index: 2,
                    next: Some(3),
                    attr_type: AttributeType::Prompt,
                    extra: None,
                },
                TemplateItem {
                    prompt: "Third".to_string(),
                    index: 3,
                    next: None,
                    attr_type: AttributeType::Prompt,
                    extra: None,
                },
                TemplateItem {
                    prompt: "4".to_string(),
                    index: 4,
                    next: Some(5),
                    attr_type: AttributeType::Prompt,
                    extra: None,
                },
                TemplateItem {
                    prompt: "5".to_string(),
                    index: 5,
                    next: None,
                    attr_type: AttributeType::Prompt,
                    extra: None,
                },
                TemplateItem {
                    prompt: "6".to_string(),
                    index: 6,
                    next: None,
                    attr_type: AttributeType::Prompt,
                    extra: None,
                },
            ],
        };

        println!("here we go");

        let separated_vecs = app_flowy_template.into_multiple();

        println!("length {:?}", separated_vecs.len());

        // 打印结果
        for (i, vec) in separated_vecs.iter().enumerate() {
            println!("Sequence {}: {:?}", i + 1, vec);
        }
    }
}
