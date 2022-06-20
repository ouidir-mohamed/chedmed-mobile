import 'package:chedmed/blocs/profile_bloc.dart';
import 'package:chedmed/main.dart';
import 'package:chedmed/ressources/repository/repository.dart';
import 'package:chedmed/utils/language_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import '../ui/common/snackbar.dart';

class DeleteAnnonceBloc {
  PublishSubject<void> _doneFetcher = PublishSubject<void>();
  Stream<void> get getDone => _doneFetcher.stream;

  deleteAnnonce(int annonceId) {
    chedMedApi.deletePost(annonceId).then((value) {
      _doneFetcher.sink.add(null);
      displaySuccessSnackbar(getTranslation.post_deleted);

      profileBloc.loadProfileAnnonces();
    }).onError((error, stackTrace) {
      print(error);
    });
  }
}

DeleteAnnonceBloc deleteAnnonceBloc = DeleteAnnonceBloc();
