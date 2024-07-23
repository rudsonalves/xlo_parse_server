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
import 'package:xlo_mobx/repository/advert_repository.dart';

import '../../common/models/filter.dart';
import '../filters/filters_screen.dart';
import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/shop';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ctrl = HomeController();

  @override
  void initState() {
    super.initState();
    ctrl.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () async {
          final result = await AdvertRepository.getAdvertisements(
              filter: ctrl.filter ?? FilterModel(), search: ctrl.search);
          log(result.toString());
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  isSelected: ctrl.filter != null && !ctrl.filter!.isEmpty,
                  onPressed: () async {
                    ctrl.filter = await Navigator.pushNamed(
                      context,
                      FiltersScreen.routeName,
                      arguments: ctrl.filter,
                    ) as FilterModel?;
                    setState(() {});
                  },
                  selectedIcon: const Icon(Icons.filter_alt_rounded),
                  icon: const Icon(Icons.filter_alt_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
