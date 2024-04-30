class LangchainConfig {
  static LangchainConfig? _instance;

  LangchainConfig._internal();

  factory LangchainConfig() {
    _instance ??= LangchainConfig._internal();
    return _instance!;
  }

  int historyLength = 6;
}
