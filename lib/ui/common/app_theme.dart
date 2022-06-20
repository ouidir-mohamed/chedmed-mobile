import 'package:flutter/material.dart';

import 'package:chedmed/ui/common/ripple_effect.dart';

class AppTheme {
  static Color primaryColor(BuildContext context) =>
      Theme.of(context).colorScheme.primary;
  static Color secondaryColor(BuildContext context) =>
      Theme.of(context).colorScheme.secondary;
  static Color canvasColor(BuildContext context) =>
      Theme.of(context).canvasColor;

  static Color cardColor(BuildContext context) => Theme.of(context).cardColor;

  static Color textColor(BuildContext context) =>
      Theme.of(context).textTheme.bodyText1!.color!;

  static Color headlineColor(BuildContext context) =>
      Theme.of(context).textTheme.headline1!.color!;

  static Color containerColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? cardColor(context)
          : canvasColor(context);
}

class SelectedTheme {
  ThemeData lightTheme;
  ThemeData darkTheme;
  String code;
  String name;
  SelectedTheme({
    required this.lightTheme,
    required this.darkTheme,
    required this.code,
    required this.name,
  });

  static SelectedTheme systemDefault() {
    return SelectedTheme(
        lightTheme: _lightTheme,
        darkTheme: _darkTheme,
        code: "default",
        name: "Selon le systéme");
  }

  static SelectedTheme forceLight() {
    return SelectedTheme(
        lightTheme: _lightTheme,
        darkTheme: _lightTheme,
        code: "light",
        name: "Claire");
  }

  static SelectedTheme forceDark() {
    return SelectedTheme(
        lightTheme: _darkTheme,
        darkTheme: _darkTheme,
        code: "dark",
        name: "Sombre");
  }

  static ThemeData _lightTheme = ThemeData(
    fontFamily: "Aileron",
    //  fontFamily: "AvenirLTStd",

    colorScheme:
        ColorScheme.light().copyWith(primary: primary, secondary: secondary),
    canvasColor: Color(0xffF2F2F2),
    cardColor: Color(0xffFCFCFC),

    checkboxTheme: CheckboxThemeData(fillColor: checkBoxColor),
    radioTheme: RadioThemeData(fillColor: checkBoxColor),
    splashFactory: MaterialInkSplash.splashFactory,
  );

  static ThemeData _darkTheme = ThemeData(
    fontFamily: "Aileron",
    // fontFamily: "AvenirLTStd",

    colorScheme:
        ColorScheme.dark().copyWith(primary: primary, secondary: secondary),

    canvasColor: Color(0xff010101),
    cardColor: Color(0xff171717),
    checkboxTheme: CheckboxThemeData(fillColor: checkBoxColor),
    radioTheme: RadioThemeData(fillColor: checkBoxColor),
    brightness: Brightness.dark,
    splashFactory: MaterialInkSplash.splashFactory,
  ).copyWith();
}

const primary = Color(0xff2E6CFF);

const secondary = Color(0xfff7547b);
// const primary = Color(0xff30b3f8);

// const secondary = Color(0xfff7547b);

Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };

  return primary;
}

var checkBoxColor = MaterialStateProperty.resolveWith(getColor);
