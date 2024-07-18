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

import '../../components/custom_drawer/custom_drawer.dart';
import '../account/account_screen.dart';
import '../chat/chat_screen.dart';
import '../favorites/favorites_screen.dart';
import '../home/home_screen.dart';
import '../advertisement/advert_screen.dart';
import 'base_controller.dart';
import 'base_state.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  static const routeName = '/';

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final controller = BaseController();

  @override
  void initState() {
    super.initState();
    controller.init();
  }

  void _changeToPage(int page) {
    controller.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: controller.titleNotifier,
          builder: (context, value, _) {
            return Text(value);
          },
        ),
        centerTitle: true,
        elevation: 5,
        actions: [
          IconButton(
            onPressed: controller.app.toggleBrightnessMode,
            icon: ValueListenableBuilder(
                valueListenable: controller.app.brightness,
                builder: (context, value, _) {
                  return Icon(
                    controller.app.isDark ? Icons.light_mode : Icons.dark_mode,
                  );
                }),
          ),
        ],
      ),
      drawer: CustomDrawer(
          colorScheme: colorScheme,
          pageController: controller.pageController,
          changeToPage: _changeToPage),
      body: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            return Stack(
              children: [
                Positioned.fill(
                  child: PageView(
                    controller: controller.pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      HomeScreen(),
                      AdvertScreen(),
                      ChatScreen(),
                      FavoritesScreen(),
                      AccountScreen(),
                    ],
                  ),
                ),
                if (controller.state is BaseStateLoading)
                  const Positioned.fill(
                    child: CircularProgressIndicator(),
                  ),
              ],
            );
          }),
    );
  }
}
