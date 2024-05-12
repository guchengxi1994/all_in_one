use flutter_rust_bridge::frb;

use crate::{
    frb_generated::StreamSink,
    llm::{
        app_flowy_model::{str_to_doc, template_renderer_impl, Root},
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
pub fn template_message_stream(s: StreamSink<TemplateResult>) -> anyhow::Result<()> {
    let mut stream = TEMPLATE_MESSAGE_SINK.write().unwrap();
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

pub fn template_to_prompts(template: String) -> Vec<String> {
    let r = crate::llm::app_flowy_model::get_all_cadidates(template);
    if let Ok(_r) = r {
        return _r;
    }
    return vec![];
}

pub fn generate_from_template(v: Vec<(String, u32, Option<u32>)>) {
    let rt = tokio::runtime::Runtime::new().unwrap();
    rt.block_on(async {
        let list = generate_template_items_from_list(v);
        let mut a = AppFlowyTemplate::from(list);
        a.execute().await;
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
