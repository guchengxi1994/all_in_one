use crate::{
    errors::{RustError, ERROR_MESSAGE_SINK},
    frb_generated::StreamSink,
};
use flutter_rust_bridge::frb;
#[flutter_rust_bridge::frb(sync)] // Synchronous mode for simplicity of the demo
pub fn greet(name: String) -> String {
    format!("Hello, {name}!")
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}

#[frb(sync)]
pub fn rust_error_stream(s: StreamSink<RustError>) -> anyhow::Result<()> {
    let mut stream = ERROR_MESSAGE_SINK.write().unwrap();
    *stream = Some(s);
    anyhow::Ok(())
}
