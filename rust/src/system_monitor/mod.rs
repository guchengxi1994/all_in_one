use std::{cmp, sync::RwLock, thread, time::Duration};

use sysinfo::{Disks, System};

use crate::frb_generated::StreamSink;

pub static SYS_MONITOR_MESSAGE_SINK: RwLock<Option<StreamSink<MonitorInfo>>> = RwLock::new(None);

pub struct MonitorInfo {
    pub disks: Option<Vec<MountedInfo>>,
    pub memory: Option<MemoryInfo>,
    pub cpu: Option<CpuInfo>,
    pub top_5_memory : Option<Vec<SoftwareMemory>> ,
    pub top_5_cpu: Option<Vec<SoftwareCpu>> 
}

pub struct MemoryInfo {
    pub used: u64,
    pub total: u64,
}

#[derive(Debug,Clone)]
pub struct SoftwareCpu {
    pub cpu: f32,
    pub name: String,
}

#[derive(Debug,Clone)]
pub struct SoftwareMemory {
    pub memory: u64,
    pub name: String,
}

impl MonitorInfo {
    pub fn default() -> Self {
        Self {
            disks: None,
            memory: None,
            cpu: None,
            top_5_cpu:None,
            top_5_memory:None
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
        for cpu in sys.cpus() {
            total_usage += cpu.cpu_usage();
        }
        monitor_info.cpu = Some(CpuInfo {
            current: total_usage / (sys.cpus().len() as f32),
        });

        let mut v1: Vec<SoftwareCpu> = Vec::new();
        let mut v2: Vec<SoftwareMemory> = Vec::new();

        for p in sys.processes() {
            v1.push(SoftwareCpu {
                cpu: p.1.cpu_usage(),
                name: p.1.name().to_lowercase(),
            });
            v2.push(SoftwareMemory {
                memory: p.1.memory(),
                name: p.1.name().to_lowercase(),
            })
        }

        v1.sort_by(|a,b|b.cpu.total_cmp(&a.cpu));
        v1.reverse();

        v2.sort_by(|a,b|b.memory.cmp(&a.memory));
        v2.reverse();

        monitor_info.top_5_cpu = Some(get_first_five_or_all(&v1));
        monitor_info.top_5_memory = Some(get_first_five_or_all(&v2));

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

fn get_first_five_or_all<T>(vec: &[T]) -> Vec<T>
where
    T: Clone, // 泛型T需要实现Clone trait，以便在创建新Vec时复制元素
{
    let len = vec.len();
    vec[..cmp::min(len, 5)].to_vec()
}
