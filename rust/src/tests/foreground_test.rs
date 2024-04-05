use once_cell::sync::Lazy;
use std::ffi::OsString;
use std::os::windows::ffi::OsStringExt;
use std::ptr;
use std::sync::RwLock;
use sysinfo::System;
use winapi::shared::minwindef::LPARAM;
use winapi::shared::windef::HWND;
use winapi::um::winuser::{
    EnumWindows, GetForegroundWindow, GetWindowTextLengthW, GetWindowTextW,
    GetWindowThreadProcessId,
};

// 定义一个向量来存储窗口名称
// static mut WINDOW_NAMES: Vec<OsString> = Vec::new();
static WINDOW_NAMES: Lazy<RwLock<Vec<OsString>>> = Lazy::new(|| RwLock::new(Vec::new()));

// 定义回调函数，用于EnumWindows枚举过程
unsafe extern "system" fn enum_windows_proc(hwnd: HWND, lParam: LPARAM) -> i32 {
    let length = GetWindowTextLengthW(hwnd) as usize + 1;
    let mut buffer = vec![0u16; length];

    let u16_slice: &mut [u16] = &mut buffer;
    // 假设 u16_slice 是一个字节对齐的，并且长度是偶数
    // let i8_slice: &mut [i8] = unsafe {
    //     std::slice::from_raw_parts_mut(u16_slice.as_ptr() as *mut i8, u16_slice.len() * 2)
    // };

    GetWindowTextW(hwnd, u16_slice.as_mut_ptr(), length as i32);
    let window_name = OsString::from_wide(&buffer[..length - 1]); // 移除结尾的null字符
    let window_name = OsString::from(window_name.to_string_lossy().as_ref());
    {
        let mut window_names = WINDOW_NAMES.write().unwrap();
        window_names.push(window_name); // 将窗口名称添加到向量中
    }

    1 // 继续枚举其他窗口
}

#[test]
fn g_test() {
    unsafe {
        // 调用EnumWindows函数开始枚举窗口
        EnumWindows(Some(enum_windows_proc), 0);
        // 输出所有窗口名称
        for name in &*(WINDOW_NAMES.read().unwrap()) {
            println!("{:?}", <OsString as Clone>::clone(&name).into_string());
        }
    }
}

fn get_process_name(process_id: u32) -> anyhow::Result<String> {
    let mut sys = System::new();
    let mut name: String = String::new();
    println!("process_id   {:?}", process_id);
    sys.refresh_processes();
    for p in sys.processes() {
        if p.0.as_u32() == process_id {
            name = p.1.name().to_owned();
        }
    }

    Ok(name) // 替换为实际获取到的进程名称
}

#[test]
fn g_test2() {
    let hwnd = unsafe { GetForegroundWindow() };
    if hwnd.is_null() {
        println!("No foreground window found.");
        return;
    }

    let mut process_id: u32 = 0;
    let thread_id = unsafe { GetWindowThreadProcessId(hwnd, &mut process_id) };

    let process_name = get_process_name(process_id);

    println!("process_name   {:?}", process_name);

    let length = unsafe { GetWindowTextLengthW(hwnd) };
    if length == 0 {
        println!("Failed to get window text length.");
        return;
    }

    let mut buffer = vec![0u16; (length + 1) as usize]; // +1 for null terminator
    unsafe {
        GetWindowTextW(hwnd, buffer.as_mut_ptr(), length + 1);
    }

    let window_name: String = OsString::from_wide(&buffer[..length as usize])
        .into_string()
        .unwrap_or_else(|_| String::from("Invalid Unicode"));

    println!("The active window is: {}", window_name);
}
