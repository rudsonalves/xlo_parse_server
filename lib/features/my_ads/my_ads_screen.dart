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

import '../../common/basic_controller/basic_state.dart';
import '../../common/models/ad.dart';
import '../edit_ad/edit_ad_screen.dart';
import '../product/widgets/title_product.dart';
import 'my_ads_controller.dart';
import 'widgets/my_tab_bar.dart';
import 'widgets/my_tab_bar_view.dart';
import '/components/others_widgets/state_error_message.dart';
import '/components/others_widgets/state_loading_message.dart';

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

  void _editAd(AdModel ad) async {
    final result = await Navigator.pushNamed(context, EditAdScreen.routeName,
        arguments: ad) as AdModel?;
    if (result != null) {
      ctrl.updateAd(result);
    }
  }

  Future<void> _deleteAd(AdModel ad) async {
    final response = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Remover Anúncio'),
            icon: const Icon(
              Icons.warning_amber,
              color: Colors.amber,
              size: 80,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Confirma a remoção do anúcio:'),
                TitleProduct(title: ad.title),
              ],
            ),
            actions: [
              FilledButton.tonalIcon(
                onPressed: () => Navigator.pop(context, true),
                label: const Text('Remover'),
                icon: const Icon(Icons.delete),
              ),
              FilledButton.tonal(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ) ??
        false;

    if (response) {
      ctrl.deleteAd(ad);
    }
  }

  Future<void> _addNewAd() async {
    await Navigator.pushNamed(context, EditAdScreen.routeName);
    ctrl.getAds();
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _addNewAd,
          backgroundColor: colorScheme.primaryContainer.withOpacity(0.75),
          icon: const Icon(Icons.camera),
          label: const Text('Adicionar anúncio'),
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
                editAd: _editAd,
                deleteAd: _deleteAd,
              );
            } else if (ctrl.state is BasicStateLoading) {
              return const StateLoadingMessage();
            }
            return StateErrorMessage(
              closeDialog: ctrl.closeErroMessage,
            );
          },
        ),
      ),
    );
  }
}
