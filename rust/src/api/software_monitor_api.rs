use crate::frb_generated::StreamSink;

use crate::software_monitor::foreground_monitor::start_monitor_with_foreground;
use crate::software_monitor::foreground_monitor::WATCHING_FOREGROUND_MESSAGE_SINK;
use crate::software_monitor::{
    monitor::{start_watch, WATCHING_LIST, WATCHING_MESSAGE_SINK},
    software,
};
use winreg::enums::{HKEY_CURRENT_USER, HKEY_LOCAL_MACHINE};

#[cfg(windows)]
pub fn get_windows_installed_softwares() -> Vec<software::Software> {
    let local = software::_Hkey(HKEY_LOCAL_MACHINE);
    let user = software::_Hkey(HKEY_CURRENT_USER);

    let mut v1 = local.get_all();
    let v2 = user.get_all();

    v1.extend(v2);
    v1
}

#[flutter_rust_bridge::frb(sync)]
pub fn software_watching_message_stream(s: StreamSink<Vec<i64>>) -> anyhow::Result<()> {
    let mut stream = WATCHING_MESSAGE_SINK.write().unwrap();
    *stream = Some(s);
    anyhow::Ok(())
}

#[flutter_rust_bridge::frb(sync)]
#[cfg(windows)]
pub fn software_watching_with_foreground_message_stream(
    s: StreamSink<(Vec<i64>, String)>,
) -> anyhow::Result<()> {
    use flutter_rust_bridge::frb;

    let mut stream = WATCHING_FOREGROUND_MESSAGE_SINK.write().unwrap();
    *stream = Some(s);
    anyhow::Ok(())
}

pub fn add_to_watching_list(id: i64, name: String) {
    let mut list = WATCHING_LIST.write().unwrap();
    (*list).push((id, name))
}

pub fn remove_from_watching_list(id: i64) {
    let mut list = WATCHING_LIST.write().unwrap();
    // (*list).push((id, name))
    list.retain(|x| x.0 != id);
}

#[cfg(linux)]
pub fn init_monitor(items: Vec<(i64, String)>) {
    {
        let mut list = WATCHING_LIST.write().unwrap();
        *list = items;
    }
    start_watch()
}

#[cfg(windows)]
pub fn init_monitor(items: Vec<(i64, String)>) {
    {
        let mut list = WATCHING_LIST.write().unwrap();
        *list = items;
    }
    start_monitor_with_foreground()
}
