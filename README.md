# all_in_one

> this project is just for fun, a lot of features are not stable and not usable.
> so far, only tried it out on `Kimi` and `tongyi`.
> some prompts might not perform as well as expected.

### how to run

* create an `env.json` file in root folder with configs like
  ```
    {
    "models": [
        {
            "tag": "text-model",
            "llm-base": "https://****/v1",
            "llm-model-name": "****",
            "llm-sk": "****"
        },
        {
            "tag": "vision-model",
            "llm-base": "https://****/v1",
            "llm-model-name": "****",
            "llm-sk": "****"
        },
        ...
    ]
}
  ```

### platforms

| platform |  status   |
| -------- | ----- |
| linux    | on work |
| macos    | not planned |
| windows  | on work |

### features

* LLM (WIP)
  
  ![image-20240504112014938](./images/image-20240504112014938.png)
  
  ![image-20240504112102907](./images/image-20240504112102907.png)
  
* generate document from `template`(WIP)

  | define template                                        | define relation                                        |
  | ------------------------------------------------------ | ------------------------------------------------------ |
  | ![image-20240511-215317](./images/20240511-215317.jpg) | ![image-20240511-215326](./images/20240511-215326.jpg) |
  | generate                                               | optimize                                               |
  | ![image-20240511-215330](./images/20240511-215330.jpg) | ![image-20240511-215333](./images/20240511-215333.jpg) |

  > **bugs-to-be-fixed**
  > - [ ] sometimes, generated file is too long and `optimize_doc` return error message

* ...
