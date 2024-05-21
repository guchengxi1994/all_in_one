class AiGenerateConfigState {
  final String tone;
  final String length;
  final String lang;
  final List<String> extras;

  AiGenerateConfigState(
      {this.extras = const [],
      this.lang = "中文",
      this.length = "中等的",
      this.tone = "正常的"});

  AiGenerateConfigState copyWith(
      {String? tone, String? length, String? lang, List<String>? extras}) {
    return AiGenerateConfigState(
        tone: tone ?? this.tone,
        length: length ?? this.length,
        lang: lang ?? this.lang,
        extras: extras ?? this.extras);
  }
}
