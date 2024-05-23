use flutter_rust_bridge::frb;

use crate::llm::ai_helper::AI_HELPER_MESSAGE_SINK;
use crate::{
    errors::{RustError, ERROR_MESSAGE_SINK},
    frb_generated::StreamSink,
    llm::{
        app_flowy_model::{str_to_doc, template_renderer_impl, AttributeType, Root},
        template::{
            generate_template_items_from_list, AppFlowyTemplate, TemplateResult,
            TemplateRunningStage, TEMPLATE_MESSAGE_SINK, TEMPLATE_STATE_SINK,
        },
        EnvParams, LLMMessage, ENV_PARAMS, LLM_MESSAGE_SINK,
    },
};

#[frb(sync)]
pub fn init_llm(p: String) {
    crate::llm::init(p)
}

#[frb(sync)]
pub fn get_llm_config() -> Option<EnvParams> {
    let r = ENV_PARAMS.read().unwrap();
    (*r).clone()
}

#[flutter_rust_bridge::frb(sync)]
pub fn llm_message_stream(s: StreamSink<LLMMessage>) -> anyhow::Result<()> {
    let mut stream = LLM_MESSAGE_SINK.write().unwrap();
    *stream = Some(s);
    anyhow::Ok(())
}

#[flutter_rust_bridge::frb(sync)]
pub fn ai_helper_message_stream(s: StreamSink<String>) -> anyhow::Result<()> {
    let mut stream = AI_HELPER_MESSAGE_SINK.write().unwrap();
    *stream = Some(s);
    anyhow::Ok(())
}

#[flutter_rust_bridge::frb(sync)]
pub fn template_message_stream(s: StreamSink<TemplateResult>) -> anyhow::Result<()> {
    let mut stream = TEMPLATE_MESSAGE_SINK.write().unwrap();
    *stream = Some(s);
    anyhow::Ok(())
}

#[flutter_rust_bridge::frb(sync)]
pub fn error_message_stream(s: StreamSink<RustError>) -> anyhow::Result<()> {
    let mut stream = ERROR_MESSAGE_SINK.write().unwrap();
    *stream = Some(s);
    anyhow::Ok(())
}

#[flutter_rust_bridge::frb(sync)]
pub fn template_state_stream(s: StreamSink<TemplateRunningStage>) -> anyhow::Result<()> {
    let mut stream = TEMPLATE_STATE_SINK.write().unwrap();
    *stream = Some(s);
    anyhow::Ok(())
}

pub fn chat(_uuid: Option<String>, _history: Option<Vec<LLMMessage>>, stream: bool, query: String) {
    let rt = tokio::runtime::Runtime::new().unwrap();
    rt.block_on(async { crate::llm::chat(_uuid, _history, stream, query).await });
}

pub fn sequential_chain_chat(json_str: String, query: String) {
    let rt = tokio::runtime::Runtime::new().unwrap();
    let _ = rt.block_on(async { crate::llm::sequential_chain_chat(json_str, query).await });
}

pub fn template_renderer(template: String) -> Option<String> {
    let rt = tokio::runtime::Runtime::new().unwrap();
    if let Ok(res) = rt.block_on(async { template_renderer_impl(template).await }) {
        return Some(res);
    }

    None
}

pub fn template_to_prompts(template: String) -> Vec<(String, AttributeType, Option<String>)> {
    let r = crate::llm::app_flowy_model::get_all_cadidates(template);
    if let Ok(_r) = r {
        return _r;
    } else {
        println!("template_to_prompts error {:?}", r.err());
    }
    return vec![];
}

pub fn generate_from_template(
    v: Vec<(String, u32, Option<u32>, AttributeType, Option<String>)>,
    enable_plugin: bool,
) {
    let rt = tokio::runtime::Runtime::new().unwrap();
    rt.block_on(async {
        let list = generate_template_items_from_list(v);
        let mut a = AppFlowyTemplate::from(list);
        a.execute(enable_plugin).await;
    });
}

pub fn optimize_doc(s: String) -> String {
    let rt = tokio::runtime::Runtime::new().unwrap();
    rt.block_on(async { crate::llm::template::optimize_doc(s).await })
}

#[flutter_rust_bridge::frb(sync)]
pub fn get_doc_root_from_str(s: String) -> Option<Root> {
    let r = str_to_doc(s);
    if let Ok(_r) = r {
        return Some(_r);
    }

    None
}

pub fn ai_helper_quick_request(
    s: String,
    tone: String,
    lang: String,
    length: String,
    extra: Vec<String>,
) {
    let mut requirements: Vec<String> = extra;
    let mut prompt = s.clone();
    if lang != "中文" {
        requirements.push(format!("请使用{}回答", lang));
    }
    match length.as_str() {
        "中等的" => {
            requirements.push("结果在500~1000字".to_string());
        }
        "短文" => {
            requirements.push("结果在500字以内".to_string());
        }
        "长文" => {
            requirements.push("结果在1000~1500字".to_string());
        }
        _ => {}
    }

    if tone != "正常的" {
        requirements.push(format!("请使用{}口吻回答", tone));
    }

    if !requirements.is_empty() {
        prompt = format!("{}。要求如下: {}", s, requirements.join(";"));
        println!("[rust] final prompt {:?}", prompt)
    }

    let rt = tokio::runtime::Runtime::new().unwrap();
    rt.block_on(async { crate::llm::ai_helper::ai_quick_request(prompt).await });
}

#[flutter_rust_bridge::frb(sync)]
pub fn init_prompt_from_path(s: String) {
    crate::llm::internal_prompts::read_prompts_file(s);
}
