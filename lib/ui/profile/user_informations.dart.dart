import 'dart:io';

import 'package:chedmed/ui/common/app_theme.dart';
import 'package:chedmed/ui/common/buttons.dart';
import 'package:chedmed/ui/profile/edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:image_picker/image_picker.dart';

class UserInfos extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.containerColor(context),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(80),
                color: // AppTheme.headlineColor(context).withOpacity(0.2)
                    AppTheme.primaryColor(context)),
            child: Text(
              "Y",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: AppTheme.containerColor(context)),
            ),
          ),
          SizedBox(
            width: 14,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Yanis Ziani',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
                Text('0656110707',
                    style: TextStyle(
                        fontSize: 15, color: AppTheme.headlineColor(context))),
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                displayEditDialog(context);
              },
              icon: Icon(FontAwesome.pencil,
                  size: 20, color: AppTheme.textColor(context)))
        ],
      ),
    );
  }
}
