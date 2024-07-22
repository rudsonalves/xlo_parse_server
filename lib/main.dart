import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

// import 'common/settings/back4app_server.dart';
import 'common/settings/local_server.dart';
import 'common/singletons/search_history.dart';
import 'manager/mechanics_manager.dart';
import 'my_material_app.dart';

Future<void> startParseServer() async {
  await Parse().initialize(
    LocalServer.keyApplicationId,
    LocalServer.keyParseServerUrl,
    clientKey: LocalServer.keyClientKey,
    autoSendSessionId: true,
    debug: true,
  );

  await MechanicsManager.instance.init();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await startParseServer();
  await SearchHistory.instance.init();

  runApp(const MyMaterialApp());
}
