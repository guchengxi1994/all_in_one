use std::{fs::File, io::Read, sync::RwLock};

use once_cell::sync::Lazy;
use serde::{Deserialize, Serialize};

use crate::errors::RustError;

#[derive(Default, Debug, Clone, PartialEq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Prompts {
    pub prompts: Vec<Prompt>,
}

#[derive(Default, Debug, Clone, PartialEq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Prompt {
    pub name: String,
    #[serde(rename = "type")]
    pub type_field: String,
    pub module: String,
    pub prompt: String,
    pub remark: String,
}

impl Prompts {
    pub fn from_str(s: String) -> anyhow::Result<Self> {
        let p: Self = serde_json::from_str(&s)?;
        anyhow::Ok(p)
    }

    pub fn from_path(s: String) -> anyhow::Result<Self> {
        let mut file = File::open(s)?;
        let mut contents = String::new();
        file.read_to_string(&mut contents)?;

        Self::from_str(contents)
    }

    pub fn get_by_name(&self, key:String,module:String)-> Option<String>{
        for i in &self.prompts{
            if i.module == module && i.name == key{
                return Some(i.prompt.clone());
            }
        }
        None
    }
}

pub static INERTNAL_PROMPTS: Lazy<RwLock<Option<Prompts>>> = Lazy::new(|| RwLock::new(None));

pub fn read_prompts_file(path: String) {
    let p = Prompts::from_path(path);
    match p {
        Ok(_p) => {
            let mut internal = INERTNAL_PROMPTS.write().unwrap();
            *internal = Some(_p);
        }
        Err(_e) => {
            let mut err: RustError = RustError::default();
            err.errmsg = "初始化prompt异常".to_owned();
            err.context = Some(format!("{:?}", _e));
            err.send_to_dart();
        }
    }
}
