import 'package:chedmed/blocs/home_bloc.dart';
import 'package:chedmed/ui/home/add_button.dart';
import 'package:chedmed/ui/navigation/bottom_navigation.dart';
import 'package:chedmed/utils/language_helper.dart';

import 'package:flutter/material.dart';

import 'package:chedmed/ui/common/app_theme.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

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
    shrinkButton();
    homeBloc.initFilters();
    homeBloc.getALl(displayShimmer: true);
    controller.addListener(() {
      bool bottomReached =
          controller.position.pixels == controller.position.maxScrollExtent;
      if (bottomReached) homeBloc.getExtra();
      bool topReached =
          controller.position.pixels == controller.position.minScrollExtent;
      if (topReached) expandButton();
    });

    homeBloc.getScrollDown.listen((event) {
      controller.animateTo(controller.position.pixels + 120,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
    super.initState();
  }

  var _addExtended = true;
  void shrinkButton() async {
    if (!_addExtended) return;
    await Future.delayed(Duration(seconds: 5));
    if (mounted)
      setState(() {
        _addExtended = false;
      });
  }

  expandButton() {
    if (_addExtended) return;
    setState(() {
      _addExtended = true;
    });
    shrinkButton();
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
          //     child: AddButton(isExtended: _addExtended), bottom: 7, right: 5),
        ],
      ),
    ));
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(getTranslation.app_name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      )),
                  // Text(getTranslation.app_name_description,
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.normal,
                  //       color: AppTheme.headlineColor(context),
                  //       fontSize: 16,
                  //     )),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                navigationController.jumpToTab(1);
              },
              child: Icon(
                FontAwesome.plus_square_o,
                color: AppTheme.textColor(context),
                size: 33,
              ),
            )
          ],
        ),
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
