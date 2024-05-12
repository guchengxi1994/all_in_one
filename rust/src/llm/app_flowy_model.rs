use super::OPENAI;
use langchain_rust::language_models::llm::LLM;
use regex::Regex;
use serde::Deserialize;
use serde::Serialize;

#[derive(Default, Debug, Clone, PartialEq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Root {
    pub document: Document,
}

#[derive(Default, Debug, Clone, PartialEq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Document {
    #[serde(rename = "type")]
    pub type_field: String,
    pub children: Vec<Children>,
}

#[derive(Default, Debug, Clone, PartialEq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Children {
    #[serde(rename = "type")]
    pub type_field: String,
    pub data: Data,
}

#[derive(Default, Debug, Clone, PartialEq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Data {
    pub level: Option<i64>,
    pub delta: Vec<Delum>,
    pub align: Option<String>,
}

#[derive(Default, Debug, Clone, PartialEq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Delum {
    pub insert: String,
    pub attributes: Option<Attributes>,
}

#[derive(Default, Debug, Clone, PartialEq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Attributes {
    pub bold: bool,
    pub italic: bool,
}

pub fn str_to_doc(s: String) -> anyhow::Result<Root> {
    let v: Root = serde_json::from_str(&s)?;
    anyhow::Ok(v)
}

pub fn doc_to_str(doc: &Root) -> anyhow::Result<String> {
    let s = serde_json::to_string(doc)?;
    anyhow::Ok(s)
}

pub fn get_all_cadidates(s: String) -> anyhow::Result<Vec<String>> {
    let mut v: Vec<String> = Vec::new();
    let root = str_to_doc(s)?;
    let re = Regex::new(r"\{\{(.*?)\}\}").unwrap();
    let doc = root.document;
    let children = doc.children;
    for i in children {
        if !i.data.delta.is_empty() {
            for d in i.data.delta {
                for cap in re.captures_iter(&d.insert.clone()) {
                    if let Some(matched) = cap.get(0) {
                        println!("Matched text: {}", matched.as_str());
                        v.push(matched.as_str().to_string());
                    }
                }
            }
        }
    }

    anyhow::Ok(v)
}

#[allow(unused_imports)]
mod tests {
    use langchain_rust::{
        language_models::llm::LLM,
        llm::{OpenAI, OpenAIConfig},
    };
    use regex::Regex;

    use super::str_to_doc;

    #[tokio::test]
    async fn json_read_test() -> anyhow::Result<()> {
        let map = crate::llm::env_parse("env".to_owned()).unwrap();

        let base = map.get("LLM_BASE").unwrap();
        println!("base {:?}", base);
        let name = map.get("LLM_MODEL_NAME").unwrap();
        println!("name {:?}", name);
        let binding = "".to_string();
        let sk = map.get("LLM_SK").unwrap_or(&binding);
        println!("sk {:?}", sk);

        let open_ai = OpenAI::default()
            .with_config(OpenAIConfig::new().with_api_base(base).with_api_key(sk))
            .with_model(name);

        // let response = open_ai.invoke("how can langsmith help with testing?").await;

        let data = r#"
        {
            "document": {
                "type": "page",
                "children": [
                    {
                        "type": "heading",
                        "data": {
                            "level": 2,
                            "delta": [
                                {
                                    "insert": "👋 "
                                },
                                {
                                    "insert": "Welcome to",
                                    "attributes": {
                                        "bold": true,
                                        "italic": false
                                    }
                                },
                                {
                                    "insert": " "
                                },
                                {
                                    "insert": "Template editor",
                                    "attributes": {
                                        "bold": true,
                                        "italic": true
                                    }
                                }
                            ],
                            "align": "center"
                        }
                    },
                    {
                        "type": "paragraph",
                        "data": {
                            "delta": [
                                {
                                    "insert": "我司打算本周六进行团建，场地：{{请帮我推荐一个10人左右的场地，坐标常州。仅需要一个地点，且只需要提供场地名称，不需要其它信息}}。"
                                }
                            ]
                        }
                    },
                    {
                        "type": "paragraph",
                        "data": {
                            "delta": [
                                {
                                    "insert": "具体流程包括："
                                }
                            ]
                        }
                    },
                    {
                        "type": "paragraph",
                        "data": {
                            "delta": [
                                {
                                    "insert": "{{ 请帮我推荐10人左右团建活动}}"
                                }
                            ]
                        }
                    },
                    {
                        "type": "paragraph",
                        "data": {
                            "delta": [
                                {
                                    "insert": "晚餐安排："
                                }
                            ]
                        }
                    },
                    {
                        "type": "paragraph",
                        "data": {
                            "delta": [
                                {
                                    "insert": "{{ 请帮我推荐10人左右团建晚餐菜品推荐，并提供报价单 }}"
                                }
                            ]
                        }
                    }
                ]
            }
        }
        "#;

        let re = Regex::new(r"\{\{(.*?)\}\}").unwrap();

        let root = str_to_doc(data.to_owned())?;

        let doc = root.document;
        let children = doc.children;

        for i in children {
            if !i.data.delta.is_empty() {
                for mut d in i.data.delta {
                    for cap in re.captures_iter(&d.insert.clone()) {
                        if let Some(matched) = cap.get(0) {
                            println!("Matched text: {}", matched.as_str());
                            let response = open_ai.invoke(matched.as_str()).await?;
                            d.insert = d.insert.replace(matched.as_str(), &response);
                            println!("response text: {}", d.insert);
                        }
                    }
                }
            }
        }

        anyhow::Ok(())
    }
}

pub async fn template_renderer_impl(template: String) -> anyhow::Result<String> {
    let re = Regex::new(r"\{\{(.*?)\}\}").unwrap();
    let open_ai;
    {
        open_ai = OPENAI.read().unwrap();
    }
    let mut root = str_to_doc(template)?;

    {
        let doc = &mut root.document;
        let children = &mut doc.children;

        for i in children {
            if !i.data.delta.is_empty() {
                for d in i.data.delta.iter_mut() {
                    for cap in re.captures_iter(&d.insert.clone()) {
                        if let Some(matched) = cap.get(0) {
                            let response = open_ai.invoke(matched.as_str()).await?;
                            d.insert = d.insert.replace(matched.as_str(), &response);
                            // println!("response text: {}", d.insert);
                        }
                    }
                }
            }
        }
    }

    let res = doc_to_str(&root)?;

    Ok(res)
}
