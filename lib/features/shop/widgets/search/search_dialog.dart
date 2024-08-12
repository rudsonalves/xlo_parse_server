// ignore_for_file: public_member_api_docs, sort_constructors_first
// Copyright (C) 2024 Rudson Alves
//
// This file is part of bgbazzar.
//
// bgbazzar is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// bgbazzar is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with bgbazzar.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../common/models/filter.dart';
import '../../../filters/filters_screen.dart';
import '../../shop_controller.dart';
import '../../../../common/singletons/app_settings.dart';
import '../../../../common/singletons/search_history.dart';
import '../../../../get_it.dart';

class SearchDialog extends SearchDelegate<String> {
  final searchHistory = getIt<SearchHistory>();
  final ctrl = getIt<ShopController>();

  bool get isDark => getIt<AppSettings>().isDark;

  Future<void> _filterSearch(BuildContext context) async {
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

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      InkWell(
        onTap: () {
          query = '';
        },
        borderRadius: BorderRadius.circular(50),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.clear),
        ),
      ),
      InkWell(
        onTap: () => _filterSearch(context),
        onLongPress: _filterClean,
        borderRadius: BorderRadius.circular(50),
        child: Padding(
          padding: const EdgeInsets.all(8),
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
        elevation: 5,
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        backgroundColor:
            isDark ? colorScheme.onSecondary : colorScheme.secondaryContainer,
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
    WidgetsBinding.instance.addPostFrameCallback((_) => close(context, query));
    searchHistory.saveHistory(query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final selected = query.isEmpty
        ? searchHistory.history
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
          },
        ),
      ),
    );
  }

  @override
  void close(BuildContext context, String result) {
    super.close(context, query);
  }
}
