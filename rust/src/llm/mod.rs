pub mod app_flowy_model;
pub mod internal_prompts;
pub mod plugins;
pub mod template;

use once_cell::sync::Lazy;
use std::collections::HashMap;
use std::fs::File;
use std::io::{BufRead, BufReader};
use std::sync::RwLock;

use crate::frb_generated::StreamSink;

pub static ENV_PARAMS: Lazy<RwLock<Option<EnvParams>>> = Lazy::new(|| RwLock::new(None));

#[derive(Debug, Clone)]
pub struct EnvParams {
    pub base: String,
    pub name: String,
    pub chat_base: String,
    pub sk: Option<String>,
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
