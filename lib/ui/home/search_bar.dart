import 'package:chedmed/blocs/home_bloc.dart';
import 'package:chedmed/ui/home/filter_dialog/filter_dialog.dart';
import 'package:chedmed/utils/language_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../add_annonce/add_annonce.dart';
import '../common/app_theme.dart';
import '../common/transitions.dart';

class SearchBar extends StatefulWidget {
  SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  FocusNode focueNode = FocusNode();
  TextEditingController searchController = TextEditingController();
  bool filterEnabled = false;

  @override
  void initState() {
    focueNode.unfocus();
    homeBloc.getFiltersEnabled.listen((event) {
      if (mounted)
        setState(() {
          filterEnabled = event;
        });
    });
    super.initState();
  }

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
                onFieldSubmitted: (v) {
                  homeBloc.setQueryAndApply(v);
                  focueNode.unfocus();
                },
                onChanged: (v) {
                  if (v.isEmpty) homeBloc.setQueryAndApply(v);
                },

                controller: searchController,
                // readOnly: true,
                // cursorColor: Colors.white,

                focusNode: focueNode,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppTheme.textColor(context),
                    ),
                    hintText: getTranslation.search_here,
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
                color: filterEnabled
                    ? AppTheme.secondaryColor(context)
                    : AppTheme.cardColor(context),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              margin: EdgeInsets.only(left: 10),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context, SlideBottomRoute(widget: FilterDialog()));
                  },
                  child: Container(
                    height: 48,
                    padding: EdgeInsets.symmetric(horizontal: 13),
                    child: Icon(
                      Entypo.sound_mix,
                      color: filterEnabled
                          ? Colors.white
                          : AppTheme.textColor(context),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
