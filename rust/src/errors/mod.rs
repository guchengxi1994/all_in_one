use std::sync::RwLock;

use crate::frb_generated::StreamSink;

#[derive(Debug, Clone)]
pub enum ErrorModule {
    Template,
    LLMChat,
    Monitors,
}

#[derive(Debug, Clone)]
pub enum ErrorType {
    Recoverable,
    Unrecoverable,
}

#[derive(Debug, Clone)]
pub struct RustError {
    pub module: ErrorModule,
    pub _type: ErrorType,
    pub errmsg: String,
    pub context: Option<String>,
}

impl RustError {
    pub fn default() -> Self {
        RustError {
            module: ErrorModule::Template,
            _type: ErrorType::Unrecoverable,
            errmsg: "".to_owned(),
            context: None,
        }
    }

    pub fn send_to_dart(self) {
        match ERROR_MESSAGE_SINK.try_read() {
            Ok(s) => match s.as_ref() {
                Some(s0) => {
                    let _ = s0.add(self);
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

pub static ERROR_MESSAGE_SINK: RwLock<Option<StreamSink<RustError>>> = RwLock::new(None);
