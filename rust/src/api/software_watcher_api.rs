use super::software_watcher::software;
use winreg::enums::{HKEY_CURRENT_USER, HKEY_LOCAL_MACHINE};

#[cfg(windows)]
pub fn get_windows_installed_softwares() -> Vec<software::Software> {
    let local = software::_Hkey(HKEY_LOCAL_MACHINE);
    let user = software::_Hkey(HKEY_CURRENT_USER);

    let mut v1 = local.get_all();
    let v2 = user.get_all();

    v1.extend(v2);
    v1
}
