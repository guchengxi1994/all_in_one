#[cfg(target_os = "windows")]
use winapi::um::winuser::{GetSystemMetrics, SM_CXSCREEN, SM_CYSCREEN};

#[cfg(target_os = "windows")]
fn get_screen_size_on_windows() -> (i32, i32) {
    let width = unsafe { GetSystemMetrics(SM_CXSCREEN) };
    let height = unsafe { GetSystemMetrics(SM_CYSCREEN) };
    // println!("Screen size: {} x {}", width, height);
    (width, height)
}

#[cfg(target_os = "windows")]
pub fn get_screen_size() -> (i32, i32) {
    return get_screen_size_on_windows();
}

#[cfg(target_os = "linux")]
pub fn get_screen_size() -> (i32, i32) {
    return (-1,-1);
}