import 'package:chedmed/blocs/notifications_bloc.dart.dart';
import 'package:workmanager/workmanager.dart';

import '../ressources/dao/sahel_dao.dart';
import 'notification_helper.dart';

initWorker() async {
  await Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  Workmanager().registerPeriodicTask("notificationtask", "notificationtask",
      frequency: Duration(hours: 1), initialDelay: Duration(hours: 1));
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
