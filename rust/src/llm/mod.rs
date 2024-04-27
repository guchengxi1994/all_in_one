use dotenv::dotenv;
use once_cell::sync::Lazy;
use std::sync::RwLock;

#[allow(unused_imports)]
mod tests {

    use dotenv::dotenv;
    use langchain_rust::{
        language_models::llm::LLM,
        llm::{OpenAI, OpenAIConfig},
    };

    #[tokio::test]
    async fn test() {
        dotenv().ok();

        let base = std::env::var("LLM_BASE").unwrap();
        let name = std::env::var("LLM_MODEL_NAME").unwrap();

        let open_ai = OpenAI::default()
            .with_config(OpenAIConfig::new().with_api_base(base))
            .with_model(name);

        let response = open_ai.invoke("who are you").await;
        println!("{:?}", response);
    }
}

pub static ENV_PARAMS: Lazy<RwLock<Option<EnvParams>>> = Lazy::new(|| RwLock::new(None));

#[derive(Debug, Clone)]
pub struct EnvParams {
    pub base: String,
    pub name: String,
    pub chat_base: String,
}

pub fn init(p: Option<String>) {
    match p {
        Some(_p) => {
            dotenv::from_path(_p);
        }
        None => {
            dotenv().ok();
        }
    }

    let base = std::env::var("LLM_BASE").unwrap_or("".to_owned());
    let name = std::env::var("LLM_MODEL_NAME").unwrap_or("".to_owned());
    let chat_base = std::env::var("CHAT_CHAT_BASE").unwrap_or("".to_owned());

    {
        let mut r = ENV_PARAMS.write().unwrap();
        *r = Some(EnvParams {
            base,
            name,
            chat_base,
        });
    }
}
