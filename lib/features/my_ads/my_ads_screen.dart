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
import 'package:xlo_mobx/common/basic_controller/basic_state.dart';
import 'package:xlo_mobx/common/theme/app_text_style.dart';

import '../../common/models/advert.dart';
import 'my_ads_controller.dart';
import 'widgets/my_ad_list_view.dart';

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
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Meus Anúncios'),
          centerTitle: true,
          elevation: 5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: _backPage,
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: const Icon(Icons.notifications_off_outlined),
                child: Text(
                  'Pendentes',
                  style: AppTextStyle.font12,
                ),
              ),
              Tab(
                icon: const Icon(Icons.notifications_active),
                child: Text(
                  'Ativos',
                  style: AppTextStyle.font12,
                ),
              ),
              Tab(
                icon: const Icon(Icons.currency_exchange_rounded),
                child: Text(
                  'Vendidos',
                  style: AppTextStyle.font12,
                ),
              ),
              Tab(
                icon: const Icon(Icons.close_rounded),
                child: Text(
                  'Fechados',
                  style: AppTextStyle.font12,
                ),
              ),
            ],
            onTap: (value) {
              switch (value) {
                case 0:
                  ctrl.setProductStatus(AdvertStatus.pending);
                  break;
                case 1:
                  ctrl.setProductStatus(AdvertStatus.active);
                  break;
                case 2:
                  ctrl.setProductStatus(AdvertStatus.sold);
                  break;
                case 3:
                  ctrl.setProductStatus(AdvertStatus.closed);
                  break;
              }
              log(value.toString());
            },
          ),
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
                                Text('Nenhum anúncio encontrado.')
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return TabBarView(
                  children: List.generate(
                    4,
                    (index) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: AdListView(
                        ctrl: ctrl,
                        scrollController: _scrollController,
                      ),
                    ),
                  ),
                );
              } else if (ctrl.state is BasicStateLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return const Center(
                child: Text('Error!'),
              );
            }),
      ),
    );
  }
}
