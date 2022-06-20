import 'dart:io';

import 'package:chedmed/utils/language_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:image_picker/image_picker.dart';

import 'package:chedmed/blocs/profile_bloc.dart';
import 'package:chedmed/blocs/visitor_profile_bloc.dart';
import 'package:chedmed/models/profile.dart';
import 'package:chedmed/ui/common/app_theme.dart';
import 'package:chedmed/ui/common/buttons.dart';
import 'package:chedmed/ui/profile/edit_dialog.dart';
import 'package:shimmer/shimmer.dart';

class UserInfos extends StatefulWidget {
  int userId;
  UserInfos({
    Key? key,
    required this.userId,
  }) : super(key: key);
  @override
  State<UserInfos> createState() => _UserInfosState();
}

class _UserInfosState extends State<UserInfos> {
  UserProfile profile = UserProfile(
      id: 0, username: "", phone: "", nbFavorite: 0, nbPost: 0, nbViews: 0);

  bool loading = true;

  @override
  void initState() {
    visitorProfileBloc.loadProfile(widget.userId, false);
    visitorProfileBloc.getProfile.listen((event) {
      if (mounted)
        setState(() {
          profile = event;
        });
    });

    visitorProfileBloc.getProfileLoading.listen((event) {
      if (mounted)
        setState(() {
          loading = event;
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.containerColor(context),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Column(
        children: [
          loading ? _Loading() : _UserInfoHasData(),
          Container(
            padding: EdgeInsets.symmetric(vertical: 15),
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

  Widget _UserInfoHasData() {
    return Row(
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
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              Text(profile.phone,
                  style: TextStyle(
                      fontSize: 15, color: AppTheme.headlineColor(context))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _Loading() {
    var brightness = Theme.of(context).brightness;
    Color baseColor;
    Color highlightColor;
    if (brightness == Brightness.light) {
      baseColor = Colors.white;
      highlightColor = Colors.grey[200]!;
    } else {
      baseColor = Color(0xFF1D1D1D);
      highlightColor = Color(0XFF3C4042);
    }
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          period: Duration(milliseconds: 700),
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99),
                color: AppTheme.canvasColor(context)),
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
              Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                period: Duration(milliseconds: 700),
                child: Container(
                  height: 15,
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: AppTheme.canvasColor(context)),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 3)),
              Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                period: Duration(milliseconds: 700),
                child: Container(
                  height: 15,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: AppTheme.canvasColor(context)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
