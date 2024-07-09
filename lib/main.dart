import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:xlo_mobx/my_material_app.dart';

Future<void> startParseServer() async {
  const keyApplicationId = 'P9jsCPvsvxmqSM86HGQVIkJn7JLxh4BRnhpt9ACa';
  const keyClientKey = 'dHHt2v3BdE5bAq12vRys4t4pBMXk8lidYO77vv3B';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(
    keyApplicationId,
    keyParseServerUrl,
    clientKey: keyClientKey,
    autoSendSessionId: true,
    debug: true,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await startParseServer();

  runApp(const MyMaterialApp());
}
