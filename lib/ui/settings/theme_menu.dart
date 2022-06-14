import 'package:chedmed/ui/common/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../blocs/settings_bloc.dart';

displayThemeMenu(BuildContext context) {
  showBarModalBottomSheet(
    topControl: Container(),
    context: context,
    builder: (context) => StreamBuilder<SelectedTheme>(
        stream: settingsBloc.selectedTheme,
        builder: (context, snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioListTile(
                  value: "default",
                  onChanged: (c) {
                    settingsBloc.useDefaultTheme();
                  },
                  groupValue: snapshot.data!.code,
                  title: Text("Selon le systéme"),
                  contentPadding: EdgeInsets.all(0),
                ),
                RadioListTile(
                  value: "light",
                  onChanged: (c) {
                    settingsBloc.forceLightTheme();
                  },
                  groupValue: snapshot.data!.code,
                  title: Text("Claire"),
                  contentPadding: EdgeInsets.all(0),
                ),
                RadioListTile(
                  value: "dark",
                  onChanged: (c) {
                    settingsBloc.forceDarkTheme();
                  },
                  groupValue: snapshot.data!.code,
                  title: Text("Sombre"),
                  contentPadding: EdgeInsets.all(0),
                ),
              ],
            ),
          );
        }),
  );
}
