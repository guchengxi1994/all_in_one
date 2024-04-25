use std::{cmp, collections::HashMap, hash::Hash, sync::RwLock, thread, time::Duration};

use sysinfo::{Disks, Pid, Process, System};

use crate::frb_generated::StreamSink;

pub static SYS_MONITOR_MESSAGE_SINK: RwLock<Option<StreamSink<MonitorInfo>>> = RwLock::new(None);

pub struct MonitorInfo {
    pub disks: Option<Vec<MountedInfo>>,
    pub memory: Option<MemoryInfo>,
    pub cpu: Option<CpuInfo>,
    pub top_5_memory: Option<Vec<SoftwareMemory>>,
    pub top_5_cpu: Option<Vec<SoftwareCpu>>,
}

pub struct MemoryInfo {
    pub used: u64,
    pub total: u64,
}

#[derive(Debug, Clone)]
pub struct SoftwareCpu {
    pub cpu: f32,
    pub name: String,
}

#[derive(Debug, Clone)]
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
            top_5_cpu: None,
            top_5_memory: None,
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

        v1.sort_by(|a, b| b.cpu.total_cmp(&a.cpu));
        // v1.reverse();

        v2.sort_by(|a, b| b.memory.cmp(&a.memory));
        // v2.reverse();

        monitor_info.top_5_cpu = Some(get_first_five_or_all(&v1));
        monitor_info.top_5_memory = Some(get_first_five_or_all(&v2));

        // for i in &monitor_info.top_5_cpu{
        //     println!("v1 {:?}",i);
        // }

        // for i in &monitor_info.top_5_memory{
        //     println!("v2 {:?}",i);
        // }

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

pub struct ProcessPortMapper {
    pub pid: u32,
    pub local_port: u32,
    pub status: Option<String>,
    pub process_name: Option<String>,
}

impl Eq for ProcessPortMapper {}

impl PartialEq for ProcessPortMapper {
    fn eq(&self, other: &Self) -> bool {
        self.pid == other.pid && self.local_port == other.local_port
    }
}

impl Hash for ProcessPortMapper {
    fn hash<H: std::hash::Hasher>(&self, state: &mut H) {
        self.pid.hash(state);
        self.local_port.hash(state);
    }
}

impl ProcessPortMapper {
    pub fn from(
        address: Option<&str>,
        pid: Option<&str>,
        processes: &HashMap<Pid, Process>,
    ) -> Option<Self> {
        match (address, pid) {
            (None, None) => None,
            (None, Some(_)) => None,
            (Some(_), None) => None,
            (Some(_address), Some(_pid)) => {
                if let Ok(p) = _pid.parse::<u32>() {
                    let split: Vec<&str> = _address.split(":").collect();
                    let last = split.last();

                    if let Some(_last) = last {
                        if let Ok(_port) = _last.parse::<u32>() {
                            return Some(Self {
                                pid: p,
                                local_port: _port,
                                status: None,
                                process_name: get_process_name_by_pid(p, processes),
                            });
                        }
                    }
                }

                None
            }
        }
    }
}

pub mod windows {
    use std::process::Command;

    use sysinfo::System;

    use super::ProcessPortMapper;

    pub fn get_by_netstat() -> anyhow::Result<Vec<ProcessPortMapper>> {
        let mut sys = System::new();
        sys.refresh_processes();
        let processes = sys.processes();
        let output = Command::new("netstat").arg("-ano").output()?;
        let mut result = Vec::<ProcessPortMapper>::new();
        let stdout = std::str::from_utf8(&output.stdout).unwrap();
        let lines: Vec<&str> = stdout.lines().collect();
        for line in lines.iter().skip(1) {
            // 跳过标题行
            let mut parts: Vec<&str> = line.split_whitespace().collect();
            parts.retain(|x| *x != "");
            let addr = parts.get(1).unwrap_or(&"");
            let port = parts.last().unwrap_or(&"");
            let m = ProcessPortMapper::from(Some(addr), Some(port), processes);

            if m.is_some() {
                result.push(m.unwrap());
            }

            // println!("line parts    ---->    {:?}", parts.len());
            // println!(
            //     "The process using port {:?} is: {:?}",
            //     parts.last(),
            //     parts.get(1)
            // );
        }

        anyhow::Ok(result)
    }
}

#[allow(unused_imports)]
mod tests {
    use std::process::Command;

    #[test]
    fn test_netstat() -> anyhow::Result<()> {
        let output = Command::new("netstat").arg("-ano").output()?;

        let stdout = std::str::from_utf8(&output.stdout).unwrap();
        let lines: Vec<&str> = stdout.lines().collect();
        for line in lines.iter().skip(1) {
            // 跳过标题行
            let mut parts: Vec<&str> = line.split_whitespace().collect();
            parts.retain(|x| *x != "");
            println!("line parts    ---->    {:?}", parts.len());
            println!(
                "The process using port {:?} is: {:?}",
                parts.last(),
                parts.get(1)
            );
        }

        anyhow::Ok(())
    }
}

fn get_process_name_by_pid(pid: u32, processes: &HashMap<Pid, Process>) -> Option<String> {
    let p0 = processes
        .keys()
        .filter(|x| x.as_u32() == pid)
        .collect::<Vec<_>>();
    if p0.is_empty() {
        return None;
    }

    let process = processes.get(p0.first().unwrap()).unwrap();

    Some(process.name().to_string())
}
