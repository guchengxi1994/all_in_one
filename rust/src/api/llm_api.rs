use flutter_rust_bridge::frb;

use crate::llm::{EnvParams, ENV_PARAMS};

#[frb(sync)]
pub fn init_llm(p: Option<String>) {
    crate::llm::init(p)
}

#[frb(sync)]
pub fn get_llm_config() -> Option<EnvParams> {
    let r = ENV_PARAMS.read().unwrap();
    (*r).clone()
}
