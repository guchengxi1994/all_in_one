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
    pub bold: Option<bool>,
    pub italic: Option<bool>,
    pub file: Option<String>,
    pub sql: Option<String>,
}

pub fn str_to_doc(s: String) -> anyhow::Result<Root> {
    let v: Root = serde_json::from_str(&s)?;
    anyhow::Ok(v)
}

pub fn doc_to_str(doc: &Root) -> anyhow::Result<String> {
    let s = serde_json::to_string(doc)?;
    anyhow::Ok(s)
}

#[derive(Debug, Clone, PartialEq)]
pub enum AttributeType {
    Prompt,
    File,
    Sql,
}

pub fn get_all_cadidates(
    s: String,
) -> anyhow::Result<
    Vec<(
        /*prompt*/ String,
        /*type*/ AttributeType,
        /*sql,filepath,...*/ Option<String>,
    )>,
> {
    let mut v: Vec<(String, AttributeType, Option<String>)> = Vec::new();
    // println!("{:?}", s);
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
                        v.push((matched.as_str().to_string(), AttributeType::Prompt, None));
                    }
                }

                // println!("{:?}", d.attributes);

                if d.attributes.is_some() {
                    if d.attributes.clone().unwrap().sql.is_some() {
                        v.push((
                            d.insert.clone(),
                            AttributeType::Sql,
                            d.attributes.clone().unwrap().sql,
                        ));
                    }

                    if d.attributes.clone().unwrap().file.is_some() {
                        v.push((
                            d.insert.clone(),
                            AttributeType::File,
                            d.attributes.clone().unwrap().file,
                        ));
                    }
                }
            }
        }
    }

    anyhow::Ok(v)
}
