import 'dart:io';

import 'package:chedmed/blocs/location_helper.dart';
import 'package:chedmed/blocs/locations_bloc.dart';
import 'package:chedmed/ressources/shared_preference/shared_preference.dart';
import 'package:chedmed/ui/common/ripple_effect.dart';
import 'package:chedmed/ui/getting_started/getting_started.dart';
import 'package:chedmed/ui/home/home.dart';
import 'package:chedmed/ui/session_check/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'ui/navigation/bottom_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = new MyHttpOverrides();
  await SharedPreferenceData.init();
  locationsBloc.loadCties();

  runApp(const MyApp());
}

// const primary = Color(0xff5458f7);

// const secondary = Color(0xfff7547b);

const primary = Color(0xff30b3f8);

const secondary = Color(0xfff7547b);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: "Aileron",
          //  fontFamily: "AvenirLTStd",

          colorScheme: ColorScheme.light()
              .copyWith(primary: primary, secondary: secondary),
          canvasColor: Color(0xffF2F2F2),
          cardColor: Color(0xffFCFCFC),

          checkboxTheme: CheckboxThemeData(fillColor: checkBoxColor),
          radioTheme: RadioThemeData(fillColor: checkBoxColor),
          splashFactory: MaterialInkSplash.splashFactory,
        ),
        darkTheme: ThemeData(
          // fontFamily: "Aileron",
          // fontFamily: "AvenirLTStd",

          colorScheme: ColorScheme.dark()
              .copyWith(primary: primary, secondary: secondary),

          canvasColor: Color(0xff010101),
          cardColor: Color(0xff171717),
          checkboxTheme: CheckboxThemeData(fillColor: checkBoxColor),
          radioTheme: RadioThemeData(fillColor: checkBoxColor),
          brightness: Brightness.dark,
          splashFactory: MaterialInkSplash.splashFactory,
        ),
        home: SessionLoadingScreen());
  }
}

Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };

  return Color(0xff585cff);
}

var checkBoxColor = MaterialStateProperty.resolveWith(getColor);

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
requireContext() {
  return navigatorKey.currentContext!;
}
