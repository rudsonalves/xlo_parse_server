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

import '../common/models/category.dart';
import '../repository/mechanic_repository.dart';

class MechanicsManager {
  MechanicsManager._();
  static final _instance = MechanicsManager._();
  static MechanicsManager get instance => _instance;

  final List<MechanicModel> _mechanics = [];
  List<MechanicModel> get mechanics => _mechanics;
  List<String> get mechanicsNames =>
      _mechanics.map((item) => item.name!).toList();

  Future<void> init() async {
    final cats = await MechanicRepository.getList();

    if (cats != null) {
      _mechanics.addAll(cats);
    } else {
      throw Exception('Sorry. An error occurred, try later.');
    }
  }
}
