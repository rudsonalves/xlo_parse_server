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

import '../common/models/mechanic.dart';
import '../repository/mechanic_repository.dart';

/// This class manages the list of mechanics, providing methods to initialize,
/// retrieve mechanic names, and find mechanic names based on their IDs.
class MechanicsManager {
  final List<MechanicModel> _mechanics = [];

  List<MechanicModel> get mechanics => _mechanics;

  List<String> get mechanicsNames =>
      _mechanics.map((item) => item.name!).toList();

  Future<void> init() async {
    _mechanics.addAll(await MechanicRepository.getList());
  }

  /// Returns the name of the mechanic given its ID.
  ///
  /// [id] - The ID of the mechanic.
  /// Returns the name of the mechanic if found, otherwise returns null.
  String? nameFromId(String id) {
    return _mechanics
        .firstWhere(
          (item) => item.id == id,
          orElse: () => MechanicModel(id: '', name: null),
        )
        .name;
  }

  /// Returns a list of mechanic names given a list of mechanic IDs.
  ///
  /// [ids] - A list of mechanic IDs.
  /// Returns a list of mechanic names corresponding to the provided IDs.
  /// If a mechanic ID does not correspond to a mechanic, it logs an error.
  List<String> namesFromIdList(List<String> ids) {
    List<String> names = [];
    for (final id in ids) {
      final name = nameFromId(id);
      if (name != null) {
        names.add(name);
        continue;
      }
      log('MechanicsManager.namesFromIdList: name from MechanicModel.id $id return erro');
    }

    return names;
  }
}
