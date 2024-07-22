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

import 'package:flutter/foundation.dart';

import '../../common/singletons/app_settings.dart';
import '../../common/singletons/current_user.dart';
import '../../manager/mechanics_manager.dart';
import 'home_state.dart';

class HomeController extends ChangeNotifier {
  HomeState _state = HomeStateInitial();
  HomeState get state => _state;

  final app = AppSettings.instance;
  final CurrentUser? user = CurrentUser.instance;
  final MechanicsManager mechManager = MechanicsManager.instance;

  final List<String> _selectedMechIds = [];
  List<String> get selectedMechIds => _selectedMechIds;

  String get mechButtonName {
    if (_selectedMechIds.isEmpty) {
      return 'Mecânicas';
    }
    if (_selectedMechIds.length == 1) {
      return mechManager.nameFromId(_selectedMechIds.first)!;
    }

    final mechNames = mechManager.namesFromIdList(_selectedMechIds);
    return _joinMechNames(mechNames);
  }

  void updateMachIds(List<String> mechIds) {
    _selectedMechIds.clear();
    if (mechIds.isNotEmpty) {
      _selectedMechIds.addAll(mechIds);
    }
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

  void init() {}

  void _changeState(HomeState newState) {
    _state = newState;
    notifyListeners();
  }
}
