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

use crate::frb_generated::StreamSink;

use super::OPENAI;

pub enum TemplateRunningStage {
    Format,
    Eval,
    Optimize,
    Done,
}

pub struct AppFlowyTemplate {
    pub items: Vec<TemplateItem>,
}

#[derive(Debug, Clone)]
pub struct TemplateItem {
    pub prompt: String,
    pub index: u32,
    pub next: Option<u32>,
}

impl TemplateItem {
    pub fn from(i: (String, u32, Option<u32>)) -> Self {
        Self {
            prompt: i.0,
            index: i.1,
            next: i.2,
        }
    }
}

pub fn generate_template_items_from_list(
    list: Vec<(String, u32, Option<u32>)>,
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
    match TEMPLATE_STATE_SINK.try_read() {
        Ok(s) => match s.as_ref() {
            Some(s0) => {
                let _ = s0.add(TemplateRunningStage::Optimize);
            }
            None => {
                println!("[rust-error] Stream is None");
            }
        },
        Err(_) => {
            println!("[rust-error] Stream read error");
        }
    }

    let open_ai;
    {
        open_ai = OPENAI.read().unwrap();
    }

    let out = open_ai
        .clone()
        .generate(&[
            Message::new_system_message("你是一个专业的作家，适合优化文章脉络和措辞，使得文章表达更加详实、具体，观点清晰。"),
            Message::new_human_message("请帮我改写优化以下文章。注意：1.进行文章改写时请尽量使用简体中文。2.只需要改写优化<rewrite> </rewrite>标签中的部分，其余部分保持原样即可。3.最终结果中不需要返回<rewrite> </rewrite>标签。"),
            Message::new_human_message(doc),
        ])
        .await
        .unwrap();

    println!("[rust] final generate result: {}", out.generation);

    match TEMPLATE_STATE_SINK.try_read() {
        Ok(s) => match s.as_ref() {
            Some(s0) => {
                let _ = s0.add(TemplateRunningStage::Done);
            }
            None => {
                println!("[rust-error] Stream is None");
            }
        },
        Err(_) => {
            println!("[rust-error] Stream read error");
        }
    }

    out.generation
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

    pub async fn execute(&mut self) {
        match TEMPLATE_STATE_SINK.try_read() {
            Ok(s) => match s.as_ref() {
                Some(s0) => {
                    let _ = s0.add(TemplateRunningStage::Format);
                }
                None => {
                    println!("[rust-error] Stream is None");
                }
            },
            Err(_) => {
                println!("[rust-error] Stream read error");
            }
        }

        let separated_vecs = self.into_multiple();
        println!("[rust] separated_vecs length {}", separated_vecs.len());
        if separated_vecs.is_empty() {
            match TEMPLATE_STATE_SINK.try_read() {
                Ok(s) => match s.as_ref() {
                    Some(s0) => {
                        let _ = s0.add(TemplateRunningStage::Done);
                    }
                    None => {
                        println!("[rust-error] Stream is None");
                    }
                },
                Err(_) => {
                    println!("[rust-error] Stream read error");
                }
            }
            return;
        }

        let open_ai;
        {
            open_ai = OPENAI.read().unwrap();
        }

        match TEMPLATE_STATE_SINK.try_read() {
            Ok(s) => match s.as_ref() {
                Some(s0) => {
                    let _ = s0.add(TemplateRunningStage::Eval);
                }
                None => {
                    println!("[rust-error] Stream is None");
                }
            },
            Err(_) => {
                println!("[rust-error] Stream read error");
            }
        }

        for i in separated_vecs {
            println!("[rust] chain length {}", i.len());
            let s = items_to_chain(&i, open_ai.clone());
            if let Some(c) = s.0 {
                if let Some(p) = s.1 {
                    let output = c
                        .execute(prompt_args! {
                            "input0" => p
                        })
                        .await
                        .unwrap();

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
                    let mut stream = c.stream(HashMap::new()).await.unwrap();

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

    use crate::llm::template::items_to_chain;

    use super::{AppFlowyTemplate, TemplateItem};

    #[tokio::test]
    async fn test_item_to_chain() {
        let mut app_flowy_template = AppFlowyTemplate {
            items: vec![
                TemplateItem {
                    prompt: "请帮我生成一份rust学习计划".to_string(),
                    index: 1,
                    next: Some(2),
                },
                TemplateItem {
                    prompt: "请帮我分析学习计划中的难点".to_string(),
                    index: 2,
                    next: Some(3),
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
                },
                TemplateItem {
                    prompt: "Second".to_string(),
                    index: 2,
                    next: Some(3),
                },
                TemplateItem {
                    prompt: "Third".to_string(),
                    index: 3,
                    next: None,
                },
                TemplateItem {
                    prompt: "4".to_string(),
                    index: 4,
                    next: Some(5),
                },
                TemplateItem {
                    prompt: "5".to_string(),
                    index: 5,
                    next: None,
                },
                TemplateItem {
                    prompt: "6".to_string(),
                    index: 6,
                    next: None,
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
