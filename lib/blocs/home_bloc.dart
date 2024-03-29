import 'package:chedmed/blocs/notifications_bloc.dart.dart';
import 'package:chedmed/blocs/locations_bloc.dart';
import 'package:chedmed/blocs/profile_bloc.dart';
import 'package:chedmed/main.dart';
import 'package:chedmed/models/annonce.dart';
import 'package:chedmed/models/city.dart';
import 'package:chedmed/models/fav_request.dart';
import 'package:chedmed/models/filter_request.dart';
import 'package:chedmed/ressources/repository/repository.dart';
import 'package:chedmed/ressources/shared_preference/shared_preference.dart';
import 'package:chedmed/ui/common/snackbar.dart';
import 'package:chedmed/ui/home/annonce_presentation.dart';
import 'package:chedmed/utils/language_helper.dart';
import 'package:chedmed/utils/time_formatter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import '../models/search_history.dart';
import '../ressources/dao/sahel_dao.dart';
import '../utils/vibration.dart';

class HomeBloc {
  //data fetching
  BehaviorSubject<List<AnnoncePresentation>> _annoncesFetcher =
      BehaviorSubject<List<AnnoncePresentation>>();
  BehaviorSubject<bool> _loadingFetcher = BehaviorSubject<bool>();
  BehaviorSubject<bool> _loadingExtraFetcher = BehaviorSubject<bool>();
  PublishSubject<void> _scrollDownFetcher = PublishSubject<void>();

  Stream<List<AnnoncePresentation>> get getAnnonces => _annoncesFetcher.stream;
  Stream<bool> get getLoading => _loadingFetcher.stream;
  Stream<bool> get getLoadingExtra => _loadingExtraFetcher.stream;
  Stream<void> get getScrollDown => _scrollDownFetcher.stream;

  int currentPage = 1;
  Future<void> getALl({required bool displayShimmer}) async {
    if (_categorieFetcher.hasValue && _categorieFetcher.value != null) {
      var searchHistory = SearchHistory(
          null,
          DateTime.now().subtract(Duration(days: 2)).toDateTimeString(),
          DateTime.now().subtract(Duration(days: 2)).toDateTimeString(),
          _categorieFetcher.value!,
          _underCategoryFetcher.valueOrNull,
          _cityFetcher.value.id,
          _cityFetcher.value.lat,
          _cityFetcher.value.long);
      sahelDao.addToHistory(searchHistory);
    }

    if (displayShimmer) _loadingFetcher.sink.add(true);
    var rayon = _maxDistanceFetcher.valueOrNull;
    if (!(_filtersEnabledFetcher.valueOrNull ?? false)) rayon = 110;

    var request = FilterRequest(
        page: currentPage,
        point: _cityFetcher.value,
        query: query,
        rayon: rayon,
        category_id: _categorieFetcher.valueOrNull,
        underCategory_id: _underCategoryFetcher.valueOrNull,
        maxPrice: _maxPriceFetcher.valueOrNull,
        minPrice: _minPriceFetcher.valueOrNull);

    await chedMedApi.filterPosts(request).then((value) {
      List<AnnoncePresentation> newAnnonces = [];

      newAnnonces = value
          .map((e) => AnnoncePresentation.toAnnoncePresentation(e))
          .toList();
      if (currentPage == 1) {
        _annoncesFetcher.sink.add(newAnnonces);
        return;
      }
      var oldAnnonesList = _annoncesFetcher.value;
      oldAnnonesList.addAll(newAnnonces);
      print(oldAnnonesList.length.toString() + " lngth");
      _annoncesFetcher.sink.add(oldAnnonesList);
    }).whenComplete(() {
      _loadingFetcher.sink.add(false);
      _loadingExtraFetcher.sink.add(false);
      if (currentPage > 1) _scrollDownFetcher.sink.add(null);
    });
    return;
  }

  Future<void> refresh() async {
    currentPage = 1;
    await getALl(displayShimmer: false);
    return;
  }

  getExtra() async {
    if (_loadingFetcher.value ||
        (_annoncesFetcher.hasValue && _annoncesFetcher.value.isEmpty) ||
        (_loadingExtraFetcher.hasValue && _loadingExtraFetcher.value)) return;
    _scrollDownFetcher.sink.add(null);
    vibrateThePhone();
    currentPage += 1;
    print(currentPage);
    _loadingExtraFetcher.sink.add(true);
    getALl(displayShimmer: false);
  }

  //  filters
  BehaviorSubject<int?> _categorieFetcher = BehaviorSubject<int?>();
  BehaviorSubject<int?> _underCategoryFetcher = BehaviorSubject<int?>();
  BehaviorSubject<City> _cityFetcher = BehaviorSubject<City>();

  BehaviorSubject<double> _maxDistanceFetcher = BehaviorSubject<double>();
  BehaviorSubject<double?> _maxPriceFetcher = BehaviorSubject<double?>();

