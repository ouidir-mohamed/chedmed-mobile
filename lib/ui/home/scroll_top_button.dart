import 'package:chedmed/utils/language_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'package:chedmed/ui/common/app_theme.dart';

import '../navigation/bottom_navigation.dart';

Widget? ScrollTopButton(
    {required bool isExtended,
    void Function()? onPressed,
    required BuildContext context}) {
  //if (!isExtended) return null;

  return FloatingActionButton(
    heroTag: "scroll-boutton",
    enableFeedback: true,
    backgroundColor: AppTheme.primaryColor(context),
    child: Icon(FontAwesome.arrow_up, color: Colors.white),
    onPressed: onPressed,
  );
}

class CustomFabLocation extends StandardFabLocation
    with FabEndOffsetX, FabFloatOffsetY {
  const CustomFabLocation();

  @override
  String toString() => 'FloatingActionButtonLocation.endFloat';
}

mixin OffsetX on StandardFabLocation {
  /// Calculates x-offset for end-aligned [FloatingActionButtonLocation]s.
  @override
  double getOffsetX(
      ScaffoldPrelayoutGeometry scaffoldGeometry, double adjustment) {
    assert(scaffoldGeometry.textDirection != null);
    switch (scaffoldGeometry.textDirection) {
      case TextDirection.rtl:
        return _leftOffsetX(scaffoldGeometry, adjustment);
      case TextDirection.ltr:
        return _rightOffsetX(scaffoldGeometry, adjustment);
    }
  }
}
mixin FabFloatOffsetY on StandardFabLocation {
  /// Calculates y-offset for [FloatingActionButtonLocation]s floating at
  /// the bottom of the screen.
  @override
  double getOffsetY(
      ScaffoldPrelayoutGeometry scaffoldGeometry, double adjustment) {
    final double contentBottom = scaffoldGeometry.contentBottom;
    final double bottomContentHeight =
        scaffoldGeometry.scaffoldSize.height - contentBottom;
    final double bottomSheetHeight = scaffoldGeometry.bottomSheetSize.height;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    final double snackBarHeight = scaffoldGeometry.snackBarSize.height;
    final double safeMargin = math.max(
      kFloatingActionButtonMargin,
      scaffoldGeometry.minViewPadding.bottom -
          bottomContentHeight +
          kFloatingActionButtonMargin,
    );

    double fabY = contentBottom - fabHeight - safeMargin;
    if (snackBarHeight > 0.0)
      fabY = math.min(
          fabY,
          contentBottom -
              snackBarHeight -
              fabHeight -
              kFloatingActionButtonMargin);
    if (bottomSheetHeight > 0.0)
      fabY =
          math.min(fabY, contentBottom - bottomSheetHeight - fabHeight / 2.0);
    return fabY + adjustment + 100;
  }
}

double _rightOffsetX(
    ScaffoldPrelayoutGeometry scaffoldGeometry, double adjustment) {
  return scaffoldGeometry.scaffoldSize.width -
      kFloatingActionButtonMargin -
      scaffoldGeometry.minInsets.right -
      scaffoldGeometry.floatingActionButtonSize.width +
      adjustment;
}

double _leftOffsetX(
    ScaffoldPrelayoutGeometry scaffoldGeometry, double adjustment) {
  return kFloatingActionButtonMargin +
      scaffoldGeometry.minInsets.left -
      adjustment;
}

class LinearMovementFabAnimator extends FloatingActionButtonAnimator {
  @override
  Offset getOffset(
      {required Offset begin, required Offset end, required double progress}) {
    return Offset.lerp(begin, end, progress)!;
  }

  @override
  Animation<double> getScaleAnimation({required Animation<double> parent}) {
    return const AlwaysStoppedAnimation<double>(1.0);
  }

  @override
  Animation<double> getRotationAnimation({required Animation<double> parent}) {
    return const AlwaysStoppedAnimation<double>(1.0);
  }
}
