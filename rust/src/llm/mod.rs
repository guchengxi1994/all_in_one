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
