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

import '../../common/basic_controller/basic_state.dart';
import 'my_ads_controller.dart';
import 'widgets/my_tab_bar.dart';
import 'widgets/my_tab_bar_view.dart';

class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({super.key});

  static const routeName = '/myadds';

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
  final MyAdsController ctrl = MyAdsController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    ctrl.init();
  }

  void _backPage() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Meus Anúncios'),
          centerTitle: true,
          elevation: 5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: _backPage,
          ),
          bottom: MyTabBar(setProductStatus: ctrl.setProductStatus),
        ),
        body: ListenableBuilder(
          listenable: ctrl,
          builder: (context, _) {
            if (ctrl.state is BasicStateSuccess) {
              if (ctrl.ads.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Card(
                        color: colorScheme.primaryContainer,
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Icon(Icons.cloud_off),
                              Text('Nenhum anúncio encontrado.'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return MyTabBarView(
                ctrl: ctrl,
                scrollController: _scrollController,
              );
            } else if (ctrl.state is BasicStateLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const Center(
              child: Text('Error!'),
            );
          },
        ),
      ),
    );
  }
}
