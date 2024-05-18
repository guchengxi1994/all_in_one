use futures::StreamExt;
use langchain_rust::language_models::llm::LLM;
use langchain_rust::schemas::Message;
use std::sync::RwLock;

use crate::llm::StreamSink;

use super::OPENAI;

pub static AI_HELPER_MESSAGE_SINK: RwLock<Option<StreamSink<String>>> = RwLock::new(None);

pub async fn ai_quick_request(s: String) {
    let open_ai;
    {
        open_ai = OPENAI.read().unwrap();
    }
    let mut sm = open_ai
        .stream(&vec![Message::new_human_message(s)])
        .await
        .unwrap();

    while let Some(result) = sm.next().await {
        match result {
            Ok(value) => match AI_HELPER_MESSAGE_SINK.try_read() {
                Ok(s) => match s.as_ref() {
                    Some(s0) => {
                        let _ = s0.add(value.content);
                    }
                    None => {
                        println!("[rust-error] Stream is None");
                    }
                },
                Err(_) => {
                    println!("[rust-error] Stream read error");
                }
            },
            Err(e) => {
                println!("Error invoking LLMChain: {:?}", e);
            }
        }
    }
}
