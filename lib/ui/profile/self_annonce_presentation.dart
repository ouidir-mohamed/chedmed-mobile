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
  List<String> images;
  SelfAnnoncePresentation({
    required this.id,
    required this.titre,
    required this.prix,
    required this.description,
    required this.localisation,
    required this.time,
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
      images: annonce.images,
      time: time,
    );
  }
}
