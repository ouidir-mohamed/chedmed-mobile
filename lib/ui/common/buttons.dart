import 'package:chedmed/ui/common/app_theme.dart';
import 'package:chedmed/ui/common/ripple_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../../utils/language_helper.dart';

class MyElevatedButtonSmall extends StatelessWidget {
  const MyElevatedButtonSmall(
      {this.child,
      this.color,
      this.onPressed,
      this.borderRadius = 6,
      this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      Key? key})
      : super(key: key);
  final Color? color;
  final Widget? child;
  final Function? onPressed;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: child,
      style: ElevatedButton.styleFrom(
        splashFactory: MaterialInkSplash.splashFactory,
        elevation: 1,
        padding: padding,
        primary: color ?? AppTheme.secondaryColor(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onPressed: onPressed as void Function()?,
      autofocus: true,
    );
  }
}

class MyElevatedButton extends StatelessWidget {
  const MyElevatedButton(
      {this.child,
      this.color,
      this.onPressed,
      this.borderRadius = 6,
      this.padding = const EdgeInsets.symmetric(horizontal: 33, vertical: 12),
      Key? key})
      : super(key: key);
  final Color? color;
  final Widget? child;
  final Function? onPressed;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: child,
      style: ElevatedButton.styleFrom(
        splashFactory: MaterialInkSplash.splashFactory,
        elevation: 0,
        padding: padding,
        primary: AppTheme.secondaryColor(context),
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onPressed: onPressed as void Function()?,
      autofocus: true,
    );
  }
}

class MyElevatedButtonWide extends StatelessWidget {
  const MyElevatedButtonWide(
      {this.child,
      this.color,
      this.onPressed,
      this.borderRadius = 6,
      this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      Key? key})
      : super(key: key);
  final Color? color;
  final Widget? child;
  final Function? onPressed;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        child: child,
        style: ElevatedButton.styleFrom(
          splashFactory: MaterialInkSplash.splashFactory,
          elevation: 0,
          padding: padding,
          shadowColor: Colors.transparent,
          textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          primary: AppTheme.secondaryColor(context),
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed as void Function()?,
        autofocus: true,
      ),
    );
  }
}

class ReturnButton extends StatelessWidget {
  bool? transparent;
  ReturnButton({Key? key, this.transparent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color cardColor = Theme.of(context).cardColor;

    Color textColor = Theme.of(context).textTheme.bodyText1!.color!;
    return Container(
      margin: EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: (transparent != null) ? Colors.transparent : cardColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          radius: 100,
          borderRadius: BorderRadius.circular(100),
          onTap: () => {Navigator.of(context).pop()},
          child: Container(
            padding: EdgeInsets.only(left: 14, right: 6, top: 10, bottom: 10),
            child: Icon(
              isDirectionRTL(context)
                  ? MaterialIcons.arrow_forward_ios
                  : MaterialIcons.arrow_back_ios,
              color: textColor,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
      ),
    );
  }
}

class MyTextButton extends StatelessWidget {
  const MyTextButton(
      {this.child,
      this.textColor,
      this.outlineColor,
      required this.onPressed,
      this.borderRadius = 6,
      this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      Key? key})
      : super(key: key);
  final Widget? child;
  final Function onPressed;
  final double borderRadius;
  final Color? outlineColor;
  final Color? textColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        splashFactory: MaterialInkSplash.splashFactory,
        padding: padding,
        textStyle:
            TextStyle(color: AppTheme.secondaryColor(context), fontSize: 15),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        primary: AppTheme.secondaryColor(context),
      ),
      onPressed: onPressed as void Function()?,
      child: child!,
    );
  }
}

class MyOutlinedButton extends StatelessWidget {
  const MyOutlinedButton(
      {this.child,
      this.textColor,
      this.outlineColor,
      required this.onPressed,
      this.borderRadius = 6,
      this.padding = const EdgeInsets.symmetric(horizontal: 33, vertical: 12),
      Key? key})
      : super(key: key);
  final Widget? child;
  final Function onPressed;
  final double borderRadius;
  final Color? outlineColor;
  final Color? textColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        splashFactory: MaterialInkSplash.splashFactory,
        padding: padding,
        textStyle: TextStyle(color: AppTheme.secondaryColor(context)),
        side: BorderSide(color: AppTheme.secondaryColor(context)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        primary: AppTheme.secondaryColor(context),
      ),
      onPressed: onPressed as void Function()?,
      child: child!,
    );
  }
}

class MyOutlinedButtonWide extends StatelessWidget {
  const MyOutlinedButtonWide(
      {this.child,
      this.textColor,
      this.outlineColor,
      required this.onPressed,
      this.borderRadius = 6,
      this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      Key? key})
      : super(key: key);
  final Widget? child;
  final Function onPressed;
  final double borderRadius;
  final Color? outlineColor;
  final Color? textColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);
    return Container(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          splashFactory: MaterialInkSplash.splashFactory,
          padding: padding,
          textStyle: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppTheme.secondaryColor(context)),
          side: BorderSide(color: AppTheme.secondaryColor(context)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          primary: AppTheme.secondaryColor(context),
        ),
        onPressed: onPressed as void Function()?,
        child: child!,
      ),
    );
  }
}
