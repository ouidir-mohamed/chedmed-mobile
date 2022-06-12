import 'package:chedmed/ui/article_details/article_details.dart';
import 'package:chedmed/ui/common/app_theme.dart';
import 'package:chedmed/ui/common/buttons.dart';
import 'package:chedmed/ui/common/no_cache.dart';
import 'package:chedmed/ui/common/transitions.dart';
import 'package:chedmed/ui/home/annonces.dart';
import 'package:chedmed/ui/profile/tab_view.dart';
import 'package:chedmed/ui/profile/user_informations.dart.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:image_picker/image_picker.dart';

import 'article_no_fav.dart';
import 'my_articles.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  List<Annonce> annonces = [];

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);
    final List<String> tabs = <String>['Tab 1', 'Tab 2'];

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              // <-- custom sticky menu bar
              floating: false,
              pinned: false,
              expandedHeight: 180,
              toolbarHeight: 80,
              collapsedHeight: 80,
              elevation: 0.0,
              leading: Container(),
              title: Header(),
              leadingWidth: 0,
              backgroundColor: AppTheme.containerColor(context),
              bottom: PreferredSize(
                  preferredSize: Size(double.infinity, 100),
                  child: UserInfos()),
            ),
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: TabViewDelegate(tabController: _tabController),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: double.maxFinite,
                child: TabBarView(
                    controller: _tabController,
                    children: [MyArticles(), Container()]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 0),
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
