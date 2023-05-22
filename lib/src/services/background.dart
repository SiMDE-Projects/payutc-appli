import 'dart:io';

import 'package:payutc/src/services/app.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    //connecter et mettre à jour les données
    try {
      await AppService.instance.initApp();
      return true;
    } catch (e) {
      return false;
    }
  });
}

void initWorkManager() {
  if (Platform.isAndroid) {
    Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
    Workmanager().registerPeriodicTask(
      "amount-refresh-widget",
      "simplePeriodicTask",
      frequency: const Duration(hours: 1),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }
}
