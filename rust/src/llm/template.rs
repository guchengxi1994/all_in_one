pub struct AppFlowyTemplate {
    pub items: Vec<TemplateItem>,
}

#[derive(Debug, Clone)]
pub struct TemplateItem {
    pub prompt: String,
    pub index: u32,
    pub next: Option<u32>,
}

pub struct TemplateResult {
    pub prompt: String,
    pub index: u32,
    pub response: String,
}

impl AppFlowyTemplate {
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

#[allow(unused_imports)]
mod tests {
    use super::{AppFlowyTemplate, TemplateItem};

    #[test]
    fn test_flow() {
        println!("app_flowy_template");
        let mut app_flowy_template = AppFlowyTemplate {
            items: vec![
                TemplateItem {
                    prompt: "First".to_string(),
                    index: 1,
                    next: Some(2),
                },
                TemplateItem {
                    prompt: "Second".to_string(),
                    index: 2,
                    next: Some(3),
                },
                TemplateItem {
                    prompt: "Third".to_string(),
                    index: 3,
                    next: None,
                },
                TemplateItem {
                    prompt: "4".to_string(),
                    index: 4,
                    next: Some(5),
                },
                TemplateItem {
                    prompt: "5".to_string(),
                    index: 5,
                    next: None,
                },
                TemplateItem {
                    prompt: "6".to_string(),
                    index: 6,
                    next: None,
                },
            ],
        };

        println!("here we go");

        let separated_vecs = app_flowy_template.into_multiple();

        println!("length {:?}", separated_vecs.len());

        // 打印结果
        for (i, vec) in separated_vecs.iter().enumerate() {
            println!("Sequence {}: {:?}", i + 1, vec);
        }
    }
}
