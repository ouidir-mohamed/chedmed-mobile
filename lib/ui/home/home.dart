import 'dart:math' as math;

import 'package:chedmed/blocs/home_bloc.dart';
import 'package:chedmed/ressources/shared_preference/shared_preference.dart';
import 'package:chedmed/ui/discussions/discussions.dart';
import 'package:chedmed/ui/home/scroll_top_button.dart';
import 'package:chedmed/ui/navigation/bottom_navigation.dart';
import 'package:chedmed/utils/language_helper.dart';
import 'package:chedmed/utils/notification_helper.dart';

import 'package:flutter/material.dart';

import 'package:chedmed/ui/common/app_theme.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../recommendations/recommendations.dart';
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
    checkNotificationClick();
    homeBloc.initFilters();
    homeBloc.getALl(displayShimmer: true);
    controller.addListener(() {
      bool bottomReached =
          controller.position.pixels == controller.position.maxScrollExtent;
      if (bottomReached) homeBloc.getExtra();

      bool almostTop = controller.position.pixels < 400;
      if (almostTop) hideButton();

      if (lastScrollPosition > controller.position.pixels)
        isScrollingUp();
      else
        isScrollingDown();
      lastScrollPosition = controller.position.pixels;
    });

    homeBloc.getScrollDown.listen((event) {
      controller.animateTo(controller.position.pixels + 120,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
    super.initState();
  }

  double lastScrollPosition = 0;

  var _scrollTopVisible = false;
  var _scrollTopDestroyed = true;

  isScrollingUp() {
    if (controller.position.pixels > 1000) showButton();
  }

  isScrollingDown() {
    hideButton();
  }

  goToTop() async {
    controller.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
    // await Future.delayed(Duration(milliseconds: 600));
    // hideButton();
  }

  void hideButton() async {
    if (!_scrollTopVisible || _scrollTopDestroyed) return;
    //await Future.delayed(Duration(seconds: 1));
    if (mounted)
      setState(() {
        _scrollTopVisible = false;
      });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _scrollTopDestroyed = true;
    });
  }

  showButton() async {
    print(_scrollTopVisible.toString() + " " + _scrollTopDestroyed.toString());
    if (_scrollTopVisible || !_scrollTopDestroyed) return;

    setState(() {
      _scrollTopDestroyed = false;
    });

    // await Future.delayed(Duration(milliseconds: 50));

    setState(() {
      _scrollTopVisible = true;
    });
  }

  checkNotificationClick() async {
    bool isPending = await SharedPreferenceData.loadNotificationPending();
    //displayNotification("title", isPending.toString() + " pending state");
    bool isMessagingPending =
        await SharedPreferenceData.loadNotificationMessagePending();

    if (isMessagingPending) {
      await SharedPreferenceData.saveNotificationMessagePending(false);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => DiscussionsScreen()));
      return;
    }
    if (isPending) {
      await SharedPreferenceData.saveNotificationPending(false);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Recommendations()));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: _scrollTopVisible
            ? FloatingActionButtonLocation.endFloat
            : CustomFabLocation(),
        floatingActionButtonAnimator: LinearMovementFabAnimator(),
        floatingActionButton: !_scrollTopDestroyed
            ? ScrollTopButton(
                isExtended: _scrollTopVisible,
                onPressed: () {
                  goToTop();
                },
                context: context)
            : null,
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

class ArticlesHeader extends StatefulWidget {
  const ArticlesHeader({Key? key}) : super(key: key);

  @override
  State<ArticlesHeader> createState() => _ArticlesHeaderState();
}

class _ArticlesHeaderState extends State<ArticlesHeader> {
  bool filtersEnabled = false;
  double? maxDistance = null;

  @override
  void initState() {
    homeBloc.getFiltersEnabled.listen((event) {
      setState(() {
        filtersEnabled = event;
      });
    });

    homeBloc.getMaxDistance.listen((event) {
      setState(() {
        maxDistance = event;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Row(
        children: [
          Text(
              (filtersEnabled && (maxDistance ?? 110) < 100)
                  ? getTranslation.nearby_posts
                  : getTranslation.all_posts,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
              )),
        ],
      ),
    );
  }
}
