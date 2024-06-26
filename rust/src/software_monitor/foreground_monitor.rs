use crate::frb_generated::StreamSink;
use std::sync::RwLock;

pub static WATCHING_FOREGROUND_MESSAGE_SINK: RwLock<Option<StreamSink<(Vec<i64>, String)>>> =
    RwLock::new(None);

#[cfg(target_os = "windows")]
pub mod windows {
    use std::collections::HashSet;

    use cron_job::CronJob;

    use sysinfo::System;
    use winapi::um::winuser::{GetForegroundWindow, GetWindowThreadProcessId};

    use crate::software_monitor::monitor::WATCHING_LIST;

    use super::WATCHING_FOREGROUND_MESSAGE_SINK;

    pub fn start_monitor_with_foreground() {
        let mut sys = System::new();
        let mut cron = CronJob::default();

        cron.new_job("0 */1 * * * *", move || {
            let foreground_pid = get_foreground_pid();
            let mut name = "".to_owned();
            let mut ids = HashSet::new();
            let list;
            {
                list = WATCHING_LIST.read().unwrap().clone();
            }

            sys.refresh_processes();
            for p in sys.processes() {
                if p.0.as_u32() == foreground_pid {
                    name = p.1.name().to_owned();
                }

                for x in &list {
                    if x.1 == p.1.name().to_lowercase() {
                        ids.insert(x.0);
                        break;
                    }
                }
            }

            match WATCHING_FOREGROUND_MESSAGE_SINK.try_read() {
                Ok(s) => match s.as_ref() {
                    Some(s0) => {
                        let _ = s0.add((ids.iter().cloned().collect(), name));
                    }
                    None => {
                        println!("[rust-error] Stream is None");
                    }
                },
                Err(_) => {
                    println!("[rust-error] Stream read error");
                }
            }
        });
        cron.start();
    }

    fn get_foreground_pid() -> u32 {
        let hwnd = unsafe { GetForegroundWindow() };
        if hwnd.is_null() {
            println!("No foreground window found.");
            return 0;
        }

        let mut process_id: u32 = 0;
        let _ = unsafe { GetWindowThreadProcessId(hwnd, &mut process_id) };

        return process_id;
    }
}

#[cfg(target_os = "linux")]
pub mod linux {
    pub fn start_monitor_with_foreground() {}
}
