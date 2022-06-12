import 'package:chedmed/models/annonce.dart';
import 'package:chedmed/ressources/shared_preference/shared_preference.dart';
import 'package:chedmed/utils/time_formatter.dart';

class AnnoncePresentation {
  int id;
  String titre;
  int prix;
  String description;
  String localisation;
  String time;
  List<String> images;
  bool favorite;
  AnnoncePresentation({
    required this.id,
    required this.titre,
    required this.prix,
    required this.description,
    required this.localisation,
    required this.time,
    required this.images,
    required this.favorite,
  });

  static AnnoncePresentation toAnnoncePresentation(Annonce annonce) {
    String time = "";
    var annonceDateTime = annonce.createdAt.toDateTime();
    time = annonceDateTime.timePassedString();

    bool favorite =
        SharedPreferenceData.loadFavoriteAnnonces().contains(annonce.id);

    return AnnoncePresentation(
        id: annonce.id,
        titre: annonce.title,
        prix: annonce.price,
        description: annonce.description,
        localisation: annonce.location.name,
        images: annonce.images,
        time: time,
        favorite: favorite);
  }
}
