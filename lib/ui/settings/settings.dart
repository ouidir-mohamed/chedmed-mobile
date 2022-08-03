import 'package:chedmed/blocs/settings_bloc.dart';
import 'package:chedmed/ressources/shared_preference/shared_preference.dart';
import 'package:chedmed/ui/common/select_city.dart';
import 'package:chedmed/ui/settings/about.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../utils/language_helper.dart';
import '../common/app_theme.dart';
import '../common/transitions.dart';
import 'language_menu.dart';
import 'theme_menu.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: SettingsInterface()),
    );
  }
}

class SettingsInterface extends StatefulWidget {
  const SettingsInterface({Key? key}) : super(key: key);

  @override
  State<SettingsInterface> createState() => _SettingsInterfaceState();
}

class _SettingsInterfaceState extends State<SettingsInterface> {
  String themeName = getTranslation.system_default;
  String currentCity = "";
  bool notificationEnabled = SharedPreferenceData.loadNotificaionEnabled();

  @override
  void initState() {
    settingsBloc.selectedTheme.listen((event) {
      setState(() {
        switch (event.code) {
          case "light":
            themeName = getTranslation.bright;
            break;
          case "dark":
            themeName = getTranslation.dark;
            break;
          default:
            themeName = getTranslation.system_default;
            break;
        }
      });
    });
    settingsBloc.getDefaultCity.listen((event) {
      setState(() {
        currentCity = event.name;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsList(
        darkTheme: SettingsThemeData(
            settingsListBackground: AppTheme.canvasColor(context)),
        sections: [
          CustomSettingsSection(child: Header()),
          SettingsSection(
            title: Text(getTranslation.global),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.language),
                title: Text(getTranslation.language),
                value: Text(getTranslation.language_name),
                trailing: ArrowIcon(context),
                onPressed: displayLanguageMenu,
              ),
              SettingsTile.navigation(
                leading: Icon(MaterialIcons.brightness_6),
                title: Text(getTranslation.theme),
                value: Text(themeName),
                trailing: ArrowIcon(context),
                onPressed: displayThemeMenu,
              ),
              SettingsTile.switchTile(
                initialValue: notificationEnabled,
                activeSwitchColor: AppTheme.primaryColor(context),
                onToggle: (checked) {
                  SharedPreferenceData.saveNotificationEnabled(checked);
                  setState(() {
                    notificationEnabled = checked;
                  });
                },
                leading: Icon(Ionicons.notifications),
                title: Text(getTranslation.notifications),
                description: Text(getTranslation.notifications_desc),
              )
            ],
          ),
          SettingsSection(
            title: Text(getTranslation.acount),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Ionicons.location_sharp),
                title: Text(getTranslation.location),
                value: Text(currentCity),
                trailing: ArrowIcon(context),
                onPressed: (ctx) {
                  Navigator.push(
                      context,
                      SlideRightRoute(
                          widget: SelectCity(
                              citySelected: settingsBloc.setUserCity,
                              title: getTranslation.location)));
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text(getTranslation.other),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Ionicons.information_circle),
                title: Text(getTranslation.about),
                trailing: ArrowIcon(context),
                onPressed: (ctx) {
                  Navigator.push(context, SlideRightRoute(widget: About()));
                  // showAboutDialog(
                  //     context: context,
                  //     applicationName: "Sahel ",
                  //     applicationVersion: "beta 1",
                  //     useRootNavigator: true,
                  //     children: [
                  //       Text("Application de vente et achat gratuite ...."),
                  //     ]);
                },
              ),
            ],
          ),
        ]);
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.canvasColor(context),
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(getTranslation.settings,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                      color: AppTheme.textColor(context))),
            ],
          ),
        ],
      ),
    );
  }
}

Widget ArrowIcon(BuildContext context) {
  if (isDirectionRTL(context))
    return Icon(
      MaterialIcons.arrow_back_ios,
    );
  return Icon(
    MaterialIcons.arrow_forward_ios,
  );
}
