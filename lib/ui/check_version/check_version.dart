import 'package:chedmed/blocs/check_version_bloc.dart';
import 'package:chedmed/ui/check_version/optional_update_dialog.dart';
import 'package:chedmed/ui/check_version/required_update_dialog.dart';
import 'package:flutter/material.dart';

import '../../models/version_check.dart';
import '../common/app_theme.dart';
import '../session_check/loading_screen.dart';

class CheckVersion extends StatefulWidget {
  const CheckVersion({Key? key}) : super(key: key);

  @override
  State<CheckVersion> createState() => _CheckVersionState();
}

class _CheckVersionState extends State<CheckVersion> {
  @override
  void initState() {
    print("ddddd");
    checkVersionBloc.checkVersion();
    checkVersionBloc.getVersionCheck.listen((event) {
      print(event);
      switch (event) {
        case VersionCheck.UP_TO_DATE:
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => SessionLoadingScreen()));
          break;
        case VersionCheck.OPTIONAL:
          displayOptionalUpdateDialog(context);
          break;
        case VersionCheck.REQUIRED:
          displayRequiredUpdateDialog(context);

          break;
      }
    });
    super.initState();
  }

  show() async {
    await Future.delayed(Duration(seconds: 1));
    print("alert");
    displayRequiredUpdateDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            color: AppTheme.primaryColor(context),
          ),
        ),
      ),
    );
  }
}
