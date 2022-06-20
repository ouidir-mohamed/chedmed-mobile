import 'package:chedmed/blocs/home_bloc.dart';
import 'package:chedmed/utils/language_helper.dart';

import 'package:flutter/material.dart';

import 'package:chedmed/ui/common/app_theme.dart';

import 'annonces.dart';
import 'categories.dart';
import 'search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    homeBloc.initFilters();
    homeBloc.getALl(displayShimmer: true);
    controller.addListener(() {
      bool bottomReached =
          controller.position.pixels == controller.position.maxScrollExtent;
      if (bottomReached) homeBloc.getExtra();
    });

    homeBloc.getScrollDown.listen((event) {
      controller.animateTo(controller.position.pixels + 120,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          RefreshIndicator(
            color: AppTheme.primaryColor(context),
            onRefresh: homeBloc.refresh,
            child: CustomScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                //scrollBehavior: MyBehavior(),
                controller: controller,
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
                      flexibleSpace:
                          LayoutBuilder(builder: (context, constraints) {
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
                          children: [
                            Categories(),
                            ArticlesHeader(),
                            Annonces()
                          ],
                        ),
                      ),
                    ),
                  )
                ]),
          ),
          // Positioned(
          //     bottom: 8,
          //     right: 8,
          //     child: FloatingActionButton(
          //       onPressed: () {
          //         Navigator.push(
          //             context, SlideRightRoute(widget: AddAnnonce()));
          //       },
          //       child: Icon(
          //         FontAwesome.plus,
          //         color: AppTheme.cardColor(context),
          //       ),
          //     ))
        ],
      ),
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
              Text(getTranslation.app_name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  )),
            ],
          ),
          Text(getTranslation.app_name_description,
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
          Text(getTranslation.nearby_posts,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
              )),
        ],
      ),
    );
  }
}
