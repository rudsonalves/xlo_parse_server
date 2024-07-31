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

import 'package:flutter/material.dart';

import '../search_controller.dart';

class SearchDialog extends StatefulWidget {
  final String? search;
  const SearchDialog({
    super.key,
    this.search,
  });

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final ctrl = SearchDialogController();

  @override
  void initState() {
    super.initState();
    ctrl.search.text = widget.search ?? '';
  }

  Future<void> _submitted(String? value, [bool isSearchBar = false]) async {
    ctrl.search.closeView(value);
    await ctrl.saveHistory(value);
    if (!isSearchBar) {
      if (mounted) Navigator.pop(context, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ctrl.init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return Stack(
            children: [
              Positioned(
                top: 2,
                left: 2,
                right: 2,
                child: SearchAnchor(
                  textInputAction: TextInputAction.search,
                  viewOnSubmitted: _submitted,
                  searchController: ctrl.search,
                  builder: (context, controller) => SearchBar(
                    autoFocus: true,
                    // textInputAction: TextInputAction.search,
                    controller: controller,
                    padding: const WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    onTap: controller.openView,
                    onChanged: (value) => controller.openView(),
                    onSubmitted: (value) => _submitted(value, true),
                    leading: const Icon(Icons.search),
                    trailing: [
                      IconButton(
                        isSelected: ctrl.app.isDark,
                        onPressed: ctrl.app.toggleBrightnessMode,
                        icon: const Icon(Icons.light_mode),
                        selectedIcon: const Icon(Icons.dark_mode),
                      ),
                    ],
                  ),
                  suggestionsBuilder: (context, controller) =>
                      ctrl.searchInHistory(controller.text).map(
                            (item) => ListTile(
                              title: Text(item),
                              onTap: () => _submitted(item),
                            ),
                          ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
