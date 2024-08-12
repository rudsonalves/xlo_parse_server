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
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/models/city.dart';
import '../../common/models/state.dart';

const sharedUFList = 'UFList';

/// This class provides methods to interact with the IBGE API
/// to retrieve state and city information.
class IbgeRepository {
  /// Fetches the list of Brazilian states from the IBGE API.
  ///
  /// If the list is not already cached in the local storage, it fetches it
  /// from the API, caches it, and returns the list.
  /// If the list is already cached, it retrieves it from the local storage.
  ///
  /// Returns a list of `StateBrModel` if the operation is successful,
  /// otherwise create an error.
  static Future<List<StateBrModel>> getStateList() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (!prefs.containsKey(sharedUFList)) {
        const urlStatesLocal =
            'https://servicodados.ibge.gov.br/api/v1/localidades/estados';

        final response = await http.get(Uri.parse(urlStatesLocal));
        if (response.statusCode == HttpStatus.ok) {
          final List<dynamic> data =
              json.decode(response.body) as List<dynamic>;

          final jsonData = json.encode(data);
          prefs.setString(sharedUFList, jsonData);

          return _converToUFModelList(data);
        } else {
          throw Exception('failed to load data.');
        }
      } else {
        final data =
            json.decode(prefs.get('UFList') as String) as List<dynamic>;
        return _converToUFModelList(data);
      }
    } catch (err) {
      final message = 'IbgeRepository.getStateList: $err';
      log(message);
      throw Exception(message);
    }
  }

  /// Converts a list of dynamic objects to a list of `StateBrModel`.
  ///
  /// [data] - A list of dynamic objects representing the states.
  /// Returns a list of `StateBrModel`.
  static _converToUFModelList(List<dynamic> data) {
    return data
        .map<StateBrModel>(
          (item) => StateBrModel.fromMap(item as Map<String, dynamic>),
        )
        .toList()
      ..sort(
        (a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()),
      );
  }

  /// Fetches the list of cities for a given state from the IBGE API.
  ///
  /// [uf] - The state for which to fetch the cities.
  /// Returns a list of `CityModel` if the operation is successful,
  /// otherwise create an error.
  static Future<List<CityModel>> getCityListFromApi(StateBrModel uf) async {
    try {
      final urlCityLocal =
          'https://servicodados.ibge.gov.br/api/v1/localidades/estados/${uf.id}/municipios/';

      final response = await http.get(Uri.parse(urlCityLocal));
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;

        return data
            .map<CityModel>(
              (item) => CityModel(
                id: item['id'] as int,
                nome: item['nome'] as String,
              ),
            )
            .toList()
          ..sort(
              (a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));
      } else {
        throw Exception('failed to load data.');
      }
    } catch (err) {
      final message = 'IbgeRepository.getCityListFromApi: $err';
      log(message);
      throw Exception(message);
    }
  }
}
