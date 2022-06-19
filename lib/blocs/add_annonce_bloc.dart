import 'dart:io';

import 'package:chedmed/blocs/profile_bloc.dart';
import 'package:chedmed/models/annonce_request.dart';
import 'package:chedmed/models/city.dart';
import 'package:chedmed/ressources/repository/repository.dart';
import 'package:chedmed/ui/common/snackbar.dart';
import 'package:chedmed/ui/navigation/bottom_navigation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../ressources/shared_preference/shared_preference.dart';
import 'locations_bloc.dart';

class AddAnnonceBloc {
  BehaviorSubject<City> _selectedCityFetcher = BehaviorSubject<City>();
  BehaviorSubject<String> _profilePhoneFetcher = BehaviorSubject<String>();
  PublishSubject<String> _imageErreurFetcher = PublishSubject<String>();

  BehaviorSubject<bool> _loadingFetcher = BehaviorSubject<bool>();
  BehaviorSubject<void> _doneFetcher = BehaviorSubject<void>();

  Stream<City> get getSelectedCity => _selectedCityFetcher.stream;
  Stream<String> get getProfilePhone => _profilePhoneFetcher.stream;
  Stream<String> get getImageErreur => _imageErreurFetcher.stream;

  Stream<bool> get getLoading => _loadingFetcher.stream;
  Stream<void> get getDone => _doneFetcher.stream;

  String titre = "";
  String description = "";
  String phone = "";
  int? category_id;
  int? underCategory_id;
  int price = 1;
  List<String> imagePaths = [];
  bool delivery = false;

  init() {
    _selectedCityFetcher.sink
        .add(locationsBloc.getCityById(SharedPreferenceData.loadCityId()!));

    _profilePhoneFetcher.sink.add(SharedPreferenceData.loadPhone());
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

  String? phoneValidator(String? value) {
    if (value == null || value.length == 0 || value.length > 10)
      return ("Ce numéro n'est pas valide");
    phone = value;
    return null;
  }

  String? priceValidator(String? value) {
    int? parsedValue = int.tryParse(value!);
    if (parsedValue == null) return ("Veuillez ..");
    if (parsedValue < 0) return ("Veuillez ..");
    price = parsedValue;
    return null;
  }

  bool imagesValidator() {
    if (imagePaths.isEmpty) {
      _imageErreurFetcher.sink.add("Veuillez choisir au moin une photo");
      return false;
    }

    if (imagePaths.length > 4) {
      _imageErreurFetcher.sink
          .add("Vous ne pouvez pas choisir plus de 4 photos");
      return false;
    }

    _imageErreurFetcher.sink.add("");

    return true;
  }

  handleValidation() async {
    if (!addAnnonceFormKey.currentState!.validate()) return;
    if (!imagesValidator()) return;
    AnnonceRequest request = AnnonceRequest(
        title: titre,
        description: description,
        phone: phone,
        price: price,
        location_id: _selectedCityFetcher.value.id,
        category_id: category_id,
        underCategory_id: underCategory_id,
        delivry: delivery,
        imagePaths: imagePaths);

    _loadingFetcher.sink.add(true);
    chedMedApiFormData.addPost(request).then((value) {
      displaySuccessSnackbar("Annonce ajoutée avec success");
      navigationController.jumpToTab(2);
      profileBloc.loadProfileAnnonces();
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
