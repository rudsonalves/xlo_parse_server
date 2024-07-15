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

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:xlo_mobx/repository/constants.dart';

import '../common/models/category.dart';

class MechanicRepository {
  static Future<List<MechanicModel>?> getList() async {
    final mechanics = <MechanicModel>[];

    final parseMechanics = ParseObject(keyMechanicTable);
    final queryBuilder = QueryBuilder<ParseObject>(parseMechanics)
      ..orderByAscending(
        keyMechanicName,
      );

    final response = await queryBuilder.query();

    if (!response.success) {
      throw Exception('${response.error!.code} - ${response.error}');
    }

    mechanics.addAll(
      response.results!.map(
        (objParse) => parseCategory(objParse),
      ),
    );

    return mechanics;
  }

  static parseCategory(ParseObject parseMechanic) {
    return MechanicModel(
      id: parseMechanic.objectId,
      name: parseMechanic.get(keyMechanicName),
      description: parseMechanic.get(keyMechanicDescription),
      createAt: parseMechanic.createdAt,
    );
  }
}
