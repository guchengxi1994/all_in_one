use flutter_rust_bridge::frb;

use crate::{
    frb_generated::StreamSink,
    llm::{EnvParams, LLMMessage, ENV_PARAMS, LLM_MESSAGE_SINK},
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

pub fn chat(_uuid: Option<String>, _history: Option<Vec<LLMMessage>>, stream: bool, query: String) {
    let rt = tokio::runtime::Runtime::new().unwrap();
    rt.block_on(async { crate::llm::chat(_uuid, _history, stream, query).await });
}

pub fn sequential_chain_chat(json_str: String, query: String) {
    let rt = tokio::runtime::Runtime::new().unwrap();
    let _ = rt.block_on(async { crate::llm::sequential_chain_chat(json_str, query).await });
}
