import 'package:chedmed/models/favorite_request.dart';
import 'package:chedmed/models/profile.dart';
import 'package:chedmed/models/user_request.dart';
import 'package:chedmed/ressources/repository/repository.dart';
import 'package:chedmed/ressources/shared_preference/shared_preference.dart';
import 'package:chedmed/ui/home/annonce_presentation.dart';
import 'package:chedmed/ui/profile/profile.dart';
import 'package:chedmed/ui/profile/self_annonce_presentation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../ui/common/snackbar.dart';

class ProfileBloc {
  BehaviorSubject<int> _tabFetcher = BehaviorSubject<int>();

  BehaviorSubject<UserProfile> _profileFetcher = BehaviorSubject<UserProfile>();

  BehaviorSubject<List<SelfAnnoncePresentation>> _selfAnnonceFetcher =
      BehaviorSubject<List<SelfAnnoncePresentation>>();
  BehaviorSubject<bool> _selfLoadingFetcher = BehaviorSubject<bool>();

  BehaviorSubject<List<AnnoncePresentation>> _favoriteAnnonceFetcher =
      BehaviorSubject<List<AnnoncePresentation>>();
  BehaviorSubject<bool> _favoriteLoadingFetcher = BehaviorSubject<bool>();

  PublishSubject<bool> _editLoadingFetcher = PublishSubject<bool>();
  PublishSubject<void> _editDoneFetcher = PublishSubject<void>();

  Stream<int> get getTab => _tabFetcher.stream;
  Stream<UserProfile> get getProfile =>
      _profileFetcher.stream.startWith(UserProfile(
          id: 0,
          username: SharedPreferenceData.loadUserName(),
          phone: SharedPreferenceData.loadPhone(),
          nbFavorite: 0,
          nbViews: 0,
          nbPost: 0));

  Stream<List<SelfAnnoncePresentation>> get getSelfAnnonces =>
      _selfAnnonceFetcher.stream;

  Stream<List<AnnoncePresentation>> get getFavoriteAnnonces =>
      _favoriteAnnonceFetcher.stream;

  Stream<bool> get getSelfLoading => _selfLoadingFetcher.stream;
  Stream<bool> get getFavoriteLoading => _favoriteLoadingFetcher.stream;
  Stream<bool> get getEditLoading => _editLoadingFetcher.stream;
  Stream<void> get getEditDone => _editDoneFetcher.stream;

  switchTo(int tab) {
    _tabFetcher.sink.add(tab);
  }

  Future<void> loadProfileAnnonces() async {
    if (!_selfAnnonceFetcher.hasValue) _selfLoadingFetcher.sink.add(true);
    await chedMedApi.userPosts().then((value) {
      _selfAnnonceFetcher.sink.add(value
          .map((e) => SelfAnnoncePresentation.toSelfAnnoncePresentation(e))
          .toList());
    }).whenComplete(() {
      _selfLoadingFetcher.sink.add(false);
    });
    return;
  }

  Future<void> loadFavoriteAnnonces() async {
    if (!_favoriteAnnonceFetcher.hasValue)
      _favoriteLoadingFetcher.sink.add(true);
    FavoriteRequest request =
        FavoriteRequest(postIds: SharedPreferenceData.loadFavoriteAnnonces());

    await chedMedApi.favoritePosts(request).then((value) {
      _favoriteAnnonceFetcher.sink.add(value
          .map((e) => AnnoncePresentation.toAnnoncePresentation(e))
          .toList());
    }).whenComplete(() {
      _favoriteLoadingFetcher.sink.add(false);
    });
    return;
  }

  Future<void> refresh() async {
    loadProfile();
    int currentTab = _tabFetcher.hasValue ? _tabFetcher.value : 0;
    if (currentTab == 0) return loadProfileAnnonces();
    loadFavoriteAnnonces();
  }

  loadProfile() {
    chedMedApi.userInfo().then((value) {
      _profileFetcher.sink.add(value);
    });
  }

  String username = "";
  String? nameValidator(String? value) {
    if (value == null || value.length == 0) return ("Le nom est obligatoire");
    if (value.length > 50) return ("Le nom est trés long");
    username = value;
    return null;
  }

  String phone = "";
  String? phoneValidator(String? value) {
    if (value == null || value.length == 0 || value.length > 10)
      return ("Ce numéro n'est pas valide");
    phone = value;
    return null;
  }

  editProfile() {
    if (!profileFormKey.currentState!.validate()) return;
    _validateProfile();
  }

  _validateProfile() {
    _editLoadingFetcher.sink.add(true);
    chedMedApi
        .updateUser(UserRequest(username: username, phone: phone))
        .then((value) {
      loadProfile();
      _editDoneFetcher.sink.add(null);
      displayProfileEditSnackbar("Profile modifié avec succées");
    }).whenComplete(() {
      _editLoadingFetcher.sink.add(false);
    });
    print(username + " " + phone);
  }
}

ProfileBloc profileBloc = ProfileBloc();
final profileFormKey = GlobalKey<FormState>();
