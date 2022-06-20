import 'dart:io';

import 'package:chedmed/blocs/profile_bloc.dart';
import 'package:chedmed/models/profile.dart';
import 'package:chedmed/ui/common/app_theme.dart';
import 'package:chedmed/ui/common/buttons.dart';
import 'package:chedmed/ui/profile/edit_dialog.dart';
import 'package:chedmed/utils/language_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:image_picker/image_picker.dart';

class UserInfos extends StatefulWidget {
  @override
  State<UserInfos> createState() => _UserInfosState();
}

class _UserInfosState extends State<UserInfos> {
  UserProfile profile = UserProfile(
      id: 0, username: "", phone: "", nbFavorite: 0, nbPost: 0, nbViews: 0);

  @override
  void initState() {
    profileBloc.loadProfile();
    profileBloc.getProfile.listen((event) {
      print(event.username);
      setState(() {
        profile = event;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.containerColor(context),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        children: [
          Row(
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
                  profile.username.substring(0, 1).toUpperCase(),
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
                      profile.username,
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                    Text(profile.phone,
                        style: TextStyle(
                            fontSize: 15,
                            color: AppTheme.headlineColor(context))),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {
                    displayEditDialog(context, profile.username, profile.phone);
                  },
                  icon: Icon(FontAwesome.pencil,
                      size: 20, color: AppTheme.textColor(context)))
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      profile.nbPost.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(getTranslation.posts,
                        style: TextStyle(
                          color: AppTheme.headlineColor(context),
                        )),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      profile.nbViews.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(getTranslation.views,
                        style: TextStyle(
                          color: AppTheme.headlineColor(context),
                        )),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      profile.nbFavorite.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(getTranslation.likes,
                        style: TextStyle(
                          color: AppTheme.headlineColor(context),
                        )),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
