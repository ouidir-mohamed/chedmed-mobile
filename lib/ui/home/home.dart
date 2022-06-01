import 'package:chedmed/ui/common/buttons.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import 'package:chedmed/ui/common/app_theme.dart';

import '../common/no_cache.dart';
import 'articles.dart';
import 'categories.dart';
import 'search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: CustomScrollView(physics: RangeMaintainingScrollPhysics(),
          //scrollBehavior: MyBehavior(),
          //controller: controller,
          slivers: [
            SliverAppBar(
                expandedHeight: 170,
                floating: false,
                pinned: true,
                elevation: 0,
                collapsedHeight: 60,
                toolbarHeight: 60,
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
                      background: Stack(
                        children: [
                          Header(),
                        ],
                      ),
                      title: SearchBar());
                })),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                primary: false,
                child: Container(
                  child: Column(
                    children: [Categories(), ArticlesHeader(), Articles()],
                  ),
                ),
              ),
            )
          ]),
    ));
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                child: Icon(MaterialCommunityIcons.storefront,
                    size: 40, color: AppTheme.primaryColor(context)),
                padding: EdgeInsets.only(right: 8),
              ),
              Text("Chedmed",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  )),
            ],
          ),
          Text("Trouver tout ce que vous voulez",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: AppTheme.headlineColor(context),
                fontSize: 16,
              )),
        ],
      ),
    );
  }
}

class ArticlesHeader extends StatelessWidget {
  const ArticlesHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Row(
        children: [
          Text("Articles a proximité",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              MaterialCommunityIcons.near_me,
              size: 28,
              color: AppTheme.primaryColor(context),
            ),
          )
        ],
      ),
    );
  }
}
