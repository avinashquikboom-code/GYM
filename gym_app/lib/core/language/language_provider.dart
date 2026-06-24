import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';
import '../theme/theme_provider.dart';

// Language provider to manage language state
class LanguageNotifier extends StateNotifier<String> {
  final StorageService _storageService;

  LanguageNotifier(this._storageService)
      : super(_storageService.getLanguage());

  void setLanguage(String language) {
    state = language;
    _storageService.setLanguage(language);
  }
}

// Provider for the language state
final languageNotifierProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  final storageService = ref.read(storageServiceProvider);
  return LanguageNotifier(storageService);
});
