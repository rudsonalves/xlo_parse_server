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
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../common/models/city.dart';
import '../common/models/uf.dart';

const sharedUFList = 'UFList';

class IbgeRepository {
  static Future<List<UFModel>> getUFList() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(sharedUFList)) {
      const urlStatesLocal =
          'https://servicodados.ibge.gov.br/api/v1/localidades/estados';

      final response = await http.get(Uri.parse(urlStatesLocal));
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;

        final jsonData = json.encode(data);
        prefs.setString(sharedUFList, jsonData);

        return _converToUFModelList(data);
      } else {
        throw Exception('Failed to load data.');
      }
    } else {
      final data = json.decode(prefs.get('UFList') as String) as List<dynamic>;
      return _converToUFModelList(data);
    }
  }

  static _converToUFModelList(List<dynamic> data) {
    return data
        .map<UFModel>(
          (item) => UFModel.fromMap(item as Map<String, dynamic>),
        )
        .toList()
      ..sort(
        (a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()),
      );
  }

  static Future<List<CityModel>> getCityListFromApi(UFModel uf) async {
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
        ..sort((a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));
    } else {
      throw Exception('Failed to load data.');
    }
  }
}
