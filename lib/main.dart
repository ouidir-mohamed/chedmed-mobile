import 'dart:io';

import 'package:chedmed/blocs/location_helper.dart';
import 'package:chedmed/blocs/locations_bloc.dart';
import 'package:chedmed/blocs/settings_bloc.dart';
import 'package:chedmed/models/notifications_request.dart';
import 'package:chedmed/ressources/dao/sahel_dao.dart';
import 'package:chedmed/ressources/repository/repository.dart';
import 'package:chedmed/ressources/shared_preference/shared_preference.dart';
import 'package:chedmed/ui/check_version/check_version.dart';
import 'package:chedmed/ui/common/app_theme.dart';
import 'package:chedmed/ui/common/ripple_effect.dart';
import 'package:chedmed/ui/getting_started/getting_started.dart';
import 'package:chedmed/ui/home/home.dart';
import 'package:chedmed/ui/session_check/loading_screen.dart';
import 'package:chedmed/utils/notification_helper.dart';
import 'package:chedmed/utils/worker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:workmanager/workmanager.dart';
import 'package:logger/logger.dart';
import 'ui/navigation/bottom_navigation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  // make the launcher appear for 1 more second :)
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  await handleAppStartup();
  initWorker();
  await initDatabaseInstance();
  initSahelApi();
  await Future.delayed(Duration(seconds: 1));

  HttpOverrides.global = new MyHttpOverrides();
  await SharedPreferenceData.init();
  await initPackageInfo();
  locationsBloc.loadCties();

  runApp(const MyApp());
}

// const primary = Color(0xff5458f7);

// const secondary = Color(0xfff7547b);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SelectedTheme>(
        stream: settingsBloc.selectedTheme,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          return StreamBuilder<Locale?>(
              stream: settingsBloc.getLocale,
              builder: (context, localeSnapshot) {
                return MaterialApp(
                    navigatorKey: navigatorKey,
                    title: 'Flutter Demo',
                    theme: snapshot.data!.lightTheme,
                    darkTheme: snapshot.data!.darkTheme,
                    locale: localeSnapshot.data,
                    localizationsDelegates: [
                      AppLocalizations.delegate, // Add this line
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: AppLocalizations.supportedLocales,
                    home: CheckVersion());
              });
        });
  }
}

late PackageInfo packageInfo;
initPackageInfo() async {
  packageInfo = await PackageInfo.fromPlatform();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
requireContext() {
  return navigatorKey.currentContext!;
}
