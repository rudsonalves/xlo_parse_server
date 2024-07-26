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
import '../../features/base/base_controller.dart';
import '../../features/login/login_screen.dart';
import '../../get_it.dart';
import 'widgets/custom_drawer_header.dart';

class CustomDrawer extends StatelessWidget {
  final ColorScheme colorScheme;
  final PageController pageController;

  CustomDrawer({
    super.key,
    required this.colorScheme,
    required this.pageController,
  });

  final app = getIt<AppSettings>();
  final currentUSer = getIt<CurrentUser>();
  final jumpToPage = getIt<BaseController>().jumpToPage;

  void _navToLoginScreen(BuildContext context) {
    if (currentUSer.isLoged) {
      Navigator.pop(context);
      jumpToPage(4);
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
          ? colorScheme.onSecondary.withOpacity(0.90)
          : colorScheme.onPrimary.withOpacity(0.90),
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
              jumpToPage(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.camera,
              color: currentUSer.isLoged ? null : colorScheme.outline,
            ),
            title: Text(
              'Adicionar Anúncio',
              style: TextStyle(
                color: currentUSer.isLoged ? null : colorScheme.outline,
              ),
            ),
            selected: pageController.page == 1,
            onTap: currentUSer.isLoged
                ? () {
                    jumpToPage(1);
                    Navigator.pop(context);
                  }
                : null,
          ),
          ListTile(
            leading: Icon(Icons.chat,
                color: currentUSer.isLoged ? null : colorScheme.outline),
            title: Text(
              'Chat',
              style: TextStyle(
                color: currentUSer.isLoged ? null : colorScheme.outline,
              ),
            ),
            selected: pageController.page == 2,
            onTap: currentUSer.isLoged
                ? () {
                    jumpToPage(2);
                    Navigator.pop(context);
                  }
                : null,
          ),
          ListTile(
            leading: Icon(
              Icons.favorite,
              color: currentUSer.isLoged ? null : colorScheme.outline,
            ),
            title: Text(
              'Favoritos',
              style: TextStyle(
                color: currentUSer.isLoged ? null : colorScheme.outline,
              ),
            ),
            selected: pageController.page == 3,
            onTap: currentUSer.isLoged
                ? () {
                    jumpToPage(3);
                    Navigator.pop(context);
                  }
                : null,
          ),
          ListTile(
            leading: Icon(
              color: currentUSer.isLoged ? null : colorScheme.outline,
              Icons.person,
            ),
            title: Text(
              'Minha Conta',
              style: TextStyle(
                color: currentUSer.isLoged ? null : colorScheme.outline,
              ),
            ),
            selected: pageController.page == 4,
            onTap: currentUSer.isLoged
                ? () {
                    jumpToPage(4);
                    Navigator.pop(context);
                  }
                : null,
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: currentUSer.isLoged ? null : colorScheme.outline,
            ),
            title: Text(
              'Sair',
              style: TextStyle(
                color: currentUSer.isLoged ? null : colorScheme.outline,
              ),
            ),
            selected: pageController.page == 4,
            onTap: currentUSer.isLoged
                ? () async {
                    await currentUSer.logout();
                    if (context.mounted) Navigator.pop(context);
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
