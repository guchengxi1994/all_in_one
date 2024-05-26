use super::app_flowy_model::AttributeType;

pub struct AppFlowyTemplate {
    pub items: Vec<TemplateItem>,
}

#[derive(Debug, Clone)]
pub struct TemplateItem {
    pub prompt: String,
    pub index: u32,
    pub next: Option<u32>,
    pub attr_type: AttributeType,
    pub extra: Option<String>,
}

impl TemplateItem {
    pub fn from(i: (String, u32, Option<u32>, AttributeType, Option<String>)) -> Self {
        Self {
            prompt: i.0,
            index: i.1,
            next: i.2,
            attr_type: i.3,
            extra: i.4,
        }
    }
}

pub fn generate_template_items_from_list(
    list: Vec<(String, u32, Option<u32>, AttributeType, Option<String>)>,
) -> Vec<TemplateItem> {
    let mut v = Vec::new();
    for i in list {
        v.push(TemplateItem::from(i));
    }

    v
}

#[derive(Debug, Clone)]
pub struct TemplateResult {
    pub prompt: String,
    pub index: u32,
    pub response: String,
}

impl AppFlowyTemplate {
    pub fn from(v: Vec<TemplateItem>) -> Self {
        Self { items: v }
    }

    pub fn into_multiple(&mut self) -> Vec<Vec<&TemplateItem>> {
        self.items.sort_by(|a, b| a.index.cmp(&b.index));
        let mut vecs: Vec<Vec<&TemplateItem>> = Vec::new();
        let mut saved: Vec<u32> = Vec::new();

        let mut i = 0;
        while i < self.items.len() {
            let mut item = self.items.get(i).unwrap();
            if saved.contains(&item.index) {
                i += 1;
                continue;
            }

            let mut sub_vec = Vec::new();
            sub_vec.push(item);
            i = i + 1;
            if item.next == None {
                saved.push(item.index);
                vecs.push(sub_vec);
            } else {
                for next in &self.items {
                    if saved.contains(&next.index) {
                        continue;
                    }
                    if item.next == None {
                        saved.push(item.index);
                        // vecs.push(sub_vec);
                        break;
                    }

                    if next.index == item.next.unwrap() {
                        sub_vec.push(next);
                        saved.push(next.index);
                        item = next;
                    }
                }

                vecs.push(sub_vec);
            }
        }
        vecs
    }
}

// /// TODO: 暂时sql和文件问答不支持顺序链
// async fn items_to_chain_with_plugins<C: Config + Send + Sync + 'static>(
//     items: &Vec<&TemplateItem>,
//     llm: OpenAI<C>,
// ) -> (Option<Box<dyn Chain>>, Option<String>) {
//     if items.is_empty() {
//         return (None, None);
//     }

//     if items.len() == 1 {
//         let mut extra_content = "".to_owned();
//         let item = items.get(0).unwrap();
//         // sql

//         // file
//         if item.attr_type == AttributeType::File {
//             let file_content = get_file_content(item.extra.clone().unwrap_or("".to_owned())).await;
//             match file_content {
//                 Ok(_f) => {
//                     extra_content = _f;
//                 }
//                 Err(_e) => {
//                     println!("[rust-error] file content is None");
//                     return (None, None);
//                 }
//             }
//         }

//         // 返回一般的LLMChain
//         let prompt = HumanMessagePromptTemplate::new(PromptTemplate::new(
//             items.first().unwrap().prompt.clone() + &extra_content,
//             vec![],
//             TemplateFormat::FString,
//         ));
//         let normal_chain = LLMChainBuilder::new()
//             .prompt(prompt)
//             .llm(llm.clone())
//             .build()
//             .unwrap();
//         return (Some(Box::new(normal_chain)), None);
//     }

//     if items.len() > 1 {
//         // let mut chains: Vec<LLMChain> = Vec::new();
//         let mut seq_chain_builder = SequentialChainBuilder::new();
//         let mut i = 0;
//         while i < items.len() {
//             let input = format!("input{}", i);
//             let output = format!("input{}", i + 1);
//             let prompt_str;
//             if i == 0 {
//                 prompt_str =
//                     "请根据以下要求，帮我生成对应的文案。 {{".to_owned() + &input + "}}";
//             } else {
//                 prompt_str = "请根据以下内容和额外要求，帮我生成对应的文案。内容: {{".to_owned()
//                     + &input
//                     + "}}, 额外要求: "
//                     + &items.get(i).unwrap().prompt;
//             }

//             let prompt = HumanMessagePromptTemplate::new(template_jinja2!(prompt_str, input));
//             let c = LLMChainBuilder::new()
//                 .prompt(prompt)
//                 .llm(llm.clone())
//                 .output_key(output)
//                 .build()
//                 .unwrap();
//             // chains.push(c);
//             seq_chain_builder = seq_chain_builder.add_chain(c);
//             i += 1;
//         }

//         let seq_chain = seq_chain_builder.build();
//         return (
//             Some(Box::new(seq_chain)),
//             Some(items.first().unwrap().prompt.clone()),
//         );
//     }

//     (None, None)
// }
