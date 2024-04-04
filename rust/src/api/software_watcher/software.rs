use std::{collections::HashSet, hash::Hash, io::Error};

use flutter_rust_bridge::frb;
use winreg::RegKey;

#[derive(Debug)]
pub struct Software {
    pub name: String,
    pub icon_path: String,
    pub icon: Option<Vec<u8>>,
}

impl Software {
    #[frb(ignore)]
    pub fn default() -> Self {
        Software {
            name: "".to_owned(),
            icon_path: "".to_owned(),
            icon: None,
        }
    }
}

impl Eq for Software {}

impl PartialEq for Software {
    fn eq(&self, other: &Self) -> bool {
        self.name == other.name
    }
}

impl Hash for Software {
    fn hash<H: std::hash::Hasher>(&self, state: &mut H) {
        self.name.hash(state);
    }
}

#[cfg(windows)]
#[frb(ignore)]
pub struct _Hkey(pub isize);

#[cfg(windows)]
impl _Hkey {
    #[frb(ignore)]
    pub fn get_all(&self) -> Vec<Software> {
        let mut res = HashSet::new();

        let hkcu_uninstall =
            RegKey::predef(self.0) // HKEY_LOCAL_MACHINE + HKEY_CURRENT_USER
                .open_subkey("Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall");
        if let Ok(hkcu_uninstall) = hkcu_uninstall {
            for subkey_name in hkcu_uninstall.enum_keys() {
                if let Ok(key) = subkey_name {
                    let subkey = hkcu_uninstall.open_subkey(key);

                    if let Ok(subkey) = subkey {
                        let display_name: Result<String, Error> = subkey.get_value("DisplayName");
                        let display_icon: Result<String, Error> = subkey.get_value("DisplayIcon");
                        if matches!(display_name, Ok(_)) && matches!(display_icon, Ok(_)) {
                            let mut soft = Software::default();
                            soft.icon_path = display_icon.unwrap();
                            soft.name = display_name.unwrap();
                            if !soft.icon_path.ends_with(".ico") {
                                let p = soft.icon_path.split(",").next().unwrap_or("");

                                let icon = systemicons::get_icon(p, 32);
                                if let Ok(icon) = icon {
                                    soft.icon = Some(icon);
                                }
                            }

                            res.insert(soft);
                        }
                    }
                }
            }
        }

        res.into_iter().collect()
    }
}
