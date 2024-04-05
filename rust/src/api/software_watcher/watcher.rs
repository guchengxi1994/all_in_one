use std::{collections::HashSet, sync::RwLock, time::Duration};

use flutter_rust_bridge::frb;
use once_cell::sync::Lazy;
use sysinfo::System;

use crate::frb_generated::StreamSink;

pub static WATCHING_LIST: Lazy<RwLock<Vec<(i64, String)>>> = Lazy::new(|| RwLock::new(vec![]));

pub static WATCHING_MESSAGE_SINK: RwLock<Option<StreamSink<Vec<i64>>>> = RwLock::new(None);

const SLEEP: u64 = 65;

#[frb(ignore)]
pub fn start_watch() {
    let mut sys = System::new();
    loop {
        let mut ids = HashSet::new();
        let list;
        {
            list = WATCHING_LIST.read().unwrap().clone();
        }

        sys.refresh_processes();
        for p in sys.processes() {
            for x in &list{
                if x.1 == p.1.name().to_lowercase() {
                    ids.insert(x.0);
                    break;
                }
            }
        }

        match WATCHING_MESSAGE_SINK.try_read() {
            Ok(s) => match s.as_ref() {
                Some(s0) => {
                    let _ = s0.add(ids.iter().cloned().collect());
                }
                None => {
                    println!("[rust-error] Stream is None");
                }
            },
            Err(_) => {
                println!("[rust-error] Stream read error");
            }
        }

        std::thread::sleep(Duration::from_secs(SLEEP));
    }
}
