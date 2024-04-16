use std::{sync::RwLock, thread};

use systemstat::{saturating_sub_bytes, Duration, Platform, System};

use crate::frb_generated::StreamSink;

#[allow(unused_imports)]
mod tests;

pub static SYS_MONITOR_MESSAGE_SINK: RwLock<Option<StreamSink<MonitorInfo>>> = RwLock::new(None);

pub struct MonitorInfo {
    #[cfg(windows)]
    pub disks: Option<Vec<MountedInfo>>,
    pub memory: Option<MemoryInfo>,
    pub cpu: Option<CpuInfo>,
}

pub struct MemoryInfo {
    pub used: u64,
    pub total: u64,
}

impl MonitorInfo {
    pub fn default() -> Self {
        Self {
            disks: None,
            memory: None,
            cpu: None,
        }
    }
}

#[cfg(windows)]
pub struct MountedInfo {
    pub disk: String,
    pub name: String,
    pub fs: String,
    pub available: u64,
    pub total: u64,
}

pub struct CpuInfo {
    pub user: f32,
    pub system: f32,
    pub intr: f32,
}

impl CpuInfo {
    pub fn total(&self) -> f32 {
        self.user + self.system + self.intr
    }
}

const DURATION: u64 = 4;

pub fn start_monitor() {
    loop {
        let sys = System::new();
        let mut monitor_info = MonitorInfo::default();
        if let Ok(data) = sys.mounts() {
            let mut infos = Vec::<MountedInfo>::new();
            for i in data {
                let m: MountedInfo = MountedInfo {
                    name: i.fs_mounted_from,
                    disk: i.fs_mounted_on,
                    fs: i.fs_type,
                    available: i.avail.as_u64(),
                    total: i.total.as_u64(),
                };
                infos.push(m);
            }
            monitor_info.disks = Some(infos);
        }

        if let Ok(data) = sys.memory() {
            let me = MemoryInfo {
                total: data.total.as_u64(),
                used: saturating_sub_bytes(data.total, data.free).as_u64(),
            };
            monitor_info.memory = Some(me);
        }

        if let Ok(data) = sys.cpu_load_aggregate() {
            thread::sleep(Duration::from_secs(1));
            let cpu = data.done().unwrap();
            monitor_info.cpu = Some(CpuInfo {
                user: cpu.user,
                system: cpu.system,
                intr: cpu.interrupt,
            });
        }

        match SYS_MONITOR_MESSAGE_SINK.try_read() {
            Ok(s) => match s.as_ref() {
                Some(s0) => {
                    let _ = s0.add(monitor_info);
                }
                None => {
                    println!("[rust-error] Stream is None");
                }
            },
            Err(_) => {
                println!("[rust-error] Stream read error");
            }
        }
        thread::sleep(Duration::from_secs(DURATION));
    }
}
