import 'package:flutter/material.dart';

import 'app_theme.dart';

MyInputDecoration(
    {required String title,
    required BuildContext context,
    Widget? suffix,
    Widget? prefix}) {
  return InputDecoration(
      hintText: title,
      prefixIcon: prefix,
      suffix: suffix,
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).errorColor, width: 1),
      ),
      fillColor: AppTheme.cardColor(context),
      errorStyle: TextStyle(fontSize: 14),
      filled: true);
}

MyInputDecorationMultiLine(String title, BuildContext context) {
  return InputDecoration(
      hintText: title,
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).errorColor, width: 1),
      ),
      errorStyle: TextStyle(fontSize: 14),
      fillColor: AppTheme.cardColor(context),
      filled: true);
}
