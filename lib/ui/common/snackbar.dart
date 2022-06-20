import 'package:chedmed/main.dart';
import 'package:chedmed/ui/common/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

displayNetworkErrorSnackbar() {
  ScaffoldMessenger.of(requireContext()).clearSnackBars();

  ScaffoldMessenger.of(requireContext()).showSnackBar(SnackBar(
    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
    behavior: SnackBarBehavior.floating,
    content: Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Feather.alert_triangle,
            color: AppTheme.primaryColor(requireContext()),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Désolé, un probléme est survenue",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    ),
    duration: Duration(seconds: 5),
  ));
}

displaySuccessSnackbar(String message) {
  ScaffoldMessenger.of(requireContext()).showSnackBar(SnackBar(
    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
    behavior: SnackBarBehavior.floating,
    content: Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Entypo.shopping_bag,
            color: AppTheme.primaryColor(requireContext()),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              message,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    ),
    duration: Duration(seconds: 5),
  ));
}

displayAddedToFavoriteSnackbar(String message) {
  ScaffoldMessenger.of(requireContext()).clearSnackBars();
  ScaffoldMessenger.of(requireContext()).showSnackBar(SnackBar(
    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
    behavior: SnackBarBehavior.floating,
    content: Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            AntDesign.heart,
            color: AppTheme.secondaryColor(requireContext()),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              message,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    ),
    duration: Duration(seconds: 5),
  ));
}

displayRemovedFromFavoriteSnackbar(String message) {
  ScaffoldMessenger.of(requireContext()).clearSnackBars();

  ScaffoldMessenger.of(requireContext()).showSnackBar(SnackBar(
    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
    behavior: SnackBarBehavior.floating,
    content: Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            AntDesign.hearto,
            color: AppTheme.secondaryColor(requireContext()),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              message,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    ),
    duration: Duration(seconds: 5),
  ));
}

displayPhotoLimiteSnackbar(String message) {
  ScaffoldMessenger.of(requireContext()).clearSnackBars();
  ScaffoldMessenger.of(requireContext()).showSnackBar(SnackBar(
    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
    behavior: SnackBarBehavior.floating,
    content: LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              MaterialCommunityIcons.camera_plus,
              color: AppTheme.secondaryColor(requireContext()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: constraints.maxWidth - 50,
                child: Text(
                  message,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      );
    }),
    duration: Duration(seconds: 5),
  ));
}

displayProfileEditSnackbar(String message) {
  ScaffoldMessenger.of(requireContext()).clearSnackBars();
  ScaffoldMessenger.of(requireContext()).showSnackBar(SnackBar(
    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
    behavior: SnackBarBehavior.floating,
    content: LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Ionicons.person,
              color: AppTheme.primaryColor(requireContext()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: constraints.maxWidth - 50,
                child: Text(
                  message,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      );
    }),
    duration: Duration(seconds: 5),
  ));
}
