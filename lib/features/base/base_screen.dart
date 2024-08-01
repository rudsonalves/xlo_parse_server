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

import '../../common/app_constants.dart';
import '../../common/models/filter.dart';
import '../../components/custom_drawer/custom_drawer.dart';
import '../../components/others_widgets/state_loading_message.dart';
import '../../get_it.dart';
import '../login/login_screen.dart';
import '../my_account/my_account_screen.dart';
import '../chat/chat_screen.dart';
import '../filters/filters_screen.dart';
import '../shop/shop_screen.dart';
import 'base_controller.dart';
import 'base_state.dart';
import 'widgets/search_dialog.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  static const routeName = '/';

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final ctrl = getIt<BaseController>();

  @override
  void initState() {
    super.initState();
    ctrl.init();
  }

  @override
  void dispose() {
    disposeDependencies(); // Locator dispose

    super.dispose();
  }

  Widget get titleWidget {
    if (ctrl.page == AppPage.shopePage) {
      return (ctrl.searchString.isNotEmpty)
          ? GestureDetector(
              onTap: _openSearchDialog,
              child: LayoutBuilder(
                builder: (context, constraints) => SizedBox(
                  width: constraints.biggest.width,
                  child: Text(
                    ctrl.searchString,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            )
          : Text(ctrl.pageTitle.value);
    } else {
      return Text(ctrl.pageTitle.value);
    }
  }

  Future<void> _openSearchDialog() async {
    String? result = await showSearch<String>(
      context: context,
      delegate: SearchDialog(),
    );

    if (result != null && result.isEmpty) {
      result = null;
    }
    ctrl.setSearch(result ?? '');
  }

  Future<void> _cleanSearch() async {
    ctrl.setSearch('');
  }

  Future<void> _filterSearch() async {
    ctrl.filter = await Navigator.pushNamed(
          context,
          FiltersScreen.routeName,
          arguments: ctrl.filter,
        ) as FilterModel? ??
        FilterModel();
  }

  Future<void> _filterClean() async {
    ctrl.filter = FilterModel();
  }

  Future<void> navToLoginScreen() async {
    if (ctrl.currentUser.isLogged) {
      ctrl.jumpToPage(AppPage.accountPage);
    } else {
      await Navigator.pushNamed(context, LoginScreen.routeName);
      ctrl.init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListenableBuilder(
          listenable: ctrl.pageTitle,
          builder: (context, _) {
            return titleWidget;
          },
        ),
        centerTitle: true,
        elevation: 5,
        actions: [
          ListenableBuilder(
            listenable: ctrl.pageTitle,
            builder: (context, _) {
              return (ctrl.page == AppPage.shopePage)
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: _openSearchDialog,
                          onLongPress: _cleanSearch,
                          borderRadius: BorderRadius.circular(50),
                          child: Ink(
                            decoration: const ShapeDecoration(
                              shape: CircleBorder(),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                ctrl.searchString.isEmpty
                                    ? Icons.search
                                    : Icons.search_off,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: _filterSearch,
                          onLongPress: _filterClean,
                          borderRadius: BorderRadius.circular(50),
                          child: Ink(
                            decoration: const ShapeDecoration(
                              shape: CircleBorder(),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListenableBuilder(
                                listenable: ctrl.searchFilter.filterNotifier,
                                builder: (context, _) {
                                  return Icon(
                                    ctrl.filter == FilterModel()
                                        ? Icons.filter_alt_outlined
                                        : Icons.filter_alt_rounded,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container();
            },
          ),
          IconButton(
            isSelected: ctrl.app.isDark,
            onPressed: ctrl.app.toggleBrightnessMode,
            icon: const Icon(Icons.light_mode),
            selectedIcon: const Icon(Icons.dark_mode),
          ),
        ],
      ),
      drawer: CustomDrawer(
        navToLoginScreen: navToLoginScreen,
      ),
      body: ListenableBuilder(
        listenable: ctrl,
        builder: (context, _) {
          return Stack(
            children: [
              Positioned.fill(
                child: PageView(
                  controller: ctrl.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    ShopScreen(),
                    ChatScreen(),
                    MyAccountScreen(),
                  ],
                ),
              ),
              if (ctrl.state is BaseStateLoading)
                const Positioned.fill(
                  child: StateLoadingMessage(),
                ),
            ],
          );
        },
      ),
    );
  }
}
