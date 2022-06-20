import 'package:chedmed/blocs/loading_ressources_bloc.dart';
import 'package:chedmed/blocs/session_bloc.dart';
import 'package:chedmed/ui/common/app_theme.dart';
import 'package:flutter/material.dart';

class SessionLoadingScreen extends StatefulWidget {
  const SessionLoadingScreen({Key? key}) : super(key: key);

  @override
  State<SessionLoadingScreen> createState() => _SessionLoadingScreenState();
}

class _SessionLoadingScreenState extends State<SessionLoadingScreen> {
  SessionBloc sessionBloc = SessionBloc();
  @override
  void initState() {
    sessionBloc.checkSession();
    super.initState();
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
