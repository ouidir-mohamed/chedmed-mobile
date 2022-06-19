import 'package:chedmed/models/annonce.dart';
import 'package:chedmed/ressources/shared_preference/shared_preference.dart';
import 'package:chedmed/utils/time_formatter.dart';

class SelfAnnoncePresentation {
  int id;
  String titre;
  int prix;
  String description;
  String localisation;
  String time;
  String nbFavorite;
  String vues;
  bool delivery;

  List<String> images;
  SelfAnnoncePresentation({
    required this.id,
    required this.titre,
    required this.prix,
    required this.description,
    required this.localisation,
    required this.time,
    required this.nbFavorite,
    required this.vues,
    required this.delivery,
    required this.images,
  });

  static SelfAnnoncePresentation toSelfAnnoncePresentation(Annonce annonce) {
    String time = "";
    var annonceDateTime = annonce.createdAt.toDateTime();
    time = annonceDateTime.timePassedString();

    return SelfAnnoncePresentation(
      id: annonce.id,
      titre: annonce.title,
      prix: annonce.price,
      description: annonce.description,
      localisation: annonce.location.name,
      nbFavorite: numberToText(annonce.nbFavorite),
      vues: numberToText(annonce.vues),
      images: annonce.images,
      time: time,
      delivery: annonce.delivry,
    );
  }

  static String numberToText(int number) {
    if (number < 1000) return number.toString();
    if (number < 1000000) return (number ~/ 1000).toString() + " k";
    return (number ~/ 1000000).toString() + " m";
  }
}
