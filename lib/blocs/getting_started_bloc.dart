import 'dart:convert';
import 'dart:math';

import 'package:chedmed/blocs/locations_bloc.dart';
import 'package:chedmed/main.dart';
import 'package:chedmed/models/user_request.dart';
import 'package:chedmed/ressources/shared_preference/shared_preference.dart';
import 'package:chedmed/ui/loading/loading_screen.dart';
import 'package:chedmed/ui/navigation/bottom_navigation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:kdtree/kdtree.dart';
import 'package:rxdart/rxdart.dart';
import 'package:latlong2/latlong.dart';

import '../models/city.dart';
import '../ressources/firebase/cloud_messaging.dart';
import '../ressources/repository/repository.dart';
import '../ressources/websocket/chat_socket.dart';
import '../ui/common/snackbar.dart';
import '../utils/language_helper.dart';
import 'location_helper.dart';

class GettingStartedBloc {
  final _selectedCityFetcher = BehaviorSubject<City>();
  final _loadingFetcher = PublishSubject<bool>();
  final _errorFetchr = PublishSubject<bool>();

  Stream<City> get getSelectedCity => _selectedCityFetcher.stream;
  Stream<bool> get getLoading => _loadingFetcher.stream;
  Stream<bool> get getError => _errorFetchr.stream;
  String username = "";
  String? nameValidator(String? value) {
    if (value == null || value.length == 0)
      return (getTranslation.name_required);
    if (value.length > 50) return (getTranslation.name_too_long);
    username = value;
    return null;
  }

  String phone = "";
  String? phoneValidator(String? value) {
    value = value!.replaceAll(" ", "");
    print(value);

    var reg = RegExp(r'^(0)(5|6|7)[0-9]{8}$');
    var regFix = RegExp(r'^(0)(2|3|4)[0-9]{7}$');

    if (!(reg.hasMatch(value) || regFix.hasMatch(value)))
      return (getTranslation.phone_invalide);
    phone = value;
    return null;
  }

  String? cityValidator(String? value) {
    if (!_selectedCityFetcher.hasValue) return (getTranslation.city_required);
    return null;
  }

  handleNext() {
    FocusManager.instance.primaryFocus?.unfocus();

    switch (currentPage) {
      case 0:
        {
          checkName();
          break;
        }
      case 1:
        {
          checkPhone();

          break;
        }
      case 2:
        {
          checkCity();
          break;
        }

      default:
        {
          introKey.currentState?.next();
          currentPage++;
        }
    }
  }

  requestCurrentCity() {
    locationsBloc.requestCurrentLocation();
    locationsBloc.getFoundCity.listen((event) {
      _selectedCityFetcher.sink.add(event);
    });
  }

  checkName() {
    if (!nameFormKey.currentState!.validate()) return;
    introKey.currentState?.next();
    currentPage++;
  }

  checkPhone() {
    if (!numberFormKey.currentState!.validate()) return;
    introKey.currentState?.next();
    currentPage++;
    requestCurrentCity();
  }

  checkCity() {
    if (!cityFormKey.currentState!.validate()) return;
    introKey.currentState?.next();
    currentPage++;
  }

  handlePrevious() {
    introKey.currentState?.previous();
    currentPage--;
  }

  handleValidation() async {
    _loadingFetcher.sink.add(true);
    UserRequest request = UserRequest(username: username, phone: phone);
    chedMedApi.signUp(request).then((value) {
      validateUser(value.token, _selectedCityFetcher.value.id, username, phone);
      Navigator.pushReplacement(requireContext(),
          MaterialPageRoute(builder: (context) => LoadingScreen()));
    }).catchError((e) {
      if (e.runtimeType == DioError) {
        var err = e as DioError;
        print(e.response);
      }
      displayNetworkErrorSnackbar();
    }).whenComplete(() {
      _loadingFetcher.sink.add(false);
    });
  }

  final introKey = GlobalKey<IntroductionScreenState>();
  final nameFormKey = GlobalKey<FormState>();
  final numberFormKey = GlobalKey<FormState>();
  final cityFormKey = GlobalKey<FormState>();

  int currentPage = 0;

  selectCity(City city) {
    _selectedCityFetcher.sink.add(city);
  }
}

final gettingStartedBloc = GettingStartedBloc();

validateUser(String token, int cityId, String username, String phone) async {
  addTokenInterceptor(token);
  await SharedPreferenceData.saveToken(token);
  await SharedPreferenceData.saveCityId(cityId);
  await SharedPreferenceData.savePhone(phone);
  await SharedPreferenceData.saveUserName(username);

  await CloudMessagingService.updateUserToken();

  Navigator.pushReplacement(requireContext(),
      MaterialPageRoute(builder: (context) => LoadingScreen()));
}

addTokenInterceptor(String token) {
  dio.interceptors.add(InterceptorsWrapper(onRequest: (request, handler) {
    request.headers["Authorization"] = "Bearer " + token;
    return handler.next(request);
  }));

  chatSocket.init(token);
}

// bypassStart() {
//   addTokenInterceptor(
//       "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOjYyLCJ1c2VybmFtZSI6ImFrIGNoYXllZiAiLCJwaG9vbmUiOiI2NjY2IiwiaWF0IjoxNjU0NzI1NjQ1LCJleHAiOjE2NTczMTc2NDV9.Ld20WGPwqzoCgZrkNDoYGXt7EWK3ewmhYxhO_Ze--mY");
//   Navigator.pushReplacement(requireContext(),
//       MaterialPageRoute(builder: (context) => LoadingScreen()));
// }
