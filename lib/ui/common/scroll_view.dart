import 'package:flutter/material.dart';

class FullHeightScrollView extends StatelessWidget {
  final Widget child;

  const FullHeightScrollView({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return new SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: new ConstrainedBox(
          constraints: constraints.copyWith(
              minHeight: constraints.maxHeight, maxHeight: double.infinity),
          child: child,
        ),
      );
    });
  }
}
