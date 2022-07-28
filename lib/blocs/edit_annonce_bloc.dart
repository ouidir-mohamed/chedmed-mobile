import 'package:chedmed/blocs/profile_bloc.dart';
import 'package:chedmed/models/annonce.dart';
import 'package:chedmed/ressources/repository/repository.dart';
import 'package:chedmed/utils/language_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../models/annonce_request.dart';
import '../models/city.dart';
import '../ui/common/snackbar.dart';
import 'file_download.dart';

class EditAnnonceBloc {
  PublishSubject<Annonce> _initialAnnonceFetcher = PublishSubject();
  PublishSubject<List<String>> _initialImagesFetcher = PublishSubject();

  BehaviorSubject<City> _selectedCityFetcher = BehaviorSubject<City>();
  PublishSubject<void> _doneFetcher = PublishSubject<void>();
  PublishSubject<String> _imageErreurFetcher = PublishSubject<String>();
  PublishSubject<bool> _initDataLoadingFetcher = PublishSubject<bool>();
  PublishSubject<bool> _editLoadingFetcher = PublishSubject<bool>();

  Stream<Annonce> get getInitialAnnonce => _initialAnnonceFetcher.stream;
  Stream<List<String>> get getInitialImages => _initialImagesFetcher.stream;

  Stream<City> get getSelectedCity => _selectedCityFetcher.stream;
  Stream<void> get getDone => _doneFetcher.stream;
  Stream<String> get getImageErreur => _imageErreurFetcher.stream;
  Stream<bool> get getInitLoading => _initDataLoadingFetcher.stream;
  Stream<bool> get getEditLoading => _editLoadingFetcher.stream;

  int? annonceId;
  String titre = "";
  String description = "";
  String phone = "";
  int? category_id;
  int? underCategory_id;
  int price = 1;
  bool delivery = false;
  List<String> imagePaths = [];

  loadInitialAnnonce(int annonceId) {
    _initDataLoadingFetcher.sink.add(true);
    this.annonceId = annonceId;
    chedMedApi.getPostById(annonceId).then((value) {
      _initialAnnonceFetcher.sink.add(value);
      _selectedCityFetcher.sink.add(value.location);
      category_id = value.category_id;
      underCategory_id = value.underCategory_id;
      titre = value.title;
      description = value.description;
      phone = value.phone;
      price = value.price;
      delivery = value.delivry;
      loadInitialImages(value.images);
    });
  }

  loadInitialImages(List<String> urls) async {
    List<String> paths = [];
    urls.forEach((element) async {
      var file = await urlToFile(element);
      paths.add(file.path);
      if (paths.length == urls.length) {
        _initialImagesFetcher.sink.add(paths);
        imagePaths = paths;
        _initDataLoadingFetcher.sink.add(false);
      }
    });
  }

  String? titleValidator(String? value) {
    if (value == null || value.length == 0)
      return (getTranslation.title_required);
    if (value.length > 50) return ("Le titre est trés long");
    titre = value;
    return null;
  }

  String? descriptionValidator(String? value) {
    if (value == null || value.length == 0)
      return (getTranslation.description_required);
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
    var reg = RegExp(r'^(0)(5|6|7|)[0-9]{8}$');
    if (!reg.hasMatch(value!)) return (getTranslation.phone_invalide);
    phone = value;
    return null;
  }

  String? priceValidator(String? value) {
    int? parsedValue = int.tryParse(value!.replaceAll(" ", ""));
    if (parsedValue == null) return (getTranslation.price_invalide);
    if (parsedValue < 0) return (getTranslation.price_invalide);
    price = parsedValue;
    return null;
  }

  selectCity(City city) {
    _selectedCityFetcher.sink.add(city);
  }

  bool imagesValidator() {
    if (imagePaths.isEmpty) {
      _imageErreurFetcher.sink.add(getTranslation.one_photo_at_least);
      return false;
    }

    if (imagePaths.length > 4) {
      _imageErreurFetcher.sink.add(getTranslation.four_photos_max);
      return false;
    }

    _imageErreurFetcher.sink.add("");

    return true;
  }

  handleValidation() async {
    if (!editAnnonceFormKey.currentState!.validate()) return;
    if (!imagesValidator()) return;
    _editLoadingFetcher.sink.add(true);
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
    print(request);

    chedMedApiFormData.editPost(request, annonceId!).then((value) {
      displaySuccessSnackbar(getTranslation.post_edited);
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
      _editLoadingFetcher.sink.add(false);
    });
  }
}

EditAnnonceBloc editAnnonceBloc = EditAnnonceBloc();
final editAnnonceFormKey = GlobalKey<FormState>();
