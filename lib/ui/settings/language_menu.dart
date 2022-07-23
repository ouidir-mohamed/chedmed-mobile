import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../blocs/settings_bloc.dart';
import '../../utils/language_helper.dart';

displayLanguageMenu(BuildContext context) {
  showBarModalBottomSheet(
    topControl: Container(),
    context: context,
    builder: (context) => StreamBuilder<Locale?>(
        stream: settingsBloc.getLocale,
        builder: (context, snapshot) {
          String languageCode = snapshot.hasData
              ? snapshot.data!.languageCode
              : currentLocale(context).languageCode;

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    getTranslation.choose_your_language,
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                RadioListTile(
                  value: "fr",
                  onChanged: (c) {
                    settingsBloc.setLocale(Locale(
                      "fr",
                    ));
                  },
                  groupValue: languageCode,
                  title: Text("Français"),
                  contentPadding: EdgeInsets.all(0),
                ),

                RadioListTile(
                  value: "ar",
                  onChanged: (c) {
                    settingsBloc.setLocale(Locale(
                      "ar",
                    ));
                  },
                  groupValue: languageCode,
                  title: Text("العربية"),
                  contentPadding: EdgeInsets.all(0),
                ),

                // RadioListTile(
                //   value: 3,
                //   onChanged: (c) {},
                //   groupValue: 1,
                //   title: Text("Anglais"),
                //   selected: languageCode == "en",
                //   contentPadding: EdgeInsets.all(0),
                // ),
              ],
            ),
          );
        }),
  );
}
