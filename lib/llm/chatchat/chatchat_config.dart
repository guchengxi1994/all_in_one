import 'package:all_in_one/src/rust/api/llm_api.dart' as llm;
import 'package:dio/dio.dart';

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
}
