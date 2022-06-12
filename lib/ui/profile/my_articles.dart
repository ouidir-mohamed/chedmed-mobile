import 'package:chedmed/ui/home/annonces.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

import 'article_no_fav.dart';

class MyArticles extends StatelessWidget {
  MyArticles({Key? key}) : super(key: key);
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
            .map((e) => ArticleNoFav(
                  annonce: e,
                ))
            .toList(),
      ),
    );
  }
}
