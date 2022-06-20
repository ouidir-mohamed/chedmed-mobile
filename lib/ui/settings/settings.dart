import 'package:chedmed/blocs/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../utils/language_helper.dart';
import '../common/app_theme.dart';
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

  @override
  void initState() {
    settingsBloc.selectedTheme.listen((event) {
      setState(() {
        themeName = event.name;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsList(sections: [
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
      color: AppTheme.containerColor(context),
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Paramétres",
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
