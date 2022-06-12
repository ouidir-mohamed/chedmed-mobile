import 'package:chedmed/ressources/shared_preference/shared_preference.dart';
import 'package:chedmed/ui/getting_started/getting_started.dart';
import 'package:chedmed/ui/loading/loading_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../ressources/repository/repository.dart';
import '../ui/navigation/bottom_navigation.dart';

class SessionBloc {
  checkSession() async {
    await Future.delayed(Duration(seconds: 1));
    String? token = SharedPreferenceData.loadToken();
    if (token != null) {
      _addTokenInterceptor(token);
      Navigator.pushReplacement(requireContext(),
          MaterialPageRoute(builder: (context) => LoadingScreen()));
      return;
    }

    Navigator.pushReplacement(requireContext(),
        MaterialPageRoute(builder: (context) => GettingStarted()));
  }

  static _addTokenInterceptor(String token) {
    dio.interceptors.add(InterceptorsWrapper(onRequest: (request, handler) {
      request.headers["Authorization"] = "Bearer " + token;
      return handler.next(request);
    }));
  }
}
