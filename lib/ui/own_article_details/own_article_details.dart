import 'package:chedmed/blocs/delete_annonce_bloc.dart';
import 'package:chedmed/ui/own_article_details/action_buttons.dart';
import 'package:chedmed/ui/profile/self_annonce_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../common/app_theme.dart';
import '../common/buttons.dart';
import 'image_display.dart';

class OwnArticleDetails extends StatefulWidget {
  SelfAnnoncePresentation annonce;
  OwnArticleDetails({
    Key? key,
    required this.annonce,
  }) : super(key: key);

  @override
  State<OwnArticleDetails> createState() => _OwnArticleDetailsState();
}

class _OwnArticleDetailsState extends State<OwnArticleDetails> {
  @override
  void initState() {
    deleteAnnonceBloc.getDone.listen((event) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
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
                            ),
                            ActionButtons(
                              annonceId: widget.annonce.id,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ]),
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
  SelfAnnoncePresentation annonce;
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
              Text(
                annonce.prix.toString() + " DA",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor(context)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              "Description",
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
                      Padding(
                        padding: const EdgeInsets.only(right: 3),
                        child: Icon(
                          Ionicons.location_sharp,
                          color: AppTheme.primaryColor(context),
                          size: 20,
                        ),
                      ),
                      Text(
                        annonce.localisation,
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
                        annonce.time,
                        style: TextStyle(
                            fontSize: 15,
                            color: AppTheme.headlineColor(context)),
                      )
                    ],
                  ),
                ),
                annonce.delivery
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 3),
                              child: Icon(
                                MaterialCommunityIcons.truck_check,
                                color: AppTheme.primaryColor(context),
                                size: 22,
                              ),
                            ),
                            Text(
                              "Livraison disponible",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: AppTheme.textColor(context)),
                            )
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
