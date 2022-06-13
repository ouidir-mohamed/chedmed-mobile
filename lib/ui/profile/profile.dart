import 'package:chedmed/blocs/profile_bloc.dart';
import 'package:chedmed/ui/article_details/article_details.dart';
import 'package:chedmed/ui/common/app_theme.dart';
import 'package:chedmed/ui/common/buttons.dart';
import 'package:chedmed/ui/common/chips.dart';
import 'package:chedmed/ui/common/no_cache.dart';
import 'package:chedmed/ui/common/transitions.dart';
import 'package:chedmed/ui/home/annonces.dart';
import 'package:chedmed/ui/profile/articles_to_display.dart';
import 'package:chedmed/ui/profile/user_informations.dart.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:image_picker/image_picker.dart';

import 'filter.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  @override
  void initState() {
    profileBloc.loadProfileAnnonces();
    profileBloc.loadFavoriteAnnonces();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.secondaryColor(context),
          onRefresh: profileBloc.refresh,
          child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                  expandedHeight: 260,
                  floating: false,
                  pinned: true,
                  elevation: 0,
                  collapsedHeight: 75,
                  toolbarHeight: 1,
                  shadowColor: Colors.transparent,
                  primary: false,
                  leading: Container(),
                  backgroundColor: Colors.transparent,
                  flexibleSpace: LayoutBuilder(builder: (context, constraints) {
                    return FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        expandedTitleScale: 1,
                        centerTitle: true,
                        titlePadding: EdgeInsets.all(0),
                        background: Column(
                          children: [Header(), UserInfos()],
                        ),
                        title: Container(
                          child: Filters(),
                        ));
                  })),
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  primary: false,
                  child: Container(
                    child: Column(
                      children: [
                        ArticlestoDisplay(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
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
              Text("Mon profile",
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
