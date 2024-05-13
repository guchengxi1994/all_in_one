pub mod mysql;

use std::{collections::HashMap, sync::RwLock};

use once_cell::sync::Lazy;
use serde::{Deserialize, Serialize};
use sqlx::{MySql, Pool};

#[derive(Serialize, Deserialize, Debug, Clone, PartialEq, Eq, Hash)]
pub struct DatabaseInfo {
    pub name: String,
    pub address: String,
    pub port: String,
    pub username: String,
    pub password: String,
    pub database: String,
}

#[derive(sqlx::FromRow, Clone, Debug)]
pub struct TableInfo {
    pub table_name: String,
    pub column_name: String,
    pub data_type: String,
}

#[async_trait::async_trait]
pub trait DBUtils {
    async fn get_table_info(&self, pool: &Pool<MySql>) -> anyhow::Result<Vec<TableInfo>>;

    fn get_db_name(&self) -> String;

    fn as_any(&self) -> &dyn std::any::Any;
}

// 暂时没用到，主要是为了后续同时支持多个数据库
pub static DBS: Lazy<RwLock<HashMap<DatabaseInfo, Box<dyn DBUtils + Send + Sync>>>> =
    Lazy::new(|| HashMap::new().into());

// 暂时没用到，主要是为了后续同时支持多个数据库
pub fn add_mysql_database(s: DatabaseInfo) {
    let mut dbs = DBS.write().unwrap();
    if dbs.contains_key(&s) {
        return;
    }
    dbs.insert(s.clone(), Box::new(mysql::MySqlDB::from(s.database)));
}
