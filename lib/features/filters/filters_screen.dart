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

import '../../common/models/filter.dart';
import '../../components/buttons/big_button.dart';
import '../mecanics/mecanics_screen.dart';
import 'filters_controller.dart';
import 'filters_states.dart';
import 'widgets/text_form_dropdown.dart';
import 'widgets/text_title.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  static const routeName = '/filters';

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  final ctrl = FiltersController();

  @override
  void initState() {
    super.initState();

    ctrl.init();
  }

  @override
  void dispose() {
    super.dispose();
    ctrl.dispose();
  }

  SortOrder sortBy = SortOrder.date;
  AdvertiserOrder advertiser = AdvertiserOrder.all;

  void _sendFilter() {
    final filter = FilterModel(
      state: ctrl.stateController.text,
      city: ctrl.cityController.text,
      sortBy: sortBy,
      advertiserOrder: advertiser,
      mechanicsId: ctrl.selectedMechIds,
    );
    Navigator.pop(context, filter);
  }

  Future<void> _selectMechanics() async {
    final newMechsIds = await Navigator.pushNamed(
      context,
      MecanicsScreen.routeName,
      arguments: ctrl.selectedMechIds,
    ) as List<String>;
    ctrl.mechUpdateNames(newMechsIds);
    log(newMechsIds.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtrar Anúncios'),
        centerTitle: true,
        leading: IconButton(
          onPressed: _sendFilter,
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: AnimatedBuilder(
          animation: ctrl,
          builder: (context, _) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextTitle('Localização'),
                      TextFormDropdown(
                        hintText: 'Estado',
                        controller: ctrl.stateController,
                        items: ctrl.stateNames,
                        submitItem: ctrl.submitState,
                      ),
                      TextFormDropdown(
                        hintText: 'Cidate',
                        controller: ctrl.cityController,
                        items: ctrl.cityNames,
                        submitItem: ctrl.submitCity,
                      ),
                      const TextTitle('Ordenar por'),
                      Row(
                        children: [
                          Expanded(
                            child: SegmentedButton<SortOrder>(
                              emptySelectionAllowed: false,
                              segments: const [
                                ButtonSegment(
                                  value: SortOrder.date,
                                  label: Text('Data'),
                                  icon: Icon(Icons.calendar_month),
                                ),
                                ButtonSegment(
                                  value: SortOrder.price,
                                  label: Text('Preço'),
                                  icon: Icon(Icons.price_change),
                                ),
                              ],
                              selected: {sortBy},
                              onSelectionChanged: (selection) {
                                if (selection.isEmpty) return;
                                setState(() {
                                  sortBy = selection.first;
                                  log(sortBy.name);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const TextTitle('Anunciante'),
                      Row(
                        children: [
                          Expanded(
                            child: SegmentedButton<AdvertiserOrder>(
                              multiSelectionEnabled: false,
                              segments: const [
                                ButtonSegment(
                                  value: AdvertiserOrder.all,
                                  icon: Icon(Icons.people_alt_outlined),
                                  label: Text('Todos'),
                                ),
                                ButtonSegment(
                                  value: AdvertiserOrder.particular,
                                  icon: Icon(Icons.person),
                                  label: Text('Particular'),
                                ),
                                ButtonSegment(
                                  value: AdvertiserOrder.commercial,
                                  icon: Icon(Icons.store),
                                  label: Text('Comercial'),
                                ),
                              ],
                              selected: {advertiser},
                              onSelectionChanged: (selection) {
                                if (selection.isEmpty) return;
                                setState(() {
                                  advertiser = selection.first;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const TextTitle('Mecânicas'),
                      InkWell(
                        onTap: _selectMechanics,
                        child: AbsorbPointer(
                          child: TextField(
                            readOnly: true,
                            maxLines: null,
                            controller: ctrl.mechsController,
                            decoration: InputDecoration(
                              hintText: 'Clique para selecionar mecânicas',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      BigButton(
                        color: Colors.green,
                        label: 'Filtrar',
                        onPress: _sendFilter,
                      ),
                    ],
                  ),
                ),
                if (ctrl.state is FiltersStateLoading)
                  const Positioned.fill(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if (ctrl.state is FiltersStateError)
                  const Positioned.fill(
                    child: Card(
                      child: Center(
                        child: Text('Error!!!'),
                      ),
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }
}