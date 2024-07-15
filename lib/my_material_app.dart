// Copyright (C) 2024 rudson
//
// This file is part of xlo_mobx.
//
// xlo_mobx is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// xlo_mobx is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xlo_mobx.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';

import 'common/singletons/app_settings.dart';
import 'common/theme/theme.dart';
import 'common/theme/util.dart';
import 'features/account/account_screen.dart';
import 'features/address/address_screen.dart';
import 'features/base/base_screen.dart';
import 'features/mecanics/mecanics_screen.dart';
import 'features/chat/chat_screen.dart';
import 'features/home/home_screen.dart';
import 'features/advertisement/advertisement_screen.dart';
import 'features/login/login_screen.dart';
import 'features/signup/signup_screen.dart';

class MyMaterialApp extends StatefulWidget {
  const MyMaterialApp({super.key});

  @override
  State<MyMaterialApp> createState() => _MyMaterialAppState();
}

class _MyMaterialAppState extends State<MyMaterialApp> {
  final app = AppSettings.instance;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Nunito Sans", "Poppins");
    MaterialTheme theme = MaterialTheme(textTheme);

    return ValueListenableBuilder(
        valueListenable: app.brightness,
        builder: (context, value, _) {
          return MaterialApp(
            theme: value == Brightness.light ? theme.light() : theme.dark(),
            debugShowCheckedModeBanner: false,
            initialRoute: BaseScreen.routeName,
            routes: {
              BaseScreen.routeName: (_) => const BaseScreen(),
              HomeScreen.routeName: (_) => const HomeScreen(),
              AdvertisementScreen.routeName: (_) => const AdvertisementScreen(),
              ChatScreen.routeName: (_) => const ChatScreen(),
              AccountScreen.routeName: (_) => const AccountScreen(),
              LoginScreen.routeName: (_) => const LoginScreen(),
              SignUpScreen.routeName: (_) => const SignUpScreen(),
              AddressScreen.routeName: (_) => const AddressScreen(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == MecanicsScreen.routeName) {
                return MaterialPageRoute(builder: (context) {
                  final args = settings.arguments as Map<String, dynamic>;
                  final callBack =
                      args['callBack'] as void Function(List<String> ids);
                  final selectedIds = args['selectedIds'] as List<String>;

                  return MecanicsScreen(
                    selectedIds: selectedIds,
                    callBack: callBack,
                  );
                });
              }
              return null;
            },
          );
        });
  }
}
