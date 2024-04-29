use dotenv::dotenv;
use futures::StreamExt;
use langchain_rust::language_models::llm::LLM;
use langchain_rust::{
    llm::{OpenAI, OpenAIConfig},
    schemas::Message,
};
use once_cell::sync::Lazy;
use std::sync::RwLock;

use crate::frb_generated::StreamSink;

#[allow(unused_imports)]
mod tests {
    use dotenv::dotenv;
    use futures::StreamExt;
    use langchain_rust::{
        chain::{Chain, LLMChainBuilder},
        fmt_message, fmt_template,
        language_models::llm::LLM,
        llm::{OpenAI, OpenAIConfig},
        message_formatter,
        prompt::HumanMessagePromptTemplate,
        prompt_args,
        schemas::Message,
        template_fstring,
    };

    #[test]
    fn uuid_test() {
        let u = uuid::Uuid::new_v4().to_string();
        println!("uuid : {:?}", u);
    }

    #[tokio::test]
    async fn test() {
        dotenv().ok();

        let base = std::env::var("LLM_BASE").unwrap();
        println!("base {:?}", base);
        let name = std::env::var("LLM_MODEL_NAME").unwrap();
        println!("name {:?}", name);
        let sk = std::env::var("LLM_SK").unwrap_or("".to_owned());
        println!("sk {:?}", sk);

        let open_ai = OpenAI::default()
            .with_config(OpenAIConfig::new().with_api_base(base).with_api_key(sk))
            .with_model(name);

        let response = open_ai.invoke("how can langsmith help with testing?").await;
        println!("{:?}", response);
    }

    #[tokio::test]
    async fn test_stream() {
        dotenv().ok();

        let base = std::env::var("LLM_BASE").unwrap();
        println!("base {:?}", base);
        let name = std::env::var("LLM_MODEL_NAME").unwrap();
        println!("name {:?}", name);
        let sk = std::env::var("LLM_SK").unwrap_or("".to_owned());
        println!("sk {:?}", sk);

        let open_ai = OpenAI::default()
            .with_config(OpenAIConfig::new().with_api_base(base).with_api_key(sk))
            .with_model(name);

        let mut stream = open_ai
            .stream(&[
                Message::new_human_message("你是一个私有化AI助理。"),
                Message::new_human_message("请问如何使用rust实现链表。"),
            ])
            .await
            .unwrap();

        while let Some(result) = stream.next().await {
            match result {
                Ok(value) => value.to_stdout().unwrap(),
                Err(e) => panic!("Error invoking LLMChain: {:?}", e),
            }
        }
    }
}

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

pub fn init(p: Option<String>) {
    match p {
        Some(_p) => {
            let _ = dotenv::from_path(_p);
        }
        None => {
            dotenv().ok();
        }
    }

    let base = std::env::var("LLM_BASE").unwrap_or("".to_owned());
    let name = std::env::var("LLM_MODEL_NAME").unwrap_or("".to_owned());
    let chat_base = std::env::var("CHAT_CHAT_BASE").unwrap_or("".to_owned());
    let sk = std::env::var("LLM_SK").unwrap_or("".to_owned());

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

#[derive(Debug,Clone)]
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
    } else {
        let response = open_ai.generate(&history).await;
        // println!("{:?}", response);
        match response {
            Ok(_r) => {
                message.content = _r.generation;
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
            Err(e) => {
                println!("[rust] error {:?}", e);
                message.content = e.to_string();
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
    }
}
