import 'package:chedmed/ressources/shared_preference/shared_preference.dart';
import 'package:chedmed/ui/common/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc {
  BehaviorSubject<SelectedTheme> _selectedThemeFetcher = BehaviorSubject();
  BehaviorSubject<Locale?> _localeFetcher = BehaviorSubject<Locale?>();

  Stream<SelectedTheme> get selectedTheme =>
      _selectedThemeFetcher.stream.startWith(_loadSavedTheme());

  Stream<Locale?> get getLocale =>
      _localeFetcher.stream.startWith(loadSavedlocale());

  SelectedTheme _loadSavedTheme() {
    switch (SharedPreferenceData.loadTheme()) {
      case "default":
        return SelectedTheme.systemDefault();
      case "light":
        return SelectedTheme.forceLight();
      case "dark":
        return SelectedTheme.forceDark();
    }
    return SelectedTheme.systemDefault();
  }

  Locale? loadSavedlocale() {
    String languageCode = SharedPreferenceData.loadLocale();
    if (languageCode.isEmpty) return null;
    return Locale(languageCode);
  }

  setLocale(Locale locale) {
    print(locale.languageCode);
    _localeFetcher.sink.add(locale);
    SharedPreferenceData.saveLocale(locale.languageCode);
  }

  useDefaultTheme() {
    _selectedThemeFetcher.sink.add(SelectedTheme.systemDefault());
    SharedPreferenceData.saveTheme("default");
  }

  forceLightTheme() {
    _selectedThemeFetcher.sink.add(SelectedTheme.forceLight());
    SharedPreferenceData.saveTheme("light");
  }

  forceDarkTheme() {
    _selectedThemeFetcher.sink.add(SelectedTheme.forceDark());
    SharedPreferenceData.saveTheme("dark");
  }
}

SettingsBloc settingsBloc = SettingsBloc();
