import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../common/app_theme.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppTheme.canvasColor(context),
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              //width: double.infinity,
              child: TextFormField(
                //controller: departureAdressController,
                //readOnly: true,
                //  cursorColor: Colors.white,
                // focusNode: startFocusNode,

                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppTheme.textColor(context),
                    ),
                    hintText: "Recherche ici",
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    fillColor: AppTheme.cardColor(context),
                    filled: true),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.cardColor(context),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              margin: EdgeInsets.only(left: 10),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    height: 48,
                    padding: EdgeInsets.symmetric(horizontal: 13),
                    child: Icon(
                      Entypo.sound_mix,
                      color: AppTheme.textColor(context),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
