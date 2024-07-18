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

import '../common/models/viacep_address.dart';

class ViacepRepository {
  static Future<ViaCEPAddressModel> getLocalByCEP(String cep) async {
    String cleanCEP = _cleanCEP(cep);
    if (cleanCEP.length != 8) throw Exception('CEP invalid');

    final urlCEP = 'https://viacep.com.br/ws/$cleanCEP/json/';

    final response = await http.get(Uri.parse(urlCEP));
    if (response.statusCode == HttpStatus.ok) {
      final data = json.decode(response.body) as Map<String, dynamic>;

      if (data['erro'] == true) throw Exception('CEP invalid.');

      final address = ViaCEPAddressModel.fromMap(data);
      return address;
    } else {
      throw Exception('Failed to load data.');
    }
  }

  static String _cleanCEP(String cep) {
    return cep.replaceAll(RegExp(r'[^\d]'), '');
  }
}
