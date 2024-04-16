use crate::ui::ListTileItem;
use crate::ui::PinWindow;
use lazy_static::lazy_static;
use serde::{Deserialize, Serialize};
use slint::ComponentHandle;
use slint::Weak;

use std::{
    rc::Rc,
    sync::{
        mpsc::{channel, Sender},
        Mutex, RwLock,
    },
    time::Duration,
};

use tao::{
    event_loop::{EventLoop, EventLoopBuilder},
    platform::windows::EventLoopBuilderExtWindows,
};

pub mod ui;
pub mod utils;

lazy_static! {
    pub static ref MP_SENDER: Mutex<Option<Sender<String>>> = Mutex::new(None);
    pub static ref PROXY: RwLock<Option<tao::event_loop::EventLoopProxy<EventMessage>>> =
        RwLock::new(None);
}

pub fn show_todos(data: Vec<PinWindowItem>) {
    let r = PROXY.read().unwrap();
    {
        let _ = r
            .clone()
            .unwrap()
            .send_event(EventMessage { data: Some(data) });
    }
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct PinWindowItem {
    pub title: String,
    pub sub_title: String,
    pub id: i32,
}

#[derive(Debug, Clone)]
pub struct EventMessage {
    pub data: Option<Vec<PinWindowItem>>,
}

pub fn create_event_loop() -> anyhow::Result<()> {
    let mut builder: EventLoopBuilder<EventMessage> =
        EventLoopBuilder::<EventMessage>::with_user_event();

    #[cfg(target_os = "windows")]
    builder.with_any_thread(true);

    let event_loop: EventLoop<EventMessage> = builder.build();
    let (_tx, rx) = channel::<String>();

    {
        let mut r = MP_SENDER.lock().unwrap();
        *r = Some(_tx.clone());
    }

    {
        let proxy: tao::event_loop::EventLoopProxy<EventMessage> = event_loop.create_proxy();
        let mut r = PROXY.write().unwrap();
        *r = Some(proxy);
    }

    std::thread::spawn(move || loop {
        let _ = _tx.clone().send("avoid drop reciever".to_owned());
        std::thread::sleep(Duration::from_secs(1));
    });

    let pin_win = PinWindow::new().unwrap();
    let mut pin_win_handle = pin_win.as_weak();

    std::thread::spawn(move || loop {
        let s = rx.recv();
        if let Ok(_s) = s {
            println!("{}", _s);
        }
    });

    event_loop.run(move |_event, _, _control_flow| {
        match _event {
            tao::event::Event::UserEvent(my_event) => {
                println!("Received custom event: {:?}", my_event);
                // *control_flow = ControlFlow::Exit;
                let position = get_position((1, 1));
                pin_win
                    .window()
                    .set_position(slint::PhysicalPosition::new(position.0, position.1));

                pin_win_handle = pin_window_handle_wrapper(
                    pin_win_handle.clone(),
                    my_event.data.unwrap_or(Vec::new()),
                );

                pin_win.run().unwrap();
            }
            _ => {}
        }
    });
}

fn pin_window_handle_wrapper(
    pin_win_handle: Weak<PinWindow>,
    inited_items: Vec<PinWindowItem>,
) -> Weak<PinWindow> {
    let pin_win_clone = pin_win_handle.clone();

    let todo_model = Rc::new(slint::VecModel::<ListTileItem>::default());
    for i in inited_items {
        todo_model.push(ListTileItem {
            title: i.title.into(),
            sub_title: i.sub_title.into(),
            id: i.id,
        });
    }

    pin_win_handle.upgrade().unwrap().on_mouse_move({
        let pin_win_clone = pin_win_clone.unwrap();
        move |delta_x, delta_y| {
            let logical_pos = pin_win_clone
                .window()
                .position()
                .to_logical(pin_win_clone.window().scale_factor());
            pin_win_clone
                .window()
                .set_position(slint::LogicalPosition::new(
                    logical_pos.x + delta_x,
                    logical_pos.y + delta_y,
                ));
        }
    });

    pin_win_handle.upgrade().unwrap().on_close_window({
        let pin_win_clone = pin_win_clone.unwrap();
        move || {
            let _ = pin_win_clone.hide();
        }
    });

    pin_win_handle
        .upgrade()
        .unwrap()
        .set_todo_model(todo_model.into());

    pin_win_handle
}

const DEFAULT_WIDTH: i32 = 400;
const HALF_WIDTH: i32 = 200;
const DEFAULT_HEIGHT: i32 = 600;
const HALF_HEIGHT: i32 = 300;

fn get_position(alignment: (i8, i8)) -> (i32, i32) {
    let (width, height) = crate::utils::get_screen_size();
    if width == -1 && height == -1 {
        return (0, 0);
    }

    match alignment {
        (-1, -1) => (0, 0),
        (0, -1) => ((0.5 * width as f32) as i32- /*default width*/ HALF_WIDTH, 0),

        (1, -1) => (width- /*default width*/ HALF_WIDTH, 0),
        (-1, 0) => (
            0,
            (0.5 * height as f32) as i32 - /*default height*/ HALF_HEIGHT,
        ),
        (0, 0) => (
            (0.5 * width as f32) as i32 - /*default width*/ HALF_WIDTH,
            (0.5 * height as f32) as i32 - /*default height*/ HALF_HEIGHT,
        ),
        (1, 0) => (
            width- /*default width*/ HALF_WIDTH,
            (0.5 * height as f32) as i32 - /*default height*/ HALF_HEIGHT,
        ),
        (-1, 1) => (0, height- /*default height*/ DEFAULT_HEIGHT),
        (0, 1) => (
            (0.5 * width as f32) as i32- /*default width*/ HALF_WIDTH,
            height- /*default height*/ DEFAULT_HEIGHT,
        ),
        (1, 1) => (
            width- /*default width*/ DEFAULT_WIDTH,
            height- /*default height*/ DEFAULT_HEIGHT,
        ),

        _ => (0, 0),
    }
}

#[test]
fn test_todo() {
    std::thread::spawn(|| {
        std::thread::sleep(Duration::from_secs(1));
        show_todos(Vec::new());
    });

    let _ = create_event_loop();
}
