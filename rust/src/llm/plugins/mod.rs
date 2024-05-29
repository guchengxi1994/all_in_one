pub mod chat_db;
pub mod chat_file;

#[derive(Debug, Clone)]
pub struct EnvParams {
    pub base: String,
    pub name: String,
    pub chat_base: String,
    pub sk: Option<String>,
}
