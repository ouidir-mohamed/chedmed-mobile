import 'package:chedmed/models/annonce.dart';
import 'package:chedmed/ressources/shared_preference/shared_preference.dart';
import 'package:chedmed/utils/time_formatter.dart';

class AnnoncePresentation {
  int id;
  String titre;
  int prix;
  String description;
  String phone;

  String localisation;
  String time;
  List<String> images;
  int nbFavorite;
  bool favorite;
  String username;
  int userId;
  AnnoncePresentation({
    required this.id,
    required this.titre,
    required this.prix,
    required this.description,
    required this.phone,
    required this.localisation,
    required this.time,
    required this.images,
    required this.nbFavorite,
    required this.favorite,
    required this.username,
    required this.userId,
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
        phone: annonce.phone,
        localisation: annonce.location.name,
        images: annonce.images,
        time: time,
        nbFavorite: annonce.nbFavorite,
        userId: annonce.user.id,
        username: annonce.user.username,
        favorite: favorite);
  }
}
