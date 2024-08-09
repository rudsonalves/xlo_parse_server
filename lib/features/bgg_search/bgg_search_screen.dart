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

import 'package:flutter/material.dart';

import '../../components/buttons/big_button.dart';
import '../../components/others_widgets/state_error_message.dart';
import '../../components/others_widgets/state_loading_message.dart';
import 'bgg_search_controller.dart';
import 'bgg_search_state.dart';
import 'widgets/bg_info_card.dart';
import 'widgets/search_card.dart';

class BggSearchScreen extends StatefulWidget {
  const BggSearchScreen({super.key});

  static const routeName = '/bggsearch';

  @override
  State<BggSearchScreen> createState() => _BggSearchScreenState();
}

class _BggSearchScreenState extends State<BggSearchScreen> {
  final ctrl = BggController();

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  void _startSearch() {
    FocusScope.of(context).nextFocus();
    ctrl.searchBgg();
  }

  void _backPage() => Navigator.pop(context, null);

  void _backPageWithGame() => Navigator.pop(context, ctrl.selectedGame);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BGG Search'),
        centerTitle: true,
        leading: IconButton(
          onPressed: _backPage,
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: ListenableBuilder(
          listenable: ctrl,
          builder: (context, _) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: ctrl.bgName,
                          decoration: InputDecoration(
                            hintText: 'Entre com o nome do jogo',
                            suffixIcon: IconButton(
                              onPressed: _startSearch,
                              icon: const Icon(Icons.search),
                            ),
                          ),
                          onSubmitted: (value) => _startSearch(),
                        ),
                        if (ctrl.bggSearchList.isNotEmpty)
                          SearchCard(
                            bggSearchList: ctrl.bggSearchList,
                            getBoardInfo: ctrl.getBoardInfo,
                          ),
                        if (ctrl.selectedGame != null)
                          BGInfoCard(ctrl.selectedGame!),
                        if (ctrl.selectedGame != null)
                          BigButton(
                            label: 'Selecionar',
                            color: Colors.blueAccent.withOpacity(0.45),
                            onPressed: _backPageWithGame,
                          ),
                      ],
                    ),
                  ),
                ),
                if (ctrl.state is BggSearchStateLoading)
                  const Positioned.fill(
                    child: StateLoadingMessage(),
                  ),
                if (ctrl.state is BggSearchStateError)
                  Positioned.fill(
                    child: StateErrorMessage(
                      closeDialog: ctrl.closeError,
                    ),
                  ),
              ],
            );
          }),
    );
  }
}
