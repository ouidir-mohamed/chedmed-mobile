import 'package:chedmed/main.dart';
import 'package:chedmed/models/version_check.dart';
import 'package:chedmed/ressources/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class CheckVersionBloc {
  PublishSubject<VersionCheck> _versionCheckFetcher =
      PublishSubject<VersionCheck>();
  Stream<VersionCheck> get getVersionCheck => _versionCheckFetcher.stream;

  checkVersion() async {
    int buildNumber = int.parse(packageInfo.buildNumber);
    //buildNumber = 5;
    chedMedApi
        .versionCheck(VersionCheckRequest(buildNumber: buildNumber))
        .then((value) {
      print(value);
      _versionCheckFetcher.sink.add(value.getVersionCheck());
    }).catchError((e) {
      print(e);
    });
  }
}

final CheckVersionBloc checkVersionBloc = CheckVersionBloc();
