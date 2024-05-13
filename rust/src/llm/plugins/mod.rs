use async_openai::config::OpenAIConfig;

use super::ENV_PARAMS;

pub mod chat_file;

pub fn get_openai_client() -> (Option<async_openai::Client<OpenAIConfig>>,Option<String>) {
    let params = ENV_PARAMS.read().unwrap();
    match params.clone() {
        Some(_p) => {
            return (Some(async_openai::Client::with_config(
                OpenAIConfig::new()
                    .with_api_base(_p.base)
                    .with_api_key(_p.sk.unwrap()),
            )),Some(_p.name) );
        }
        None => {
            return (None,None);
        }
    }
}
