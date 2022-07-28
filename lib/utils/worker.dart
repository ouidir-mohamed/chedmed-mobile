import 'package:chedmed/blocs/notifications_bloc.dart.dart';
import 'package:workmanager/workmanager.dart';

import '../ressources/dao/sahel_dao.dart';
import 'notification_helper.dart';

initWorker() async {
  await Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  await Workmanager().cancelAll();
  Workmanager().registerPeriodicTask("task5", "task5",
      frequency: Duration(minutes: 15), initialDelay: Duration(seconds: 2));
}

void callbackDispatcher() async {
  try {
    Workmanager().executeTask((task, inputData) async {
      NotificationsBloc notificationsBloc = NotificationsBloc();
      await notificationsBloc.checkRecommendationsFromIsolate();
      return Future.value(true);
    });
  } catch (e) {
    print(e);
    return Future.value(true);
  }
}
