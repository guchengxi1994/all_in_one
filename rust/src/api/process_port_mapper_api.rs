use crate::system_monitor::ProcessPortMapper;

pub fn get_process_port_mappers() -> Vec<ProcessPortMapper> {
    #[cfg(target_os = "linux")]
    return Vec::new();
    #[cfg(target_os = "windows")]
    // return Vec::new();
    {
        let r = crate::system_monitor::windows::get_by_netstat();
        match r {
            Ok(_r) => {
                return _r;
            }
            Err(_) => {
                return Vec::new();
            }
        }
    }
}
