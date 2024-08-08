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
import 'package:xlo_mobx/components/others_widgets/state_error_message.dart';

import '../../components/buttons/big_button.dart';
import '../../components/form_fields/custom_form_field.dart';
import '../../components/form_fields/custom_names_form_field.dart';
import '../../components/others_widgets/state_loading_message.dart';
import 'boardgame_controller.dart';
import 'boardgame_state.dart';

class BoardgamesScreen extends StatefulWidget {
  const BoardgamesScreen({super.key});

  static const routeName = '/boardgame';

  @override
  State<BoardgamesScreen> createState() => _BoardgamesScreenState();
}

class _BoardgamesScreenState extends State<BoardgamesScreen> {
  final ctrl = BoardgameController();

  @override
  void initState() {
    super.initState();

    ctrl.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados do Jogo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListenableBuilder(
            listenable: ctrl,
            builder: (context, _) {
              return Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomNamesFormField(
                        controller: ctrl.bggName,
                        names: ctrl.bgNames,
                        labelText: 'Nome no BGG (para Rank)',
                        fullBorder: false,
                        floatingLabelBehavior: null,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      // CustomFormField(
                      //   labelText: 'Ano de lançamento',
                      //   fullBorder: false,
                      //   keyboardType: TextInputType.number,
                      // ),
                      const Text('Número de Jogadores'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 120,
                            child: CustomFormField(
                              labelText: 'Mín',
                              fullBorder: false,
                              hintText: '2',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const Text(' a '),
                          SizedBox(
                            width: 120,
                            child: CustomFormField(
                              labelText: 'Máx',
                              fullBorder: false,
                              hintText: '4',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const Text('Tempo de Jogo'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 120,
                            child: CustomFormField(
                              labelText: 'Mín',
                              fullBorder: false,
                              hintText: '25',
                              suffixText: 'min',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const Text(' a '),
                          SizedBox(
                            width: 120,
                            child: CustomFormField(
                              labelText: 'Máx',
                              fullBorder: false,
                              hintText: '50',
                              suffixText: 'min',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      CustomFormField(
                        labelText: 'Idade recomendada',
                        hintText: '10',
                        prefixText: '+',
                        suffixText: 'anos',
                        fullBorder: false,
                        keyboardType: TextInputType.number,
                      ),
                      CustomFormField(
                        labelText: 'Descrição',
                        fullBorder: false,
                      ),
                      CustomFormField(
                        labelText: 'Peso do Jogo (0-5)',
                        fullBorder: false,
                        keyboardType: TextInputType.number,
                      ),
                      CustomFormField(
                        labelText: 'Nota no BGG (0-10)',
                        fullBorder: false,
                        keyboardType: TextInputType.number,
                      ),
                      BigButton(
                        color: Colors.yellow.withOpacity(0.45),
                        label: 'Voltar',
                        onPress: () {
                          ctrl.getBggInfos();
                        },
                      ),
                    ],
                  ),
                  if (ctrl.state is BoardgameStateLoading)
                    const Positioned.fill(
                      child: StateLoadingMessage(),
                    ),
                  if (ctrl.state is BoardgameStateError)
                    Positioned.fill(
                      child: StateErrorMessage(
                        closeDialog: ctrl.closeErroMessage,
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
