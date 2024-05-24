import 'package:all_in_one/llm/editor/models/ai_generate_config_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AiGenerateConfigNotifier extends Notifier<AiGenerateConfigState> {
  @override
  AiGenerateConfigState build() {
    return AiGenerateConfigState();
  }

  changeTone(String tone) {
    state = state.copyWith(tone: tone);
  }

  changeLength(String length) {
    state = state.copyWith(length: length);
  }

  changeLang(String lang) {
    state = state.copyWith(lang: lang);
  }

  addExtra(String s) {
    List<String> l = List.from(state.extras);
    state = state.copyWith(extras: l..add(s));
  }

  removeExtra(String s) {
    List<String> l = List.from(state.extras);
    state = state.copyWith(extras: l..remove(s));
  }
}

final aiGenerateConfigNotifierProvider =
    NotifierProvider<AiGenerateConfigNotifier, AiGenerateConfigState>(
  () => AiGenerateConfigNotifier(),
);
