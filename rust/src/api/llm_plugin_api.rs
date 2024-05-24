use std::collections::HashMap;
use crate::llm::plugins::mind_map::MIND_MAP_MESSAGE_SINK;
use crate::frb_generated::StreamSink;
use crate::llm::plugins::chat_db::mysql::CellType;
use crate::llm::plugins::chat_db::DatabaseInfo;
use crate::llm::plugins::chat_db::TableInfo;

pub fn get_mysql_table_info(s: DatabaseInfo) -> Vec<Vec<TableInfo>> {
    let rt = tokio::runtime::Runtime::new().unwrap();
    rt.block_on(async {
        let v = crate::llm::plugins::chat_db::mysql::get_mysql_table_info(s).await;
        match v {
            Ok(_v) => crate::llm::plugins::chat_db::mysql::table_info_spliter(&_v),
            Err(_e) => {
                println!("[rust] error {}", _e);
                vec![]
            }
        }
    })
}

pub fn eval(
    sql_str: String,
    db: DatabaseInfo,
    keys: Vec<(String, CellType)>,
) -> Option<HashMap<String, String>> {
    let rt = tokio::runtime::Runtime::new().unwrap();
    let v =
        rt.block_on(async { crate::llm::plugins::chat_db::mysql::eval(sql_str, db, keys).await });
    match v {
        Ok(_v) => Some(_v),
        Err(_e) => {
            println!("[rust] error {}", _e);
            return None;
        }
    }
}

pub fn text_to_mind_map(s: String) {
    let rt = tokio::runtime::Runtime::new().unwrap();
    rt.block_on(async {
        crate::llm::plugins::mind_map::text_to_mind_map(s).await;
    });
}

#[flutter_rust_bridge::frb(sync)]
pub fn mind_map_stream(s: StreamSink<String>) -> anyhow::Result<()> {
    let mut stream = MIND_MAP_MESSAGE_SINK.write().unwrap();
    *stream = Some(s);
    anyhow::Ok(())
}
