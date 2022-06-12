import 'package:chedmed/main.dart';
import 'package:chedmed/models/category.dart';
import 'package:chedmed/ressources/repository/repository.dart';
import 'package:chedmed/ui/navigation/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class LoadingRessourcesBloc {
  final _allCategoriesFetcher = BehaviorSubject<List<Category>>();
  final _loadingFetcher = PublishSubject<bool>();

  Stream<List<Category>> get getAllCategories => _allCategoriesFetcher.stream;
  Stream<bool> get getLoading => _loadingFetcher;
  List<Category> categories = [];
  loadCategories() {
    _loadingFetcher.sink.add(true);
    chedMedApi.getAllCategories().then((value) {
      _allCategoriesFetcher.sink.add(value);
      categories = value;
      openApp();
      print(value);
    }).onError((error, stackTrace) {
      print(error);
    }).catchError((e) {
      print(e);
    }).whenComplete(() {
      _loadingFetcher.sink.add(false);
    });
  }

  openApp() {
    Navigator.pushReplacement(requireContext(),
        MaterialPageRoute(builder: (context) => BottomNavBar()));
  }
}

final LoadingRessourcesBloc loadingRessourcesBloc = LoadingRessourcesBloc();
