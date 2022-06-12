import 'package:chedmed/blocs/loading_ressources_bloc.dart';
import 'package:chedmed/ui/common/app_theme.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool loading = true;
  @override
  void initState() {
    loadingRessourcesBloc.loadCategories();
    loadingRessourcesBloc.getLoading.listen((event) {
      setState(() {
        loading = event;
      });
    });
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
            color: AppTheme.secondaryColor(context),
          ),
        ),
      ),
    );
  }
}
