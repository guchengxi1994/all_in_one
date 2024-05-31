import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:all_in_one/common/logger.dart';
import 'package:all_in_one/src/rust/api/llm_plugin_api.dart';
import 'package:file_type/types/type.dart';
import 'package:langchain_lib/langchain_lib.dart';
import 'package:langchain_lib/models/template_item.dart';
import 'package:file_type/match.dart';

class AiClient {
  AiClient._();

  static final _instance = AiClient._();

  factory AiClient() => _instance;

  initOpenAi(String path) {
    OpenaiClient.fromEnv(path);
  }

  static final Match matcher = Match();

  Stream<ChatResult> optimizeDocStream(String doc,
      {String tag = "text-model"}) {
    final client = OpenaiClient.getByTag(tag);

    final role =
        getPromptByName(key: "role-define", module: "template-optimize") ??
            "you are a good writer";
    final insPrompt = getPromptByName(
            key: "instruction-define", module: "template-optimize") ??
        "Rewrite this article in chinese";

    final history = [
      MessageUtil.createSystemMessage(role),
      MessageUtil.createHumanMessage(insPrompt),
      MessageUtil.createHumanMessage(doc)
    ];

    return client!.stream(history);
  }

  Future<ChatResult?> optimizeDoc(String doc,
      {String tag = "text-model"}) async {
    final client = OpenaiClient.getByTag(tag);
    if (client == null) {
      return null;
    }

    final role =
        getPromptByName(key: "role-define", module: "template-optimize");
    if (role == null) {
      return null;
    }
    final insPrompt =
        getPromptByName(key: "instruction-define", module: "template-optimize");
    if (insPrompt == null) {
      return null;
    }
    final history = [
      MessageUtil.createSystemMessage(role),
      MessageUtil.createHumanMessage(insPrompt),
      MessageUtil.createHumanMessage(doc)
    ];
    int tryTimes = 0;
    // ignore: avoid_init_to_null
    late ChatResult? result = null;

    while (tryTimes < client.maxTryTimes) {
      tryTimes += 1;
      // print(tryTimes);
      logger.info(
          "Retrying $tryTimes times, remaining ${client.maxTryTimes - tryTimes} times");
      try {
        result = await client.invoke(history);
        break;
      } catch (e) {
        // logger.severe(e.toString());
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    return result;
  }

  Stream<ChatResult> textToMindMap(String text, {String tag = "text-model"}) {
    final client = OpenaiClient.getByTag(tag);

    final role = getPromptByName(key: "role-define", module: "conversion") ??
        "you are a good analyst";
    final insPrompt = getPromptByName(
            key: "convert-file-to-mind-map", module: "conversion") ??
        "convert this article to json";

    final history = [
      MessageUtil.createSystemMessage(role),
      MessageUtil.createHumanMessage(insPrompt),
      MessageUtil.createHumanMessage(text)
    ];
    return client!.stream(history);
  }

  Future<ChatResult> textToSchedule(String text,
      {String tag = "text-model"}) async {
    final client = OpenaiClient.getByTag(tag);

    final role = getPromptByName(key: "role-define", module: "co-pilot") ??
        "you are a good assistant";
    final insPrompt =
        getPromptByName(key: "add-schedule", module: "co-pilot") ??
            "convert this text to json";
    final date = DateTime.now();
    final dateStart = DateTime(date.year, date.month, date.day);
    final dateEnd = DateTime(date.year, date.month, date.day, 23, 59, 59);
    final date6 = DateTime(date.year, date.month, date.day, 6);
    final date12 = DateTime(date.year, date.month, date.day, 12);
    final date18 = DateTime(date.year, date.month, date.day, 18);

    String extra = """记住：1. 时区以北京时间为准。
          2.今天是${date.year}年${date.month}月${date.day}日。
          3.今天0点的Unix时间戳是${dateStart.millisecondsSinceEpoch},23点59分59秒时间戳是${dateEnd.millisecondsSinceEpoch}。
          4.今天6点的Unix时间戳是${date6.millisecondsSinceEpoch}，今天12点的Unix时间戳是${date12.millisecondsSinceEpoch}，今天18点的Unix时间戳是${date18.millisecondsSinceEpoch}。
       """;
    final history = [
      MessageUtil.createSystemMessage(role),
      MessageUtil.createSystemMessage(extra),
      MessageUtil.createHumanMessage(insPrompt + text),
    ];
    return await client!.invoke(history);
  }

  Future<Map<String, dynamic>> invokeChainWithTemplateItems(
      List<TemplateItem> items,
      {String tag = "text-model"}) async {
    final client = OpenaiClient.getByTag(tag);
    return client!.invokeChainWithTemplateItems(items);
  }

  Stream<ChatResult> stream(List<ChatMessage> history,
      {String tag = "text-model"}) {
    final client = OpenaiClient.getByTag(tag);
    return client!.stream(history);
  }

  Stream<ChatResult> imageToText(ChatMessage imageMessage,
      {String tag = "vision-model"}) {
    final system = ChatMessage.system(
      '你是一个有用的助手，擅长看图说话。',
    );
    final client = OpenaiClient.getByTag(tag);
    return client!.stream([system, imageMessage]);
  }

  Future<ChatMessage> imageToMessage(
      {required String image,
      ImageType type = ImageType.file,
      required String prompt}) async {
    String fileContent;
    String mimeType = "image/png";

    if (type == ImageType.file) {
      final AbsType? r = await matcher.match(image);
      if (r != null) {
        mimeType = r.mime;
      }

      fileContent = base64Encode(await File(image).readAsBytes());
    } else if (type == ImageType.base64) {
      fileContent = image;
    } else {
      fileContent = "";
    }

    print(fileContent);

    ChatMessage user = ChatMessage.human(ChatMessageContent.multiModal([
      ChatMessageContent.text(prompt),
      ChatMessageContent.image(
          data: type != ImageType.url ? fileContent : image,
          mimeType: type == ImageType.file ? mimeType : null)
    ]));

    return user;
  }
}

enum ImageType { base64, url, file }
