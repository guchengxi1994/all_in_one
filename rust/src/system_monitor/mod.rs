use std::{sync::RwLock, thread, time::Duration};

use sysinfo::{Disks, System};

use crate::frb_generated::StreamSink;

pub static SYS_MONITOR_MESSAGE_SINK: RwLock<Option<StreamSink<MonitorInfo>>> = RwLock::new(None);

pub struct MonitorInfo {
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

pub struct MountedInfo {
    pub disk: String,
    pub name: String,
    pub fs: String,
    pub available: u64,
    pub total: u64,
}

pub struct CpuInfo {
    pub current: f32,
}

const DURATION: u64 = 500;

pub fn start_monitor() {
    let mut sys = System::new();
    loop {
        sys.refresh_all();
        let mut monitor_info = MonitorInfo::default();
        let disks = Disks::new_with_refreshed_list();

        let mut infos = Vec::<MountedInfo>::new();
        for i in &disks {
            let m: MountedInfo = MountedInfo {
                name: format!("{:?}", i.name()),
                disk: format!("{:?}", i.mount_point()),
                fs: format!("{:?}", i.file_system()),
                available: i.available_space(),
                total: i.total_space(),
            };
            infos.push(m);
        }
        monitor_info.disks = Some(infos);

        let me = MemoryInfo {
            total: sys.total_memory(),
            used: sys.used_memory(),
        };
        monitor_info.memory = Some(me);

        let mut total_usage = 0.0;
        // let cpu_count = sys.cpus().len() as f32; // 获取 CPU 核心数量

        for cpu in sys.cpus() {
            total_usage += cpu.cpu_usage(); // 累加每个核心的使用率
        }

        for cpu in sys.cpus() {
            total_usage += cpu.cpu_usage(); // 累加每个核心的使用率
        }

        monitor_info.cpu = Some(CpuInfo {
            current: total_usage,
        });

        match SYS_MONITOR_MESSAGE_SINK.try_read() {
            Ok(s) => match s.as_ref() {
                Some(s0) => {
                    let _ = s0.add(monitor_info);
                }
                None => {}
            },
            Err(_) => {}
        }
        thread::sleep(Duration::from_millis(DURATION));
    }
}
