use langchain_rust::{
    chain::{LLMChain, LLMChainBuilder},
    llm::{Config, OpenAI},
    prompt::HumanMessagePromptTemplate,
    template_jinja2,
};
use serde::Deserialize;

#[derive(Deserialize)]
pub struct ChainIO {
    pub input_key: String,
    pub output_key: String,
    pub prompt: String,
}

#[derive(Deserialize)]
pub struct ChainIOes {
    pub items: Vec<ChainIO>,
}

impl ChainIO {
    fn to_prompt(&self) -> HumanMessagePromptTemplate {
        let f = self.prompt.replace("placeholder", &self.input_key);

        HumanMessagePromptTemplate::new(template_jinja2!(f, self.input_key))
    }

    pub fn to_chain<C: Config + Send + Sync + 'static>(
        &self,
        llm: OpenAI<C>,
    ) -> anyhow::Result<LLMChain> {
        anyhow::Ok(
            LLMChainBuilder::new()
                .prompt(self.to_prompt())
                .llm(llm.clone())
                .output_key(self.output_key.clone())
                .build()?,
        )
    }
}
