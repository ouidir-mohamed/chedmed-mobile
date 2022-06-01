import 'package:flutter/material.dart';

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
}
