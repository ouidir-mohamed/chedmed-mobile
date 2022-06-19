import 'package:chedmed/ressources/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

import '../ui/home/annonce_presentation.dart';

class ArticledetailsBloc {
  PublishSubject<AnnoncePresentation> _annonceFetcher =
      PublishSubject<AnnoncePresentation>();

  Stream<AnnoncePresentation> get getAnnonce => _annonceFetcher.stream;

  loadAnnonce(int postId) {
    chedMedApi.getPostById(postId).then((value) => _annonceFetcher.sink
        .add(AnnoncePresentation.toAnnoncePresentation(value)));
  }
}

ArticledetailsBloc articledetailsBloc = ArticledetailsBloc();
