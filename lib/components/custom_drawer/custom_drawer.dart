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
import 'package:xlo_mobx/features/favorites/favorites_screen.dart';

import '../../common/app_constants.dart';
import '../../common/singletons/app_settings.dart';
import '../../common/singletons/current_user.dart';
import '../../features/base/base_controller.dart';
import '../../features/edit_advert/edit_advert_screen.dart';
import '../../get_it.dart';
import 'widgets/custom_drawer_header.dart';

class CustomDrawer extends StatelessWidget {
  final void Function() navToLoginScreen;

  CustomDrawer({
    super.key,
    required this.navToLoginScreen,
  });

  final app = getIt<AppSettings>();
  final currentUSer = getIt<CurrentUser>();
  final ctrl = getIt<BaseController>();

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
            onTap: () {
              Navigator.pop(context);
              navToLoginScreen();
            },
            child: const CustomDrawerHeader(),
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Anúncios'),
            selected: ctrl.pageController.page == AppPage.shopePage.index,
            onTap: () {
              ctrl.jumpToPage(AppPage.shopePage);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.camera,
              color: currentUSer.isLogged ? null : colorScheme.outline,
            ),
            title: Text(
              'Adicionar Anúncio',
              style: TextStyle(
                color: currentUSer.isLogged ? null : colorScheme.outline,
              ),
            ),
            onTap: currentUSer.isLogged
                ? () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, EditAdvertScreen.routeName);
                  }
                : null,
          ),
          ListTile(
            leading: Icon(Icons.chat,
                color: currentUSer.isLogged ? null : colorScheme.outline),
            title: Text(
              'Chat',
              style: TextStyle(
                color: currentUSer.isLogged ? null : colorScheme.outline,
              ),
            ),
            selected: ctrl.pageController.page == AppPage.chatPage.index,
            onTap: currentUSer.isLogged
                ? () {
                    ctrl.jumpToPage(AppPage.chatPage);
                    Navigator.pop(context);
                  }
                : null,
          ),
          ListTile(
            leading: Icon(
              Icons.favorite,
              color: currentUSer.isLogged ? null : colorScheme.outline,
            ),
            title: Text(
              'Favoritos',
              style: TextStyle(
                color: currentUSer.isLogged ? null : colorScheme.outline,
              ),
            ),
            selected: ctrl.pageController.page == AppPage.favoritesPage.index,
            onTap: currentUSer.isLogged
                ? () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, FavoritesScreen.routeName);
                  }
                : null,
          ),
          ListTile(
            leading: Icon(
              color: currentUSer.isLogged ? null : colorScheme.outline,
              Icons.person,
            ),
            title: Text(
              'Minha Conta',
              style: TextStyle(
                color: currentUSer.isLogged ? null : colorScheme.outline,
              ),
            ),
            selected: ctrl.pageController.page == AppPage.accountPage.index,
            onTap: currentUSer.isLogged
                ? () {
                    ctrl.jumpToPage(AppPage.accountPage);
                    Navigator.pop(context);
                  }
                : null,
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: currentUSer.isLogged ? null : colorScheme.outline,
            ),
            title: Text(
              'Sair',
              style: TextStyle(
                color: currentUSer.isLogged ? null : colorScheme.outline,
              ),
            ),
            selected: ctrl.pageController.page == AppPage.accountPage.index,
            onTap: currentUSer.isLogged
                ? () async {
                    await currentUSer.logout();
                    if (context.mounted) Navigator.pop(context);
                    ctrl.jumpToPage(AppPage.shopePage);
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
