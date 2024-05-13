use std::{fs::File, io::Read};

use reqwest::{multipart, Client};

use crate::llm::ENV_PARAMS;

// kimi
pub async fn get_file_content(p: String) -> anyhow::Result<String> {
    let params = ENV_PARAMS.read().unwrap();
    let kind = infer::get_from_path(p.clone())?;
    let mine_str;
    let file_type;
    if let Some(k) = kind {
        mine_str = k.mime_type();
        file_type = k.extension();
    } else {
        mine_str = "text/plain";
        file_type = "txt";
    }
    // println!("mine_str  {:?}",mine_str);
    match params.clone() {
        Some(_p) => {
            let client = Client::new();
            let mut file = File::open(p)?;
            let mut buffer = Vec::new();
            file.read_to_end(&mut buffer)?;
            let form = multipart::Form::new().text("purpose", "file-extract").part(
                "file",
                multipart::Part::bytes(buffer)
                    .file_name(format!("file.{}", file_type))
                    .mime_str(mine_str)?,
            );

            let response = client
                .post(_p.base + "/files")
                .header("Authorization", format!("Bearer {}", _p.sk.unwrap()))
                .multipart(form)
                .send()
                .await?;

            return Ok(response.text().await?);
        }
        None => anyhow::bail!("open ai client is None"),
    }
}

mod tests {
    #[tokio::test]
    async fn test_read_file() {
        crate::llm::init("env".to_owned());
        let s = crate::llm::plugins::chat_file::get_file_content(
            r"C:\Users\xiaoshuyui\Desktop\json.md".to_owned(),
        )
        .await;
        match s {
            Ok(_s) => {
                println!("{}", _s);
            }
            Err(_e) => {
                println!("{:?}", _e);
            }
        }
    }
}
