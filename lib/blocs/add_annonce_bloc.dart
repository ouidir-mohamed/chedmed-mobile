import 'dart:io';

import 'package:chedmed/models/annonce_request.dart';
import 'package:chedmed/models/city.dart';
import 'package:chedmed/ressources/repository/repository.dart';
import 'package:chedmed/ui/common/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../ressources/shared_preference/shared_preference.dart';
import 'locations_bloc.dart';

class AddAnnonceBloc {
  BehaviorSubject<City> _selectedCityFetcher = BehaviorSubject<City>();
  BehaviorSubject<bool> _loadingFetcher = BehaviorSubject<bool>();
  BehaviorSubject<void> _doneFetcher = BehaviorSubject<void>();

  Stream<City> get getSelectedCity => _selectedCityFetcher.stream;
  Stream<bool> get getLoading => _loadingFetcher.stream;
  Stream<void> get getDone => _doneFetcher.stream;

  String titre = "";
  String description = "";
  int? category_id;
  int? underCategory_id;
  int price = 1;
  List<String> imagePaths = [];

  init() {
    _selectedCityFetcher.sink
        .add(locationsBloc.getCityById(SharedPreferenceData.loadCityId()!));
  }

  selectCity(City city) {
    _selectedCityFetcher.sink.add(city);
  }

  String? titleValidator(String? value) {
    if (value == null || value.length == 0) return ("Le titre est obligatoire");
    if (value.length > 50) return ("Le titre est trés long");
    titre = value;
    return null;
  }

  String? descriptionValidator(String? value) {
    if (value == null || value.length == 0)
      return ("Une description est obligatoire");
    if (value.length > 400) return ("Le discription");
    description = value;
    return null;
  }

  String? cityValidator(String? value) {
    if (!_selectedCityFetcher.hasValue)
      return ("Veuillez selectionnez une ville");

    return null;
  }

  String? priceValidator(String? value) {
    int? parsedValue = int.tryParse(value!);
    if (parsedValue == null) return ("Veuillez ..");
    if (parsedValue < 0) return ("Veuillez ..");
    price = parsedValue;
    return null;
  }

  handleValidation() async {
    if (!addAnnonceFormKey.currentState!.validate()) return;

    AnnonceRequest request = AnnonceRequest(
        title: titre,
        description: description,
        price: price,
        location_id: _selectedCityFetcher.value.id,
        category_id: category_id,
        underCategory_id: underCategory_id,
        imagePaths: imagePaths);

    print(request);

    _loadingFetcher.sink.add(true);
    await Future.delayed(Duration(seconds: 2));
    chedMedApiFormData.addPost(request).then((value) {
      print(value);
      displaySuccessSnackbar("Annonce ajoutée avec success");
      _doneFetcher.sink.add(null);
    }).onError((error, stackTrace) {
      if (error.runtimeType == DioError) {
        DioError e = error as DioError;
        print(e.response);
        displayNetworkErrorSnackbar();
      }
    }).catchError((e) {
      displayNetworkErrorSnackbar();
    }).whenComplete(() {
      _loadingFetcher.sink.add(false);
    });
  }
}

final addAnnonceBloc = AddAnnonceBloc();
final addAnnonceFormKey = GlobalKey<FormState>();
