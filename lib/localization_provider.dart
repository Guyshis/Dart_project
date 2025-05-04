// lib/localization_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationProvider with ChangeNotifier {
  String _language = 'Русский';

  final Map<String, Map<String, String>> _localizedStrings = {
    'Русский': {
      'start_game': 'Начать игру',
      'authors': 'Авторы',
      'settings': 'Настройки',
      'back': 'Назад',
      'language': 'Язык',
      'volume': 'Громкость',
      'brightness': 'Яркость',
      'dark_theme': 'Ночная тема',
      'snake': 'Змейка',
      'developer': 'Разработчик',
      'contacts': 'Контакты',
      'score': 'Счёт',
      'record': 'Рекорд',
      'game_over': 'Игра окончена!',
      'your_score': 'Ваш счёт',
      'play_again': 'Играть снова',
      'to_menu': 'В меню',
      'designer': 'Дизайнер',
      'tester': 'Тестировщик',
      

      
    },
    'English': {
      'start_game': 'Start Game',
      'authors': 'Authors',
      'settings': 'Settings',
      'back': 'Back',
      'language': 'Language',
      'volume': 'Volume',
      'brightness': 'Brightness',
      'dark_theme': 'Dark Theme',
      'snake': 'Snake',
      'developer': 'Developer',
      'contacts': 'Contacts',
      'score': 'Score',
      'record': 'Record',
      'game_over': 'Game Over!',
      'your_score': 'Your score',
      'play_again': 'Play Again',
      'to_menu': 'To Menu',
      'designer': 'Designer',
      'tester': 'Tester',

    },
  };

  LocalizationProvider() {
    _loadLanguage();
  }

  String get language => _language;

  String t(String key) => _localizedStrings[_language]?[key] ?? key;

  void setLanguage(String lang) async {
    _language = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
    notifyListeners();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _language = prefs.getString('language') ?? 'Русский';
    notifyListeners();
  }
}
