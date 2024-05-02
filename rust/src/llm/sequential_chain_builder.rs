use langchain_rust::{chain::{SequentialChain, SequentialChainBuilder}, llm::{Config, OpenAI}};

use super::models::ChainIO;

pub struct CustomSequentialChain {
    pub chains: Vec<ChainIO>,
}

impl CustomSequentialChain {
    pub fn build<C: Config + Send + Sync + 'static>(&self, llm: OpenAI<C>) -> Option<SequentialChain> {
        let mut seq_chain = SequentialChainBuilder::new();

        for i in &self.chains{
            let _c = i.to_chain(llm.clone());
            if let Ok(_c) = _c {
                seq_chain = seq_chain.add_chain(_c);
            }else{
                return None;
            }
        }

        Some(seq_chain.build())
    }
}
