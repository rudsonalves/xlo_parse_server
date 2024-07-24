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
import '../../common/singletons/current_user.dart';
import '../../features/login/login_screen.dart';
import '../../repository/user_repository.dart';
import 'widgets/custom_drawer_header.dart';

class CustomDrawer extends StatelessWidget {
  final ColorScheme colorScheme;
  final PageController pageController;
  final void Function(int page) changeToPage;

  CustomDrawer({
    super.key,
    required this.colorScheme,
    required this.pageController,
    required this.changeToPage,
  });

  final app = AppSettings.instance;
  final currentUSer = CurrentUser.instance;

  void _navToLoginScreen(BuildContext context) {
    if (currentUSer.isLogin) {
      Navigator.pop(context);
      changeToPage(4);
    } else {
      Navigator.pop(context);
      Navigator.pushNamed(context, LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: app.isDark
          ? colorScheme.onSecondary.withOpacity(0.85)
          : colorScheme.onPrimary.withOpacity(0.85),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(35),
        bottomRight: Radius.circular(35),
      )),
      child: ListView(
        children: [
          InkWell(
            onTap: () => _navToLoginScreen(context),
            child: const CustomDrawerHeader(),
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Anúncios'),
            selected: pageController.page == 0,
            onTap: () {
              changeToPage(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Inserir Anúncio'),
            selected: pageController.page == 1,
            onTap: () {
              changeToPage(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chat'),
            selected: pageController.page == 2,
            onTap: () {
              changeToPage(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favoritos'),
            selected: pageController.page == 3,
            onTap: () {
              changeToPage(3);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Minha Conta'),
            selected: pageController.page == 4,
            onTap: () {
              changeToPage(4);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            selected: pageController.page == 4,
            onTap: () async {
              await UserRepository.logout();
            },
          ),
        ],
      ),
    );
  }
}
