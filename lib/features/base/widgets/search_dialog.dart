// ignore_for_file: public_member_api_docs, sort_constructors_first
// Copyright (C) 2024 Rudson Alves
//
// This file is part of xlo_parse_server.
//
// xlo_parse_server is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// xlo_parse_server is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xlo_parse_server.  If not, see <https://www.gnu.org/licenses/>.

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../common/singletons/app_settings.dart';
import '../../../common/singletons/search_history.dart';

class SearchDialog extends SearchDelegate<String> {
  final searchHistory = SearchHistory.instance;
  final app = AppSettings.instance;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
      IconButton(
        isSelected: app.isDark,
        onPressed: app.toggleBrightnessMode,
        icon: const Icon(Icons.light_mode),
        selectedIcon: const Icon(Icons.dark_mode),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
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
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return theme.copyWith(
      appBarTheme: AppBarTheme(
        elevation: 10,
        systemOverlayStyle: colorScheme.brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        backgroundColor: colorScheme.brightness == Brightness.dark
            ? colorScheme.onSecondary
            : colorScheme.secondaryContainer,
        iconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
        titleTextStyle: theme.textTheme.titleLarge,
        toolbarTextStyle: theme.textTheme.bodyMedium,
      ),
      inputDecorationTheme: searchFieldDecorationTheme ??
          InputDecorationTheme(
            hintStyle: searchFieldStyle ?? theme.inputDecorationTheme.hintStyle,
            border: InputBorder.none,
          ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // log('Do the search');
    // final result = <String>[query];
    // final colorScheme = Theme.of(context).colorScheme;

    // if (result.length < 2) {
    WidgetsBinding.instance.addPostFrameCallback((_) => close(context, query));
    searchHistory.saveHistory(query);
    return Container();
    // }

    // return SizedBox(
    //   width: 200,
    //   height: 300,
    //   child: Card(
    //     color: colorScheme.secondaryContainer,
    //     child: ListView(
    //       children: result
    //           .map<Widget>(
    //             (item) => ListTile(
    //               title: Text(item),
    //               onTap: () {
    //                 log('Selected: $query');
    //                 query = item;
    //                 close(context, query);
    //               },
    //             ),
    //           )
    //           .toList(),
    //     ),
    //   ),
    // );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final selected = query.isEmpty || query.length < 3
        ? <String>[]
        : searchHistory.searchInHistory(query).toList();

    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
      color: colorScheme.surfaceContainer,
      child: ListView.builder(
        itemCount: selected.length,
        shrinkWrap: true,
        itemBuilder: (_, index) => ListTile(
          title: Text(selected[index]),
          onTap: () {
            query = selected[index];
            // buildResults(context);
            // close(context, query);
          },
        ),
      ),
    );
  }

  @override
  void close(BuildContext context, String result) {
    log('SD $query');
    super.close(context, query);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
