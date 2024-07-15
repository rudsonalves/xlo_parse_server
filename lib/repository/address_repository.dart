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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xlo_mobx/repository/constants.dart';

import '../common/models/address.dart';

const sharedUserAddress = 'UserAddress';

class AddressRepository {
  static Future<AddressModel> saveAddress(AddressModel address) async {
    final parseAddress = ParseObject(keyAddressTable);
    if (address.id != null) {
      parseAddress.objectId = address.id;
    }

    parseAddress
      ..set<String>(keyAddressUserId, address.userId)
      ..set<String>(keyAddressZipCode, address.zipCode)
      ..set<String>(keyAddressStreet, address.street)
      ..set<String>(keyAddressNumber, address.number)
      ..set<String?>(keyAddressComplement, address.complement)
      ..set<String>(keyAddressNeighborhood, address.neighborhood)
      ..set<String>(keyAddressState, address.state)
      ..set<String>(keyAddressCity, address.city);

    final response = await parseAddress.save();
    if (!response.success) {
      throw Exception(response.error);
    }

    await _saveLocalAddress(address);
    return _parserServerToAddress(parseAddress);
  }

  static Future<void> _saveLocalAddress(AddressModel address) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(sharedUserAddress, address.toJson());
  }

  static Future<AddressModel?> getUserAddress(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    AddressModel? address;
    if (prefs.containsKey(sharedUserAddress)) {
      address = await _getLocalAddress(userId);
      if (address != null) return address;
    }

    final parseAddress = ParseObject(keyAddressTable);

    final queryBuilder = QueryBuilder<ParseObject>(parseAddress)
      ..whereEqualTo(keyAddressUserId, userId)
      ..setLimit(1);

    final response = await queryBuilder.query();

    if (!response.success) {
      throw Exception(response.error);
    }

    if (response.results == null || response.results!.isEmpty) return null;
    address = _parserServerToAddress(response.results!.first as ParseObject);
    await _saveLocalAddress(address);
    return address;
  }

  static Future<AddressModel?> _getLocalAddress(String userId) async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(sharedUserAddress)) return null;
    final address =
        AddressModel.fromJson(prefs.get(sharedUserAddress) as String);

    return address.userId == userId ? address : null;
  }

  static AddressModel _parserServerToAddress(ParseObject parseAddress) {
    return AddressModel(
      id: parseAddress.objectId,
      zipCode: parseAddress.get<String>(keyAddressZipCode)!,
      userId: parseAddress.get<String>(keyAddressUserId)!,
      street: parseAddress.get<String>(keyAddressStreet)!,
      number: parseAddress.get<String>(keyAddressNumber)!,
      complement: parseAddress.get<String?>(keyAddressComplement),
      neighborhood: parseAddress.get<String>(keyAddressNeighborhood)!,
      state: parseAddress.get<String>(keyAddressState)!,
      city: parseAddress.get<String>(keyAddressCity)!,
    );
  }
}
