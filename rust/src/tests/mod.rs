#[allow(unused_braces, dead_code, non_snake_case, unused_variables)]
#[cfg(target_os = "windows")]
mod foreground_test;

#[cfg(target_os = "windows")]
use std::{ffi::OsStr, io::Error, iter::once, os::windows::ffi::OsStrExt};

use flutter_rust_bridge::frb;
#[cfg(target_os = "windows")]
use winreg::{
    enums::{HKEY_CURRENT_USER, HKEY_LOCAL_MACHINE},
    RegKey,
};

#[cfg(target_os = "windows")]
extern crate systemicons;

#[test]
#[frb(ignore)]
#[cfg(target_os = "windows")]
fn test_win_install_list() {
    // 打开 Uninstall 键
    let hkcu_uninstall =
        RegKey::predef(HKEY_LOCAL_MACHINE) // HKEY_LOCAL_MACHINE + HKEY_CURRENT_USER
            .open_subkey("Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall");

    if let Ok(hkcu_uninstall) = hkcu_uninstall {
        // 遍历子键
        for subkey_name in hkcu_uninstall.enum_keys() {
            if let Ok(key) = subkey_name {
                let subkey = hkcu_uninstall.open_subkey(key);

                if let Ok(subkey) = subkey {
                    // 读取每个软件的信息
                    // 注意：实际代码应包含错误处理及适当的解析逻辑
                    let display_name: Result<String, Error> = subkey.get_value("DisplayName");
                    let display_icon: Result<String, Error> = subkey.get_value("DisplayIcon");
                    if matches!(display_name, Ok(_)) && matches!(display_icon, Ok(_)) {
                        println!("DisplayName: {:?}", display_name.unwrap());
                        println!("DisplayIcon: {:?}", display_icon.unwrap());
                    }
                }
            }
        }
    }
}

#[test]
#[frb(ignore)]
#[cfg(target_os = "windows")]
fn test_win_exe_to_ico() -> anyhow::Result<()> {
    use std::{fs::File, io::Write};

    let icon = systemicons::get_icon("G:\\Genshin Impact\\launcher.exe", 32);
    match icon {
        Ok(i) => {
            let path = "output.png";

            let mut file = File::create(path)?;
            file.write_all(&i)?;
            file.flush()?;
        }
        Err(e) => {
            println!("{:?}", e);
        }
    }

    anyhow::Ok(())
}

#[test]
#[frb(ignore)]
#[cfg(target_os = "windows")]
fn test_win_get_all_softwares() -> anyhow::Result<()> {
    let r = crate::api::software_monitor_api::windows::get_installed_softwares();
    for i in &r {
        println!("name {:?}", i.name);
        println!("path {:?}", i.icon_path);
        println!("icon {:?}", (i.icon.clone().unwrap_or(vec![])).len());
        println!(
            "=================================================================================="
        );
    }

    println!("count {:?}", r.len());

    anyhow::Ok(())
}
