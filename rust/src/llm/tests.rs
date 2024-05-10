#[allow(unused_imports)]
mod tests {
    use std::io::Write;

    use futures::StreamExt;
    use langchain_rust::{
        chain::{builder::ConversationalChainBuilder, Chain, LLMChainBuilder},
        fmt_message, fmt_template,
        language_models::llm::LLM,
        llm::{OpenAI, OpenAIConfig},
        memory::SimpleMemory,
        message_formatter,
        prompt::HumanMessagePromptTemplate,
        prompt_args,
        schemas::Message,
        sequential_chain, template_fstring, template_jinja2,
    };

    use crate::llm::{models::ChainIOes, sequential_chain_builder::CustomSequentialChain};

    #[test]
    fn uuid_test() {
        let u = uuid::Uuid::new_v4().to_string();
        println!("uuid : {:?}", u);
    }

    #[tokio::test]
    async fn test() {
        let map = crate::llm::env_parse("env".to_owned()).unwrap();

        let base = map.get("LLM_BASE").unwrap();
        println!("base {:?}", base);
        let name = map.get("LLM_MODEL_NAME").unwrap();
        println!("name {:?}", name);
        let binding = "".to_string();
        let sk = map.get("LLM_SK").unwrap_or(&binding);
        println!("sk {:?}", sk);

        let open_ai = OpenAI::default()
            .with_config(OpenAIConfig::new().with_api_base(base).with_api_key(sk))
            .with_model(name);

        let response = open_ai.invoke("how can langsmith help with testing?").await;
        println!("{:?}", response);
    }

    #[tokio::test]
    async fn test_stream() {
        let map = crate::llm::env_parse("env".to_owned()).unwrap();

        let base = map.get("LLM_BASE").unwrap();
        println!("base {:?}", base);
        let name = map.get("LLM_MODEL_NAME").unwrap();
        let binding = "".to_string();
        println!("name {:?}", name);
        let sk = map.get("LLM_SK").unwrap_or(&binding);
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

    #[tokio::test]
    async fn test_chain() {
        let map = crate::llm::env_parse("env".to_owned()).unwrap();

        let base = map.get("LLM_BASE").unwrap();
        println!("base {:?}", base);
        let name = map.get("LLM_MODEL_NAME").unwrap();
        println!("name {:?}", name);
        let binding = "".to_string();
        let sk = map.get("LLM_SK").unwrap_or(&binding);
        println!("sk {:?}", sk);

        let open_ai = OpenAI::default()
            .with_config(OpenAIConfig::new().with_api_base(base).with_api_key(sk))
            .with_model(name);

        let memory = SimpleMemory::new();
        let chain = ConversationalChainBuilder::new()
            .llm(open_ai)
            //IF YOU WANT TO ADD A CUSTOM PROMPT YOU CAN UN COMMENT THIS:
            //         .prompt(message_formatter![
            //             fmt_message!(Message::new_system_message("You are a helpful assistant")),
            //             fmt_template!(HumanMessagePromptTemplate::new(
            //             template_fstring!("
            // The following is a friendly conversation between a human and an AI. The AI is talkative and provides lots of specific details from its context. If the AI does not know the answer to a question, it truthfully says it does not know.
            //
            // Current conversation:
            // {history}
            // Human: {input}
            // AI:
            // ",
            //             "input","history")))
            //
            //         ])
            .memory(memory.into())
            .build()
            .expect("Error building ConversationalChain");

        let input_variables = prompt_args! {
            "input" => "我来自江苏常州。",
        };

        let mut stream = chain.stream(input_variables).await.unwrap();
        while let Some(result) = stream.next().await {
            match result {
                Ok(data) => {
                    //If you junt want to print to stdout, you can use data.to_stdout().unwrap();
                    print!("{}", data.content);
                    std::io::stdout().flush().unwrap();
                }
                Err(e) => {
                    println!("Error: {:?}", e);
                }
            }
        }

        let input_variables = prompt_args! {
            "input" => "常州有什么特产或者好玩的地方？",
        };
        match chain.invoke(input_variables).await {
            Ok(result) => {
                println!("\n");
                println!("Result: {:?}", result);
            }
            Err(e) => panic!("Error invoking LLMChain: {:?}", e),
        }
    }

    #[tokio::test]
    async fn sequential_chain_test() {
        let map = crate::llm::env_parse("env".to_owned()).unwrap();

        let base = map.get("LLM_BASE").unwrap();
        println!("base {:?}", base);
        let name = map.get("LLM_MODEL_NAME").unwrap();
        println!("name {:?}", name);
        let binding = "".to_string();
        let sk = map.get("LLM_SK").unwrap_or(&binding);
        println!("sk {:?}", sk);

        let llm = OpenAI::default()
            .with_config(OpenAIConfig::new().with_api_base(base).with_api_key(sk))
            .with_model(name);
        let prompt = HumanMessagePromptTemplate::new(template_jinja2!(
            "给我一个卖东西的商店起个有创意的名字: {{producto}}",
            "producto"
        ));

        let get_name_chain = LLMChainBuilder::new()
            .prompt(prompt)
            .llm(llm.clone())
            .output_key("name")
            .build()
            .unwrap();

        let prompt = HumanMessagePromptTemplate::new(template_jinja2!(
            "给我一个下一个名字的口号: {{name}}",
            "name"
        ));
        let get_slogan_chain = LLMChainBuilder::new()
            .prompt(prompt)
            .llm(llm.clone())
            .output_key("slogan")
            .build()
            .unwrap();

        let sequential_chain = sequential_chain!(get_name_chain, get_slogan_chain);

        print!("Please enter a product: ");
        std::io::stdout().flush().unwrap(); // Display prompt to terminal

        let mut product = String::new();
        std::io::stdin().read_line(&mut product).unwrap(); // Get product from terminal input

        let product = product.trim();
        let output = sequential_chain
            .execute(prompt_args! {
                "producto" => product
            })
            .await
            .unwrap();

        println!("Name: {}", output["name"]);
        println!("Slogan: {}", output["slogan"]);
    }

    #[tokio::test]
    async fn json_test() -> anyhow::Result<()> {
        let json_data = r#"
        {
            "items":[
                {
                    "input_key":"producto",
                    "output_key":"name",
                    "prompt":"给我一个卖东西的商店起个有创意的名字: {{placeholder}}"
                },
                {
                    "input_key":"name",
                    "output_key":"slogan",
                    "prompt":"给我一个下一个名字的口号: {{placeholder}}"
                }
            ]
        }
        "#;

        let map = crate::llm::env_parse("env".to_owned()).unwrap();

        let base = map.get("LLM_BASE").unwrap();
        println!("base {:?}", base);
        let name = map.get("LLM_MODEL_NAME").unwrap();
        println!("name {:?}", name);
        let binding = "".to_string();
        let sk = map.get("LLM_SK").unwrap_or(&binding);
        println!("sk {:?}", sk);

        let llm = OpenAI::default()
            .with_config(OpenAIConfig::new().with_api_base(base).with_api_key(sk))
            .with_model(name);

        let items: ChainIOes = serde_json::from_str(json_data)?;
        let seq = CustomSequentialChain {
            chains: items.items,
        };

        let seq_chain = seq.build(llm);

        match seq_chain {
            Some(_seq) => {
                let output = _seq
                    .execute(prompt_args! {
                        "producto" => "shoe"
                    })
                    .await
                    .unwrap();
                println!("Name: {}", output["name"]);
                println!("Slogan: {}", output["slogan"]);
            }
            None => {
                println!("none");
            }
        }

        anyhow::Ok(())
    }
}
