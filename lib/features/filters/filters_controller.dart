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

import '../../common/models/city.dart';
import '../../common/models/state.dart';
import '../../manager/mechanics_manager.dart';
import '../../repository/ibge_repository.dart';
import 'filters_states.dart';

class FiltersController extends ChangeNotifier {
  FiltersState _state = FiltersStateInitial();
  final MechanicsManager mechManager = MechanicsManager.instance;

  FiltersState get state => _state;

  final List<StateBrModel> _stateList = [];
  final List<CityModel> _cityList = [];

  List<StateBrModel> get stateList => _stateList;
  List<String> get stateNames => _stateList.map((e) => e.nome).toList();
  List<CityModel> get cityList => _cityList;
  List<String> get cityNames => _cityList.map((e) => e.nome).toList();

  StateBrModel? _selectedState;
  CityModel? _selectedCity;

  StateBrModel? get selectedState => _selectedState;
  CityModel? get selectesCity => _selectedCity;

  final List<String> _selectedMechIds = [];
  List<String> get selectedMechIds => _selectedMechIds;

  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final mechsController = TextEditingController();

  final cityFocus = FocusNode();
  final orderByFocus = FocusNode();

  @override
  void dispose() {
    stateController.dispose();
    cityController.dispose();
    mechsController.dispose();

    cityFocus.dispose();
    orderByFocus.dispose();

    super.dispose();
  }

  Future<void> init() async {
    await _startResources();
  }

  void mechUpdateNames(List<String> mechIds) {
    _selectedMechIds.clear();
    _selectedMechIds.addAll(mechIds);
    final mechNames = mechManager.namesFromIdList(_selectedMechIds);
    mechsController.text = _joinMechNames(mechNames);
    log(mechsController.text);
  }

  String _joinMechNames(List<String> mechNames) {
    final buffer = StringBuffer();
    for (int i = 0; i < mechNames.length; i++) {
      buffer.write(mechNames[i]);
      if (i != mechNames.length - 1) {
        buffer.write(', ');
      }
    }
    return buffer.toString().trim();
  }

  void submitState(String stateName) {
    if (stateName.isEmpty) {
      _selectedState = null;
      return;
    }
    selectState(_stateList.firstWhere((s) => s.nome == stateName));
  }

  void submitCity(String cityName) {
    if (cityName.isEmpty) {
      _selectedCity = null;
      return;
    }
    _selectedCity = _cityList.firstWhere((c) => c.nome == cityName);
  }

  void _changeState(FiltersState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> selectState(StateBrModel? value) async {
    if (value == null) return;
    try {
      _changeState(FiltersStateLoading());
      _selectedState = value;
      await _getCity();
      log(value.toString());
      _changeState(FiltersStateSuccess());
    } catch (err) {
      log(err.toString());
      _changeState(FiltersStateError());
    }
  }

  void selectCity(String? value) {
    if (value != null) {
      _selectedCity = _cityList.firstWhere((city) => city.nome == value);
      log(value);
    }
  }

  Future<void> _startResources() async {
    try {
      _changeState(FiltersStateLoading());
      _stateList.clear();
      _stateList.addAll(await IbgeRepository.getStateList());
      _changeState(FiltersStateSuccess());
    } catch (err) {
      log(err.toString());
      _changeState(FiltersStateError());
    }
  }

  Future<void> _getCity() async {
    if (_selectedState == null) return;
    _selectedCity = null;
    _cityList.clear();
    _cityList.addAll(
      await IbgeRepository.getCityListFromApi(_selectedState!),
    );
  }
}
