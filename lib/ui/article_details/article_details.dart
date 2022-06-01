import 'package:chedmed/ui/article_details/call_button.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../common/app_theme.dart';
import '../common/buttons.dart';
import '../common/no_cache.dart';
import 'image_display.dart';

class ArticleDetails extends StatefulWidget {
  ArticleDetails({Key? key}) : super(key: key);

  @override
  State<ArticleDetails> createState() => _ArticleDetailsState();
}

class _ArticleDetailsState extends State<ArticleDetails> {
  var _callExtended = true;

  void shrinkButton() async {
    if (!_callExtended) return;
    await Future.delayed(Duration(seconds: 5));
    setState(() {
      _callExtended = false;
    });
  }

  expandButton() {
    if (_callExtended) return;
    setState(() {
      _callExtended = true;
    });
    shrinkButton();
  }

  @override
  void initState() {
    shrinkButton();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            CustomScrollView(physics: RangeMaintainingScrollPhysics(),
                //scrollBehavior: MyBehavior(),
                //controller: controller,
                slivers: [
                  SliverAppBar(
                      expandedHeight: 360,
                      floating: false,
                      pinned: true,
                      elevation: 0,
                      collapsedHeight: 0,
                      toolbarHeight: 0,
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
                          background: ImageDisplay(),
                        );
                      })),
                  SliverToBoxAdapter(
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      primary: false,
                      child: Container(
                        child: Column(
                          children: [ArticleContent()],
                        ),
                      ),
                    ),
                  )
                ]),
            Positioned(
                child: CallButton(isExtended: _callExtended),
                bottom: 7,
                right: 5),
            Positioned(
              child: ReturnButton(),
              top: 5,
              left: 5,
            )
          ],
        ),
      ),
    );
  }
}

class TitleHeader extends StatelessWidget {
  const TitleHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            MaterialIcons.arrow_back_ios,
            size: 25,
          ),
          Text("Annonce titre",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          Icon(
            AntDesign.heart,
            size: 20,
            color: AppTheme.secondaryColor(context),
          ),
        ],
      ),
    );
  }
}

class ArticleContent extends StatelessWidget {
  ArticleContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            faker.vehicle.model(),
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            faker.randomGenerator.integer(12000).toString() + " DA",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor(context)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              "Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            faker.lorem.sentences(30).join("\n"),
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 3),
                        child: Icon(
                          Ionicons.location_sharp,
                          color: AppTheme.primaryColor(context),
                          size: 20,
                        ),
                      ),
                      Text(
                        faker.address.city(),
                        style: TextStyle(
                            fontSize: 15,
                            color: AppTheme.headlineColor(context)),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 3),
                        child: Icon(
                          Ionicons.md_time_sharp,
                          color: AppTheme.primaryColor(context),
                          size: 20,
                        ),
                      ),
                      Text(
                        "Il ya 2 jours",
                        style: TextStyle(
                            fontSize: 15,
                            color: AppTheme.headlineColor(context)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
