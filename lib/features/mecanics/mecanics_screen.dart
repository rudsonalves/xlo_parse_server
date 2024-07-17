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

import '../../manager/mechanics_manager.dart';

class MecanicsScreen extends StatefulWidget {
  final List<String> selectedIds;
  final void Function(List<String> ids) callBack;

  const MecanicsScreen({
    super.key,
    required this.selectedIds,
    required this.callBack,
  });

  static const routeName = '/categories';

  @override
  State<MecanicsScreen> createState() => _MecanicsScreenState();
}

class _MecanicsScreenState extends State<MecanicsScreen> {
  final categories = MechanicsManager.instance.mechanics;

  final selectedItem = <bool>[];
  final select = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < categories.length; i++) {
      selectedItem.add(
        widget.selectedIds.contains(categories[i].id!) ? true : false,
      );
    }
  }

  @override
  void dispose() {
    select.dispose();
    super.dispose();
  }

  void storeSelectedIds() {
    final selectedIds = <String>[];
    for (int index = 0; index < selectedItem.length; index++) {
      if (selectedItem[index]) {
        selectedIds.add(categories[index].id!);
      }
    }
    widget.callBack(selectedIds);
  }

  void deselectAll() {
    selectedItem.fillRange(0, selectedItem.length, false);
    setState(() {});
  }

  void closeCategoriesPage() {
    storeSelectedIds();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        storeSelectedIds();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Categorias'),
          centerTitle: true,
        ),
        body: Card(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: select,
                    builder: (context, value, _) {
                      return ListView.separated(
                        itemCount: categories.length,
                        separatorBuilder: (context, index) =>
                            const Divider(indent: 24, endIndent: 24),
                        itemBuilder: (context, index) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: selectedItem[index]
                                ? colorScheme.tertiary.withOpacity(0.15)
                                : null,
                          ),
                          child: ListTile(
                            title: Text(categories[index].name!),
                            subtitle: Text(categories[index].description ?? ''),
                            onTap: () {
                              selectedItem[index] = !selectedItem[index];
                              select.value = !select.value;
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: closeCategoriesPage,
                      label: const Text('Voltar'),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: deselectAll,
                      icon: const Icon(Icons.deselect),
                      label: const Text('Deselecionar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
