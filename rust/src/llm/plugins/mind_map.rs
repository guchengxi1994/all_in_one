use std::sync::RwLock;

use crate::llm::internal_prompts::INERTNAL_PROMPTS;
use crate::llm::StreamSink;
use crate::llm::OPENAI;
use futures::StreamExt;
use langchain_rust::language_models::llm::LLM;
use langchain_rust::schemas::Message;

pub static MIND_MAP_MESSAGE_SINK: RwLock<Option<StreamSink<String>>> = RwLock::new(None);

pub async fn text_to_mind_map(s: String) {
    let prompts = INERTNAL_PROMPTS.read().unwrap();

    if let Some(_p) = prompts.clone() {
        let open_ai;
        {
            open_ai = OPENAI.read().unwrap();
        }
        let mut history = Vec::new();

        let system_role = _p.get_by_name("role-define".to_owned(), "conversion".to_owned());

        if system_role.is_none() {
            return;
        }

        history.push(Message::new_system_message(system_role.unwrap()));

        let inst = _p.get_by_name(
            "convert-file-to-mind-map".to_owned(),
            "conversion".to_owned(),
        );

        if inst.is_none() {
            return;
        }

        history.push(Message::new_human_message(inst.unwrap()));
        history.push(Message::new_human_message(s));

        let mut sm = open_ai.stream(&history).await.unwrap();

        while let Some(result) = sm.next().await {
            match result {
                Ok(value) => {
                    println!("{:?}", value.content);
                    match MIND_MAP_MESSAGE_SINK.try_read() {
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
                    }
                }
                Err(_e) => {
                    println!("Error invoking LLMChain: {:?}", _e);
                }
            }
        }

        match MIND_MAP_MESSAGE_SINK.try_read() {
            Ok(s) => match s.as_ref() {
                Some(s0) => {
                    let _ = s0.add("!over!".to_owned());
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
}
