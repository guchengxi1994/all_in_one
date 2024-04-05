use crate::frb_generated::StreamSink;

use super::software_watcher::{
    software,
    watcher::{start_watch, WATCHING_LIST, WATCHING_MESSAGE_SINK},
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

pub fn software_watching_message_stream(s: StreamSink<Vec<i64>>) -> anyhow::Result<()> {
    let mut stream = WATCHING_MESSAGE_SINK.write().unwrap();
    *stream = Some(s);
    anyhow::Ok(())
}

pub fn add_to_watching_list(id: i64, name: String) {
    let mut list = WATCHING_LIST.write().unwrap();
    (*list).push((id, name))
}

pub fn init_watch(items: Vec<(i64, String)>) {
    {
        let mut list = WATCHING_LIST.write().unwrap();
        *list = items;
    }
    start_watch()
}
