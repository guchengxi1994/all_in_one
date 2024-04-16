use flutter_rust_bridge::frb;
use rust_simple_notify_lib;

#[frb(mirror(rust_simple_notify_lib::PinWindowItem))]
pub struct _PinWindowItem {
    pub title: String,
    pub sub_title: String,
    pub id: i32,
}

pub fn create_event_loop() {
    let _ = rust_simple_notify_lib::create_event_loop();
}

pub fn show_todos(data: Vec<rust_simple_notify_lib::PinWindowItem>) {
    rust_simple_notify_lib::show_todos(data);
}
