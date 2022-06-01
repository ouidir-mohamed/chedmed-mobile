import 'package:chedmed/ui/article_details/article_details.dart';
import 'package:chedmed/ui/common/transitions.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../common/app_theme.dart';
import '../common/no_cache.dart';

class Articles extends StatelessWidget {
  Articles({Key? key}) : super(key: key);
  var faker = new Faker();

  @override
  Widget build(BuildContext context) {
    List<Annonce> annonces = [];
    for (var item in [
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      11,
      1,
      1,
      1
    ]) {
      annonces.add(Annonce(
          titre: faker.vehicle.model(),
          prix: faker.randomGenerator.integer(12000).toString() + " DA",
          localisation: faker.address.city(),
          image: faker.image.image(
              keywords: ["clothes", "laptop", "shoes", "car", "watch"])));
    }

    annonces.forEach((element) {
      print(element.image);
    });

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        children: annonces
            .map((e) => ArticleCard(
                  annonce: e,
                ))
            .toList(),
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  Annonce annonce;
  ArticleCard({
    Key? key,
    required this.annonce,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor(context),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context, SlideRightRoute(widget: ArticleDetails()));
            },
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8)),
                    child: NonCacheNetworkImage(
                      annonce.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  height: 100,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            annonce.titre,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Text(
                              annonce.prix,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppTheme.primaryColor(context)),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        annonce.localisation,
                        style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.headlineColor(context)),
                      )
                    ],
                  ),
                )),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(
                    AntDesign.heart,
                    size: 20,
                    color: AppTheme.secondaryColor(context),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Annonce {
  String titre;
  String prix;
  String localisation;
  String image;
  Annonce({
    required this.titre,
    required this.prix,
    required this.localisation,
    required this.image,
  });
}
