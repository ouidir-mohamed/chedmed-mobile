import 'package:chedmed/blocs/article_details_bloc.dart';
import 'package:chedmed/utils/language_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:latlong2/latlong.dart';
import 'package:like_button/like_button.dart';

import 'package:chedmed/ui/article_details/call_button.dart';
import 'package:chedmed/ui/home/annonce_presentation.dart';
import 'package:chedmed/ui/visitor_profile/visitor_profile.dart';

import '../../blocs/home_bloc.dart';
import '../common/app_theme.dart';
import '../common/buttons.dart';
import '../common/no_cache.dart';
import '../common/transitions.dart';
import 'image_display.dart';
import 'map_view.dart';

class ArticleDetails extends StatefulWidget {
  AnnoncePresentation annonce;
  ArticleDetails({
    Key? key,
    required this.annonce,
  }) : super(key: key);

  @override
  State<ArticleDetails> createState() => _ArticleDetailsState();
}

class _ArticleDetailsState extends State<ArticleDetails> {
  var _callExtended = true;
  void shrinkButton() async {
    if (!_callExtended) return;
    await Future.delayed(Duration(seconds: 5));
    if (mounted)
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
    articledetailsBloc.loadAnnonce(widget.annonce.id);
    articledetailsBloc.getAnnonce.listen((event) {
      if (mounted) {
        // **** keeping last distance ****/
        String lastLocation = widget.annonce.localisation;
        String lastLocationWithWilaya = widget.annonce.localisationWithWilaya;

        //*** updating with new data */
        widget.annonce = event;
        //** putting back the old distance */
        widget.annonce.localisation = lastLocation;
        widget.annonce.localisationWithWilaya = lastLocationWithWilaya;

        /** rendering :) */

        setState(() {});
      }
    });
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
                          background: ImageDisplay(
                            images: widget.annonce.images,
                          ),
                        );
                      })),
                  SliverToBoxAdapter(
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      primary: false,
                      child: Container(
                        child: Column(
                          children: [
                            ArticleContent(
                              annonce: widget.annonce,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ]),
            Positioned(
                child: CallButton(
                    isExtended: _callExtended, phone: widget.annonce.phone),
                bottom: 7,
                right: 5),
            isDirectionRTL(context)
                ? Positioned(
                    child: ReturnButton(),
                    top: 5,
                    right: 5,
                  )
                : Positioned(
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

class ArticleContent extends StatelessWidget {
  AnnoncePresentation annonce;
  ArticleContent({
    Key? key,
    required this.annonce,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      annonce.titre,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Icon(
                            AntDesign.heart,
                            color: AppTheme.headlineColor(context),
                            size: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(annonce.nbFavorite.toString()),
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                          Icon(
                            AntDesign.eye,
                            color: AppTheme.headlineColor(context),
                            size: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(annonce.vues.toString()),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      annonce.prix.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppTheme.primaryColor(context)),
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                  Text(
                    getTranslation.curreny,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppTheme.primaryColor(context)),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              getTranslation.description,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            annonce.description,
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
                      Icon(
                        Ionicons.md_time_sharp,
                        color: AppTheme.primaryColor(context),
                        size: 20,
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
                      Text(
                        annonce.time,
                        style: TextStyle(
                            fontSize: 15,
                            color: AppTheme.headlineColor(context)),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    showMapBottomSheet(
                        context, annonce.geoLocation, annonce.locationName);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Icon(
                          Ionicons.location_sharp,
                          color: AppTheme.primaryColor(context),
                          size: 20,
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
                        Expanded(
                          child: Text(
                            annonce.localisationWithWilaya,
                            style: TextStyle(
                                fontSize: 15,
                                color: AppTheme.headlineColor(context)),
                          ),
                        ),
                        Icon(Icons.map, color: AppTheme.primaryColor(context))
                      ],
                    ),
                  ),
                ),
                annonce.delivery
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            Icon(
                              MaterialCommunityIcons.truck_check,
                              color: AppTheme.primaryColor(context),
                              size: 22,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3)),
                            Text(
                              getTranslation.delivery_available,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: AppTheme.textColor(context)),
                            )
                          ],
                        ),
                      )
                    : Container(),
                Author(name: annonce.username, id: annonce.userId)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Author extends StatelessWidget {
  String name;
  int id;
  Author({
    Key? key,
    required this.name,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60, bottom: 5),
            child: Text(
              getTranslation.seller,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  SlideBottomRoute(
                      widget: VisitorProfile(
                    userId: id,
                  )));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                        color: // AppTheme.headlineColor(context).withOpacity(0.2)
                            AppTheme.primaryColor(context)),
                    child: Text(
                      name.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppTheme.containerColor(context)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      name,
                      style: TextStyle(
                          fontSize: 15, color: AppTheme.textColor(context)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
