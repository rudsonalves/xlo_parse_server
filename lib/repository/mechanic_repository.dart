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

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../common/models/mechanic.dart';
import 'constants.dart';
import 'parse_to_model.dart';

/// This class provides methods to interact with the Parse Server
/// to retrieve a list of mechanics.
class MechanicRepository {
  /// Fetches a list of mechanics from the Parse Server.
  ///
  /// Returns a list of `MechanicModel` if the query is successful,
  /// otherwise create an error.
  static Future<List<MechanicModel>> getList() async {
    try {
      final mechanics = <MechanicModel>[];

      final parseMechanics = ParseObject(keyMechanicTable);
      final queryBuilder = QueryBuilder<ParseObject>(parseMechanics)
        ..orderByAscending(
          keyMechanicName,
        );

      final response = await queryBuilder.query();

      if (!response.success) {
        throw Exception(response.error?.message ?? 'unknown error');
      }

      mechanics.addAll(
        response.results!.map(
          (objParse) => ParseToModel.mechanic(objParse),
        ),
      );

      return mechanics;
    } catch (err) {
      final message = 'MechanicRepository.getList: $err';
      log(message);
      throw Exception(message);
    }
  }
}
