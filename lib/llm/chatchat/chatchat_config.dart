import 'package:all_in_one/src/rust/api/llm_api.dart' as llm;
import 'package:dio/dio.dart';

import 'models/history.dart';
import 'models/knowledge_base_chat_request.dart';
import 'models/llm_request.dart';

typedef OnError = void Function(String);

typedef OnSending = void Function(int, int);

class ChatchatConfig {
  static ChatchatConfig? _instance;

  ChatchatConfig._internal();

  factory ChatchatConfig() {
    _instance ??= ChatchatConfig._internal();
    return _instance!;
  }

  // ignore: avoid_init_to_null
  late Dio? _dio = null;

  Dio _getDio() {
    if (_dio == null) {
      _dio ??= Dio();
      _dio!.options.baseUrl = _baseUrl;
    }
    return _dio!;
  }

  late String _baseUrl = llm.getLlmConfig()?.chatBase ?? "";
  late String _modelName = llm.getLlmConfig()?.name ?? "";

  final String _knowledgeChat = "/chat/knowledge_base_chat";

  setBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
  }

  setModelName(String modelName) {
    _modelName = modelName;
  }

  bool _stream = true;
  setStream(bool b) {
    _stream = b;
  }

  String get baseUrl => _baseUrl;
  String api = "/chat/chat";
  String get url => _baseUrl + api;
  String get modelName => _modelName;
  bool get stream => _stream;

  Future<Response<dynamic>> getLLMResponseByRequest(LLMRequest request) async {
    return _getDio().post(
      url,
      data: request.toJson(),
      options: request.stream == true
          ? Options(
              responseType: ResponseType.stream,
            )
          : null,
    );
  }

  Future<Response<dynamic>> getLLMResponse(String query,
      {List<IHistory> history = const [], bool isKnowledgeBase = false}) async {
    // ignore: prefer_typing_uninitialized_variables
    final request;

    if (!isKnowledgeBase) {
      request = LLMRequest();
      request.modelName = _modelName;
      request.query = query;
      request.stream = stream;
      request.history = history;
      return _getDio().post(
        url,
        data: request.toJson(),
        options: stream
            ? Options(
                responseType: ResponseType.stream,
              )
            : null,
      );
    } else {
      request = KnowledgeBaseChatRequest();
      request.modelName = _modelName;
      request.query = query;
      request.stream = stream;
      request.history = history;
      request.knowledgeBaseName = "sample";
      return _getDio().post(
        _baseUrl + _knowledgeChat,
        data: request.toJson(),
        options: stream
            ? Options(
                responseType: ResponseType.stream,
              )
            : null,
      );
    }
  }
}
