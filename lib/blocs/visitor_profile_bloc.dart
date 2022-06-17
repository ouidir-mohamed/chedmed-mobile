import 'package:chedmed/models/favorite_request.dart';
import 'package:chedmed/models/profile.dart';
import 'package:chedmed/ressources/repository/repository.dart';
import 'package:chedmed/ressources/shared_preference/shared_preference.dart';
import 'package:chedmed/ui/home/annonce_presentation.dart';
import 'package:chedmed/ui/profile/profile.dart';
import 'package:chedmed/ui/profile/self_annonce_presentation.dart';
import 'package:rxdart/rxdart.dart';

class VisitorProfileBloc {
  PublishSubject<UserProfile> _profileFetcher = PublishSubject<UserProfile>();

  PublishSubject<List<AnnoncePresentation>> _annoncesFetcher =
      PublishSubject<List<AnnoncePresentation>>();

  PublishSubject<bool> _profileLoadingFetcher = PublishSubject<bool>();
  PublishSubject<bool> _annoncesLoadingFetcher = PublishSubject<bool>();

  Stream<UserProfile> get getProfile => _profileFetcher.stream;
  Stream<List<AnnoncePresentation>> get getAnnonces => _annoncesFetcher.stream;

  Stream<bool> get getProfileLoading => _profileLoadingFetcher.stream;
  Stream<bool> get getAnnoncesLoading => _annoncesLoadingFetcher.stream;

  Future<void> loadProfile(int userId, bool refresh) async {
    if (!refresh) _profileLoadingFetcher.sink.add(true);
    await chedMedApi.userPublicInfo(userId).then((value) {
      _profileFetcher.sink.add(value);
    }).whenComplete(() {
      _profileLoadingFetcher.sink.add(false);
    });
  }

  loadProfileAnnonces(int userId, bool refresh) async {
    _annoncesLoadingFetcher.sink.add(true);

    chedMedApi
        .userPostsById(userId)
        .then((value) => _annoncesFetcher.sink.add(value
            .map((e) => AnnoncePresentation.toAnnoncePresentation(e))
            .toList()))
        .whenComplete(() {
      _annoncesLoadingFetcher.sink.add(false);
    });
  }

  Future<void> refresh(int userId) async {
    loadProfile(userId, true);
    await loadProfileAnnonces(userId, true);
  }
}

VisitorProfileBloc visitorProfileBloc = VisitorProfileBloc();
