import 'package:chedmed/ui/common/app_theme.dart';
import 'package:chedmed/ui/common/ripple_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

class CustomChip extends StatelessWidget {
  CustomChip(
      {required this.text,
      required this.onPressed,
      required this.isSelected,
      this.icon,
      Key? key})
      : super(key: key);
  final String text;
  IconData? icon;
  final Function onPressed;

  final double borderRadius = 6;
  final EdgeInsetsGeometry padding =
      const EdgeInsets.symmetric(horizontal: 10, vertical: 3);
  final EdgeInsetsGeometry margin = const EdgeInsets.symmetric(horizontal: 4);
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);
    return Container(
      margin: margin,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          splashFactory: MaterialInkSplash.splashFactory,
          padding: padding,
          backgroundColor: isSelected
              ? AppTheme.secondaryColor(context).withOpacity(0.2)
              : AppTheme.cardColor(context),
          side: BorderSide(
              color: isSelected
                  ? AppTheme.secondaryColor(context)
                  : Colors.transparent),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          primary: isSelected
              ? AppTheme.secondaryColor(context)
              : currentTheme.textTheme.bodyText1!.color!,
        ),
        onPressed: onPressed as void Function()?,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Icon(
                      icon,
                      size: 18,
                    ),
                  )
                : Container(),
            Text(text),
          ],
        ),
      ),
    );
  }
}

class MyElevatedButton extends StatelessWidget {
  const MyElevatedButton(
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
    ThemeData currentTheme = Theme.of(context);
    return ElevatedButton(
      child: child,
      style: ElevatedButton.styleFrom(
        elevation: 1,
        padding: padding,
        primary: color ?? currentTheme.primaryColor,
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
      this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
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
    return ElevatedButton(
      child: child,
      style: ElevatedButton.styleFrom(
        splashFactory: MaterialInkSplash.splashFactory,
        elevation: 0,
        padding: padding,
        shadowColor: Colors.transparent,
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
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
              // isDirectionRTL(context)
              //     ? AntDesign.arrowright
              //     :

              MaterialIcons.arrow_back_ios,
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
