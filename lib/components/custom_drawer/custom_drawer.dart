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

import '../../common/singletons/app_settings.dart';
import '../../features/login/login_screen.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({
    super.key,
    required this.colorScheme,
    required this.pageController,
  });

  final ColorScheme colorScheme;
  final PageController pageController;
  final app = AppSettings.instance;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: app.isDark
          ? colorScheme.primary.withOpacity(0.15)
          : colorScheme.onPrimary.withOpacity(0.85),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(35),
        bottomRight: Radius.circular(35),
      )),
      child: ListView(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, LoginScreen.routeName);
            },
            child: DrawerHeader(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: colorScheme.onPrimary,
              ),
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.person,
                      size: 50,
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Acessar sua conta agora!',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text('Click aqui!'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Anúncios'),
            selected: pageController.page == 0,
            onTap: () {
              pageController.jumpToPage(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Inserir Anúncio'),
            selected: pageController.page == 1,
            onTap: () {
              pageController.jumpToPage(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chat'),
            selected: pageController.page == 2,
            onTap: () {
              pageController.jumpToPage(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favoritos'),
            selected: pageController.page == 3,
            onTap: () {
              pageController.jumpToPage(3);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Minha Conta'),
            selected: pageController.page == 4,
            onTap: () {
              pageController.jumpToPage(4);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
