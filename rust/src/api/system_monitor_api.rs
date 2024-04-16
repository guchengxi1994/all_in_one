use flutter_rust_bridge::frb;

use crate::{
    frb_generated::StreamSink,
    system_monitor::{MonitorInfo, SYS_MONITOR_MESSAGE_SINK},
};

#[frb(sync)]
pub fn system_monitor_message_stream(s: StreamSink<MonitorInfo>) -> anyhow::Result<()> {
    let mut stream = SYS_MONITOR_MESSAGE_SINK.write().unwrap();
    *stream = Some(s);
    anyhow::Ok(())
}

pub fn start_system_monitor() {
    crate::system_monitor::start_monitor()
}
