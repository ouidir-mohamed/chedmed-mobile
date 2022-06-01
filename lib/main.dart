import 'dart:io';

import 'package:chedmed/ui/common/ripple_effect.dart';
import 'package:chedmed/ui/home/home.dart';
import 'package:flutter/material.dart';

void main() {
  HttpOverrides.global = new MyHttpOverrides();

  runApp(const MyApp());
}

const primary = Color(0xff30b3f8);

const secondary = Color(0xffEB5353);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: "Aileron",
          //  fontFamily: "AvenirLTStd",

          colorScheme: ColorScheme.light()
              .copyWith(primary: primary, secondary: secondary),
          canvasColor: Color(0xfff5f5f5),
          checkboxTheme: CheckboxThemeData(fillColor: checkBoxColor),
          radioTheme: RadioThemeData(fillColor: checkBoxColor),
          splashFactory: MaterialInkSplash.splashFactory,
        ),
        darkTheme: ThemeData(
          // fontFamily: "Aileron",
          // fontFamily: "AvenirLTStd",

          colorScheme: ColorScheme.dark()
              .copyWith(primary: primary, secondary: secondary),

          canvasColor: Color(0xff151515),
          checkboxTheme: CheckboxThemeData(fillColor: checkBoxColor),
          radioTheme: RadioThemeData(fillColor: checkBoxColor),
          brightness: Brightness.dark,
          splashFactory: MaterialInkSplash.splashFactory,
        ),
        home: HomePage());
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
