import 'package:chedmed/utils/language_helper.dart';
import 'package:flutter/material.dart';

class WhoAreWe extends StatelessWidget {
  const WhoAreWe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(getTranslation.who_are_we)),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(vertical: 60, horizontal: 30),
        child: Text(
          getTranslation.who_are_we_content,
          style: TextStyle(fontSize: 16),
        ),
      )),
    );
  }
}
