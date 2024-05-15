use async_trait::async_trait;
use once_cell::sync::Lazy;
use sqlx::Row;
use sqlx::{MySql, MySqlPool, Pool};
use std::{collections::HashMap, sync::RwLock};

use super::{DBUtils, DatabaseInfo, TableInfo};

// pub static MYSQL_CONFIG: Lazy<RwLock<Option<DatabaseInfo>>> = Lazy::new(|| None.into());

pub static MYSQL_POOLS: Lazy<RwLock<HashMap<DatabaseInfo, Pool<MySql>>>> =
    Lazy::new(|| HashMap::new().into());

pub struct MySqlDB {
    pub db_name: String,
}

impl MySqlDB {
    pub fn from(s: String) -> Self {
        Self { db_name: s }
    }

    pub async fn get_pool(s: DatabaseInfo) -> anyhow::Result<Pool<MySql>> {
        let mut pools;
        let pool;
        {
            pools = MYSQL_POOLS.write().unwrap();
            if pools.get(&s).is_none() {
                pool = MySqlPool::connect(&format!(
                    "mysql://{}:{}@{}:{}/{}",
                    s.username, s.password, s.address, s.port, s.database
                ))
                .await?;
                pools.insert(s.clone(), pool.clone());
            } else {
                pool = pools.get(&s).unwrap().clone();
            }
        }
        Ok(pool)
    }
}

#[async_trait]
impl DBUtils for MySqlDB {
    async fn get_table_info(&self, pool: &Pool<MySql>) -> anyhow::Result<Vec<TableInfo>> {
        let r = sqlx::query_as::<sqlx::MySql, TableInfo>(
            r#"SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = ?"#,
        )
        .bind(self.get_db_name())
        .fetch_all(pool)
        .await?;

        anyhow::Ok(r)
    }

    fn get_db_name(&self) -> String {
        self.db_name.clone()
    }

    fn as_any(&self) -> &dyn std::any::Any {
        self
    }
}

pub async fn get_mysql_table_info(s: DatabaseInfo) -> anyhow::Result<Vec<TableInfo>> {
    let pool = MySqlDB::get_pool(s.clone()).await?;

    let db = MySqlDB::from(s.database.clone());
    let v = db.get_table_info(&pool).await?;

    anyhow::Ok(v)
}

pub fn table_info_spliter(v: &Vec<TableInfo>) -> Vec<Vec<TableInfo>> {
    let mut result = Vec::new();
    let mut map: HashMap<String, Vec<TableInfo>> = HashMap::new();
    for i in v {
        let table_name = i.table_name.clone();
        if map.contains_key(&table_name) {
            map.get_mut(&table_name).unwrap().push(i.clone());
        } else {
            map.insert(table_name, vec![i.clone()]);
        }
    }

    map.values().for_each(|v| {
        result.push(v.clone());
    });

    result
}

pub enum CellType {
    String,
    Number,
}

/// 根据keys获取row中的数据
pub async fn eval(
    sql_str: String,
    db: DatabaseInfo,
    keys: Vec<(String, CellType)>,
) -> anyhow::Result<HashMap<String, String>> {
    let pool = MySqlDB::get_pool(db).await?;
    let row = sqlx::query(&sql_str).fetch_one(&pool).await?;
    let mut result = HashMap::new();

    for (k, v) in keys {
        match v {
            CellType::String => {
                let s: &str = row.try_get(k.as_str())?;
                result.insert(k, s.to_owned());
                println!("{}", s);
            }
            CellType::Number => {
                let s: i64 = row.try_get(k.as_str())?;
                result.insert(k, format!("{}", s));
                println!("{}", s);
            }
        }
    }

    anyhow::Ok(result)
}
