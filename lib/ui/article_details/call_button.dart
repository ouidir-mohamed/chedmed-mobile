import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:chedmed/ui/common/app_theme.dart';

class CallButton extends StatelessWidget {
  bool isExtended;
  String phone;
  CallButton({
    Key? key,
    required this.isExtended,
    required this.phone,
  }) : super(key: key);

  callPhone() {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      isExtended: isExtended,
      backgroundColor: AppTheme.secondaryColor(context),
      icon: Icon(Ionicons.call, color: Colors.white),
      label: Text("Contacter",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      onPressed: () {
        callPhone();
      },
    );
  }
}
