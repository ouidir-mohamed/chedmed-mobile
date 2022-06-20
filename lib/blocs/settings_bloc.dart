import 'package:chedmed/blocs/add_annonce_bloc.dart';
import 'package:chedmed/blocs/home_bloc.dart';
import 'package:chedmed/ressources/shared_preference/shared_preference.dart';
import 'package:chedmed/ui/common/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../models/city.dart';
import 'locations_bloc.dart';

class SettingsBloc {
  BehaviorSubject<SelectedTheme> _selectedThemeFetcher = BehaviorSubject();
  BehaviorSubject<Locale?> _localeFetcher = BehaviorSubject<Locale?>();
  PublishSubject<City> _defaultCity = PublishSubject<City>();

  Stream<SelectedTheme> get selectedTheme =>
      _selectedThemeFetcher.stream.startWith(_loadSavedTheme());

  Stream<Locale?> get getLocale =>
      _localeFetcher.stream.startWith(loadSavedlocale());

  Stream<City> get getDefaultCity => _defaultCity.stream
      .startWith(locationsBloc.getCityById(SharedPreferenceData.loadCityId()!));

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

  setUserCity(City city) async {
    await SharedPreferenceData.saveCityId(city.id);
    _defaultCity.sink.add(city);
    homeBloc.initFilters();
    addAnnonceBloc.init();
  }
}

SettingsBloc settingsBloc = SettingsBloc();
