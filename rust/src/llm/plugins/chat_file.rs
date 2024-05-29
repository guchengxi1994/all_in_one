use std::{fs::File, io::Read};

use reqwest::{multipart, Client};
use serde::Deserialize;
use serde::Serialize;

use super::EnvParams;

// kimi
#[derive(Serialize, Deserialize)]
struct UploadFileResponse {
    id: String,
    object: String,
    bytes: i64,
    created_at: i64,
    filename: String,
    purpose: String,
    status: String,
    status_details: String,
}

// kimi
#[derive(Serialize, Deserialize)]
struct FileContentResponse {
    content: String,
    file_type: String,
    filename: String,
    title: String,
    #[serde(rename = "type")]
    _type: String,
}

// kimi
pub async fn get_file_content(p: String, params: EnvParams) -> anyhow::Result<String> {
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
        .post(params.base.clone() + "/files")
        .header(
            "Authorization",
            format!("Bearer {}", params.sk.clone().unwrap()),
        )
        .multipart(form)
        .send()
        .await?;

    let res: UploadFileResponse = response.json().await?;
    let file_content_response = client
        .get(params.base + "/files/" + &res.id.clone() + "/content")
        .header("Authorization", format!("Bearer {}", params.sk.unwrap()))
        .send()
        .await?;

    return Ok(file_content_response
        .json::<FileContentResponse>()
        .await?
        .content);
}
