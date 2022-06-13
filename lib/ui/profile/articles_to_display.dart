import 'package:chedmed/blocs/profile_bloc.dart';
import 'package:chedmed/ui/profile/favorite_annonces.dart';
import 'package:chedmed/ui/profile/self_annonces.dart';
import 'package:flutter/material.dart';

class ArticlestoDisplay extends StatefulWidget {
  const ArticlestoDisplay({Key? key}) : super(key: key);

  @override
  State<ArticlestoDisplay> createState() => _ArticlestoDisplayState();
}

class _ArticlestoDisplayState extends State<ArticlestoDisplay> {
  int tabToDisplay = 0;

  @override
  void initState() {
    profileBloc.getTab.listen((event) {
      setState(() {
        tabToDisplay = event;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return tabToDisplay == 0 ? SelfAnnonces() : FavoriteAnnonces();
  }
}
