import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import 'package:chedmed/models/annonce.dart';
import 'package:chedmed/ressources/shared_preference/shared_preference.dart';
import 'package:chedmed/utils/language_helper.dart';
import 'package:chedmed/utils/time_formatter.dart';

class AnnoncePresentation {
  int id;
  String titre;
  String prix;
  String description;
  String phone;
  bool delivery;
  String localisation;
  String time;
  List<String> images;

  String nbFavorite;
  bool favorite;
  String username;
  int userId;
  String vues;
  LatLng geoLocation;
  String locationName;
  AnnoncePresentation({
    required this.id,
    required this.titre,
    required this.prix,
    required this.description,
    required this.phone,
    required this.delivery,
    required this.localisation,
    required this.time,
    required this.images,
    required this.nbFavorite,
    required this.favorite,
    required this.username,
    required this.userId,
    required this.vues,
    required this.geoLocation,
    required this.locationName,
  });

  static AnnoncePresentation toAnnoncePresentation(Annonce annonce) {
    String time = "";
    var annonceDateTime = annonce.createdAt.toDateTime();
    time = annonceDateTime.timePassedString();

    bool favorite =
        SharedPreferenceData.loadFavoriteAnnonces().contains(annonce.id);
    String localisation = annonce.location.name;
    if (annonce.distance != null) {
      localisation +=
          getTranslation.km_var_brackets(annonce.distance!.round().toString());
    }

    return AnnoncePresentation(
        id: annonce.id,
        titre: annonce.title,
        prix: moneyFormatting(annonce.price),
        description: annonce.description,
        phone: annonce.phone,
        localisation: localisation,
        images: annonce.images,
        time: time,
        nbFavorite: numberToText(annonce.nbFavorite),
        userId: annonce.user.id,
        username: annonce.user.username,
        delivery: annonce.delivry,
        vues: numberToText(annonce.vues),
        favorite: favorite,
        geoLocation: LatLng(annonce.location.lat, annonce.location.long),
        locationName: annonce.location.name);
  }

  static String numberToText(int number) {
    if (number < 1000) return number.toString();
    if (number < 1000000) return (number ~/ 1000).toString() + " k";
    return (number ~/ 1000000).toString() + " m";
  }

  static String moneyFormatting(int price) {
    String output = "";
    price
        .toString()
        .split("")
        .reversed
        .toList()
        .asMap()
        .forEach((index, value) {
      if (index % 3 == 0 && index > 0) output += " ";
      output += value;
    });

    return output.split("").reversed.toList().join();
  }

  static String getMiniImage(String path) {
    var splitted = path.split(".");
    splitted[splitted.length - 2] += "--mini";
    return splitted.join(".");
  }
}
