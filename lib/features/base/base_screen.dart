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

import 'dart:developer';

import 'package:flutter/material.dart';

import '../../components/custom_drawer/custom_drawer.dart';
import '../account/account_screen.dart';
import '../chat/chat_screen.dart';
import '../favorites/favorites_screen.dart';
import '../home/home_screen.dart';
import '../advertisement/advert_screen.dart';
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
  final controller = BaseController();

  @override
  void initState() {
    super.initState();
    controller.init();
  }

  void _changeToPage(int page) {
    controller.jumpToPage(page);
  }

  Widget get titleWidget {
    if (controller.page == 0) {
      return (controller.search != null && controller.search!.isNotEmpty)
          ? GestureDetector(
              onTap: _openSearchDialog,
              child: LayoutBuilder(
                builder: (context, constraints) => SizedBox(
                  width: constraints.biggest.width,
                  child: Text(
                    controller.search!,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            )
          : Text(controller.titleNotifier.value);
    } else {
      return Text(controller.titleNotifier.value);
    }
  }

  Future<void> _openSearchDialog() async {
    String? result = await showSearch<String>(
      context: context,
      delegate: SearchDialog(),
    );

    // String? result = await showDialog<String?>(
    //   context: context,
    //   builder: (_) => SearchDialog(search: controller.search),
    // );

    if (result != null && result.isEmpty) {
      result = null;
    }
    log('BS $result');
    controller.setSearch(result);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: controller.titleNotifier,
          builder: (context, _, __) {
            return titleWidget;
          },
        ),
        centerTitle: true,
        elevation: 5,
        actions: [
          ListenableBuilder(
            listenable: controller.titleNotifier,
            builder: (context, _) {
              return (controller.page == 0)
                  ? IconButton(
                      onPressed: _openSearchDialog,
                      icon: const Icon(
                        Icons.search,
                      ),
                    )
                  : Container();
            },
          ),
          IconButton(
            isSelected: controller.app.isDark,
            onPressed: controller.app.toggleBrightnessMode,
            icon: const Icon(Icons.light_mode),
            selectedIcon: const Icon(Icons.dark_mode),
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
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final cities = [
    'City 1',
    'City 2',
    'City 3',
    // Add as many city names as you need
  ];

  final recentCities = [
    'City 1',
    'City 2',
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox(
      width: 100.0,
      height: 100.0,
      child: Card(
        color: Colors.red,
        child: Center(
          child: Text(query),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentCities
        : cities.where((c) => c.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          showResults(context);
        },
        leading: const Icon(Icons.location_city),
        title: RichText(
          text: TextSpan(
            text: suggestionList[index].substring(0, query.length),
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: suggestionList[index].substring(query.length),
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}
