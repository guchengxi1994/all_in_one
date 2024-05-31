import 'dart:convert';
import 'dart:io';

import 'package:langchain_lib/models/llm_models.dart';

LlmModels? loadEnv(String path) {
  File f = File(path);
  if (f.existsSync()) {
    return LlmModels.fromJson(jsonDecode(f.readAsStringSync()));
  } else {
    return null;
  }
}
