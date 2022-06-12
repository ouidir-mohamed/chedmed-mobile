import 'package:chedmed/ui/common/ripple_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import 'app_theme.dart';

class ChipModel {
  String title;
  IconData? icon;
  Function onPressed;
  ChipModel({
    required this.title,
    this.icon,
    required this.onPressed,
  });
}

class DynamicChipView extends StatefulWidget {
  String title;
  List<ChipModel> chips;

  DynamicChipView({
    Key? key,
    required this.chips,
    required this.title,
  }) : super(key: key);

  @override
  State<DynamicChipView> createState() => DynamicChipViewState();
}

class DynamicChipViewState extends State<DynamicChipView> {
  List<Widget> children = [];
  bool isExpanded = false;
  int selectedElement = 0;
  ScrollController controller = ScrollController();
  @override
  void initState() {
    refreshChildren();
  }

  refreshChildren() {
    children.clear();
    widget.chips.asMap().forEach((index, element) {
      children.add(CustomChip(
          text: element.title,
          icon: element.icon,
          onPressed: () {
            element.onPressed();
            if (selectedElement < index) {
              slideForward();
            }
            if (selectedElement > index) {
              slideBackward();
            }
            setState(() {
              selectedElement = index;
            });
          },
          isSelected: index == selectedElement));
    });
  }

  slideForward() {
    if (isExpanded) return;
    controller.animateTo(controller.offset + 100,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  slideBackward() {
    if (isExpanded) return;

    controller.animateTo(controller.offset - 100,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  restore() {
    setState(() {
      selectedElement = 0;
      slideBackward();
    });
  }

  selectItem(int itemIndex) {
    setState(() {
      selectedElement = itemIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    refreshChildren();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              InkWell(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                  print(isExpanded);
                },
                child: Icon(isExpanded
                    ? MaterialCommunityIcons.dots_horizontal
                    : Entypo.list),
              )
            ],
          ),
        ),
        AnimatedSize(
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
          child: Container(
            width: double.infinity,
            child: isExpanded
                ? Container(
                    child: Wrap(children: children),
                  )
                : SingleChildScrollView(
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    child: Row(children: children)),
          ),
        )
      ],
    );
  }
}

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
