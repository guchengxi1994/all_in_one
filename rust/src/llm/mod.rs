pub mod app_flowy_model;
pub mod models;
pub mod sequential_chain_builder;
mod tests;
pub mod template;

use futures::StreamExt;
use langchain_rust::chain::Chain;
use langchain_rust::language_models::llm::LLM;
use langchain_rust::prompt_args;
use langchain_rust::{
    llm::{OpenAI, OpenAIConfig},
    schemas::Message,
};
use once_cell::sync::Lazy;
use std::collections::HashMap;
use std::fs::File;
use std::io::{BufRead, BufReader};
use std::sync::RwLock;

use crate::frb_generated::StreamSink;

use self::models::ChainIOes;
use self::sequential_chain_builder::CustomSequentialChain;

pub static ENV_PARAMS: Lazy<RwLock<Option<EnvParams>>> = Lazy::new(|| RwLock::new(None));

pub static OPENAI: Lazy<RwLock<OpenAI<OpenAIConfig>>> = Lazy::new(|| {
    let params;
    {
        params = ENV_PARAMS.read().unwrap().clone().unwrap();
    }
    let open_ai = OpenAI::default()
        .with_config(
            OpenAIConfig::new()
                .with_api_base(params.base)
                .with_api_key(params.sk.unwrap()),
        )
        .with_model(params.name);

    RwLock::new(open_ai)
});

#[derive(Debug, Clone)]
pub struct EnvParams {
    pub base: String,
    pub name: String,
    pub chat_base: String,
    pub sk: Option<String>,
}

pub fn init(p: String) {
    // match p {
    //     Some(_p) => {
    //         let _ = dotenv::from_path(_p);
    //     }
    //     None => {
    //         dotenv().ok();
    //     }
    // }

    let map = crate::llm::env_parse(p).unwrap();

    let base = map.get("LLM_BASE").unwrap().to_string();
    let name = map.get("LLM_MODEL_NAME").unwrap().to_string();
    let sk = map.get("LLM_SK").unwrap_or(&"".to_string()).to_string();
    let chat_base = map
        .get("CHAT_CHAT_BASE")
        .unwrap_or(&"".to_string())
        .to_string();

    {
        let mut r = ENV_PARAMS.write().unwrap();
        *r = Some(EnvParams {
            base,
            name,
            chat_base,
            sk: Some(sk),
        });
    }
}

pub static LLM_MESSAGE_SINK: RwLock<Option<StreamSink<LLMMessage>>> = RwLock::new(None);

#[derive(Debug, Clone)]
pub struct LLMMessage {
    pub uuid: String,
    pub content: String,
    pub _type: u8, // 0 human,1 system,2 ai, 3 tool,
}

impl LLMMessage {
    pub fn default() -> Self {
        LLMMessage {
            uuid: "".to_owned(),
            content: "".to_owned(),
            _type: 2,
        }
    }
}

pub async fn chat(
    _uuid: Option<String>,
    _history: Option<Vec<LLMMessage>>,
    stream: bool,
    query: String,
) {
    let open_ai;
    {
        open_ai = OPENAI.read().unwrap();
    }

    let mut message = LLMMessage::default();
    if _uuid.is_none() {
        message.uuid = uuid::Uuid::new_v4().to_string();
    } else {
        message.uuid = _uuid.unwrap();
    }

    let mut history = Vec::new();
    if !_history.is_none() {
        history = _history
            .unwrap()
            .iter()
            .map(|x| match x._type {
                0 => Message::new_human_message(x.content.clone()),
                1 => Message::new_system_message(x.content.clone()),
                2 => Message::new_ai_message(x.content.clone()),
                _ => Message::new_human_message(x.content.clone()),
            })
            .collect()
    }
    history.push(Message::new_human_message(query.clone()));

    if stream {
        let mut sm = open_ai.stream(&history).await.unwrap();

        while let Some(result) = sm.next().await {
            match result {
                Ok(value) => {
                    message.content = value.content;

                    match LLM_MESSAGE_SINK.try_read() {
                        Ok(s) => match s.as_ref() {
                            Some(s0) => {
                                let _ = s0.add(message.clone());
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
        message.content = "!over!".to_owned();
        match LLM_MESSAGE_SINK.try_read() {
            Ok(s) => match s.as_ref() {
                Some(s0) => {
                    let _ = s0.add(message.clone());
                }
                None => {
                    println!("[rust-error] Stream is None");
                }
            },
            Err(_) => {
                println!("[rust-error] Stream read error");
            }
        }
    } else {
        let response = open_ai.generate(&history).await;
        // println!("{:?}", response);
        match response {
            Ok(_r) => {
                message.content = _r.generation;
                match LLM_MESSAGE_SINK.try_read() {
                    Ok(s) => match s.as_ref() {
                        Some(s0) => {
                            let _ = s0.add(message.clone());
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
            Err(e) => {
                println!("[rust] error {:?}", e);
                message.content = e.to_string();
                match LLM_MESSAGE_SINK.try_read() {
                    Ok(s) => match s.as_ref() {
                        Some(s0) => {
                            let _ = s0.add(message.clone());
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

        message.content = "!over!".to_owned();
        match LLM_MESSAGE_SINK.try_read() {
            Ok(s) => match s.as_ref() {
                Some(s0) => {
                    let _ = s0.add(message);
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

pub async fn sequential_chain_chat(json_str: String, query: String) -> anyhow::Result<()> {
    let open_ai;
    {
        open_ai = OPENAI.read().unwrap();
    }
    let items: ChainIOes = serde_json::from_str(&json_str)?;
    let first_input = items.items.first().unwrap().input_key.clone();
    let seq = CustomSequentialChain {
        chains: items.items,
    };

    let seq_chain = seq.build(open_ai.clone());
    match seq_chain {
        Some(_seq) => {
            let output = _seq
                .execute(prompt_args! {
                    first_input => query
                })
                .await
                .unwrap();
            println!("output: {:?}", output);
        }
        None => {
            println!("none");
        }
    }

    anyhow::Ok(())
}

pub fn env_parse(path: String) -> anyhow::Result<HashMap<String, String>> {
    let mut res = HashMap::new();
    let file = File::open(path)?;
    let reader = BufReader::new(file);
    let lines = reader.lines();

    for i in lines {
        let _line = i?;
        let sep = _line.split("=").collect::<Vec<_>>();
        if sep.len() == 2 {
            res.insert(
                sep.first().unwrap().trim().to_owned(),
                sep.last().unwrap().trim().to_owned(),
            );
        }
    }

    anyhow::Ok(res)
}