  BehaviorSubject<double?> _minPriceFetcher = BehaviorSubject<double?>();

  BehaviorSubject<bool> _filtersEnabledFetcher = BehaviorSubject<bool>();

  Stream<int?> get getCategorie => _categorieFetcher.stream;
  Stream<int?> get getUnderCategorie => _underCategoryFetcher.stream;
  Stream<City> get getCity => _cityFetcher.stream;
  Stream<double> get getMaxDistance => _maxDistanceFetcher.stream;
  Stream<double?> get getMaxPrice => _maxPriceFetcher.stream;
  Stream<double?> get getMinPrice => _minPriceFetcher.stream;

  Stream<bool> get getFiltersEnabled =>
      _filtersEnabledFetcher.stream.startWith(false);
  String query = "";
  int? categoryCandidate;
  int? underCategoryCandidate;
  late City cityCandidate;
  double? distanceCandidate;
  double? maxPriceCandidate;
  double? minPriceCandidate;

  loadLatestFilters() {
    categoryCandidate = _categorieFetcher.valueOrNull;
    underCategoryCandidate = _underCategoryFetcher.valueOrNull;
    cityCandidate = _cityFetcher.value;
    distanceCandidate = _maxDistanceFetcher.valueOrNull;
    minPriceCandidate = _minPriceFetcher.valueOrNull;
    maxPriceCandidate = _maxPriceFetcher.valueOrNull;
  }

  initFilters() {
    _maxDistanceFetcher.sink.add(60);
    _cityFetcher.sink
        .add(locationsBloc.getCityById(SharedPreferenceData.loadCityId()!));
  }

  setQueryAndApply(String q) {
    query = q;
    currentPage = 1;
    getALl(displayShimmer: true);
  }

  selectCategorie(int? categoryId) {
    categoryCandidate = categoryId;
  }

  selectCategorieAndAply(int? categoryId) {
    _categorieFetcher.sink.add(categoryId);
    currentPage = 1;
    getALl(displayShimmer: true);
  }

  selectUnderCategorie(int? underCategoryId) {
    underCategoryCandidate = underCategoryId;
  }

  selectCity(City city) {
    cityCandidate = city;
    _cityFetcher.sink.add(city);
  }

  setMaxDistance(double distance) {
    distanceCandidate = distance;
  }

  setMaxPrice(String text) {
    maxPriceCandidate = double.tryParse(text);
  }

  setMinPrice(String text) {
    minPriceCandidate = double.tryParse(text);
  }

  validateFilters() {
    _categorieFetcher.sink.add(categoryCandidate);
    _underCategoryFetcher.sink.add(underCategoryCandidate);
    _cityFetcher.sink.add(cityCandidate);
    _maxDistanceFetcher.sink.add(distanceCandidate!);
    _minPriceFetcher.sink.add(minPriceCandidate);
    _maxPriceFetcher.sink.add(maxPriceCandidate);

    _filtersEnabledFetcher.sink.add(true);
    currentPage = 1;
    getALl(displayShimmer: true);
  }

  resetFilters() {
    _filtersEnabledFetcher.sink.add(false);
    _underCategoryFetcher.sink.add(null);
    _categorieFetcher.sink.add(null);
    _maxDistanceFetcher.sink.add(60);
    _maxPriceFetcher.sink.add(null);
    _minPriceFetcher.sink.add(null);

    categoryCandidate = null;
    underCategoryCandidate = null;
    distanceCandidate = 60;
    maxPriceCandidate = null;
    minPriceCandidate = null;

    currentPage = 1;
    getALl(displayShimmer: true);
  }

  //favorite

  addToFavorite(int annonceId) async {
    print(FavRequest(post_id: annonceId).toJson());
    await chedMedApi
        .addToFavorite(FavRequest(post_id: annonceId))
        .onError((error, stackTrace) => print((error as DioError).message))
        .then((value) => print(value));

    await SharedPreferenceData.addToFavoriteAnnonces(annonceId);
    var oldList = _annoncesFetcher.value;
    oldList.forEach((element) {
      if (element.id == annonceId) element.favorite = true;
    });

    _annoncesFetcher.sink.add(oldList);

    displayAddedToFavoriteSnackbar(getTranslation.added_to_fav);
    profileBloc.loadFavoriteAnnonces();
  }

  removeFromFavorite(int annonceId) async {
    await chedMedApi
        .deleteFromFavorite(FavRequest(post_id: annonceId))
        .onError((error, stackTrace) => print(error))
        .then((value) => print(value));
    await SharedPreferenceData.removeFromFavoriteAnnonces(annonceId);
    var oldList = _annoncesFetcher.value;
    oldList.forEach((element) {
      if (element.id == annonceId) element.favorite = false;
    });

    _annoncesFetcher.sink.add(oldList);
    displayRemovedFromFavoriteSnackbar(getTranslation.removed_from_fav);
    profileBloc.loadFavoriteAnnonces();
  }
}

final HomeBloc homeBloc = HomeBloc();
