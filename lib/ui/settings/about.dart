import 'package:chedmed/ui/settings/settings.dart';
import 'package:chedmed/ui/settings/who_are_we.dart';
import 'package:chedmed/utils/language_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../common/transitions.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslation.about),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [AppLogo(), SocialMedia(context)],
        ),
      ),
    );
  }
}

Widget AppLogo() => Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 120,
            child: Image.asset("./assets/splash_dark.png"),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              getTranslation.version + " " + packageInfo.version,
              style: TextStyle(fontSize: 17),
            ),
          )
        ],
      ),
    );

Widget SocialMedia(BuildContext context) => Column(
      children: [
        SocialMediaItem(
            title: getTranslation.follow_sahel,
            icon: AntDesign.instagram,
            onTap: () {
              _launchSocial('https://www.instagram.com/sahel.app.officielle/',
                  'https://www.instagram.com/sahel.app.officielle/');
            }),
        Divider(thickness: 1, height: 1, indent: 80, endIndent: 20),
        SocialMediaItem(
            title: getTranslation.like_sahel,
            icon: AntDesign.facebook_square,
            onTap: () {
              _launchSocial('fb://page/110682678382501',
                  'https://www.facebook.com/Sahel-110682678382501');
            }),
        Divider(thickness: 1, height: 1, indent: 80, endIndent: 20),
        SocialMediaItem(
            title: getTranslation.contact_us,
            icon: AntDesign.mail,
            onTap: () {
              launchUrl(Uri.parse("mailto:sahel.app.officielle@gmail.com"));
            }),
        Divider(thickness: 1, height: 1, indent: 80, endIndent: 20),
        SocialMediaItem(
            title: getTranslation.who_are_we,
            icon: Ionicons.md_information_circle,
            onTap: () {
              Navigator.push(context, SlideRightRoute(widget: WhoAreWe()));
            }),
        Divider(thickness: 1, height: 1, indent: 80, endIndent: 20),
        SocialMediaItem(
            title: getTranslation.licences,
            icon: Octicons.law,
            onTap: () {
              showLicensePage(
                  context: context, applicationName: getTranslation.app_name);
            }),
      ],
    );

SocialMediaItem(
        {required String title,
        required IconData icon,
        Widget? trailing,
        void Function()? onTap}) =>
    ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 3),
      trailing: trailing,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      onTap: onTap,
      leading: Icon(icon, size: 26),
    );

void _launchSocial(String url, String fallbackUrl) async {
  try {
    bool launched =
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    if (!launched) {
      await launchUrl(Uri.parse(url));
    }
  } catch (e) {
    await launchUrl(Uri.parse(url));
  }
}
