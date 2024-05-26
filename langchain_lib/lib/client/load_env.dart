import 'dart:io';

List<String> loadEnv(String path) {
  File f = File(path);
  if (f.existsSync()) {
    final lines = f.readAsLinesSync();
    // return f.readAsLinesSync();
    final List<String> result = [];
    for (final i in lines) {
      if (i.startsWith('#')) {
        continue;
      }
      final s = i.split("=");
      if (s.length == 2) {
        if (s[0].trim() == "LLM_BASE" ||
            s[0].trim() == "LLM_MODEL_NAME" ||
            s[0].trim() == "LLM_SK") {
          result.add(s[1].trim());
        }
      }
    }

    return result;
  } else {
    return [];
  }
}
