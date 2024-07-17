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
import 'package:xlo_mobx/repository/constants.dart';

import '../common/models/address.dart';

class AddressRepository {
  static Future<AddressModel?> saveAddress(AddressModel address) async {
    try {
      final parseAddress = ParseObject(keyAddressTable);

      final parseUser = await ParseUser.currentUser() as ParseUser?;
      if (parseUser == null) {
        throw Exception('Current user not found');
      }

      final addressInName = await _getAddressByName(parseUser, address.name);

      if (address.id != null && addressInName == null) {
        parseAddress.objectId = address.id;
      } else if (address.id == null && addressInName != null) {
        parseAddress.objectId = addressInName.id;
      } else if (address.id != null && addressInName != null) {
        if (address.id != addressInName.id) {
          throw Exception('An address with this name already exists');
        } else {
          parseAddress.objectId = address.id;
        }
      }

      final parseAcl = ParseACL(owner: parseUser);
      parseAcl.setPublicReadAccess(allowed: true);
      parseAcl.setPublicWriteAccess(allowed: false);

      parseAddress
        ..set<ParseUser>(keyAddressOwner, parseUser)
        ..set<String>(keyAddressName, address.name)
        ..set<String>(keyAddressZipCode, address.zipCode)
        ..set<String>(keyAddressStreet, address.street)
        ..set<String>(keyAddressNumber, address.number)
        ..set<String?>(keyAddressComplement, address.complement)
        ..set<String>(keyAddressNeighborhood, address.neighborhood)
        ..set<String>(keyAddressState, address.state)
        ..set<String>(keyAddressCity, address.city)
        ..setACL(parseAcl);

      final response = await parseAddress.save();
      if (!response.success) {
        throw Exception(response.error.toString());
      }

      return _parseServerToAddress(parseAddress);
    } catch (err) {
      log(err.toString());
      return null;
    }
  }

  static Future<AddressModel?> _getAddressByName(
    ParseUser user,
    String name,
  ) async {
    final parseAddress = ParseObject(keyAddressTable);
    final queryBuilder = QueryBuilder<ParseObject>(parseAddress)
      ..whereEqualTo(keyAddressOwner, user)
      ..whereEqualTo(keyAddressName, name);

    final response = await queryBuilder.query();
    if (!response.success) {
      log(response.error.toString());
      return null;
    }

    if (response.results == null || response.results!.isEmpty) return null;

    return _parseServerToAddress(response.results!.first as ParseObject);
  }

  static Future<List<AddressModel>?> getUserAddresses(String userId) async {
    try {
      List<AddressModel>? addresses;

      final parseAddress = ParseObject(keyAddressTable);

      final parseUser = await ParseUser.currentUser() as ParseUser?;
      if (parseUser == null) {
        throw Exception('Current user not found');
      }

      final queryBuilder = QueryBuilder<ParseObject>(parseAddress)
        ..whereEqualTo(keyAddressOwner, parseUser);

      final response = await queryBuilder.query();
      if (!response.success) {
        throw Exception(response.error);
      }

      if (response.results == null || response.results!.isEmpty) return [];
      addresses = response.results!
          .map((parse) => _parseServerToAddress(parse as ParseObject))
          .toList();

      return addresses;
    } catch (err) {
      log(err.toString());
      return null;
    }
  }

  static AddressModel _parseServerToAddress(ParseObject parseAddress) {
    return AddressModel(
      id: parseAddress.objectId,
      name: parseAddress.get<String>(keyAddressName)!,
      zipCode: parseAddress.get<String>(keyAddressZipCode)!,
      userId: parseAddress.get<ParseUser>(keyAddressOwner)!.objectId!,
      street: parseAddress.get<String>(keyAddressStreet)!,
      number: parseAddress.get<String>(keyAddressNumber)!,
      complement: parseAddress.get<String?>(keyAddressComplement),
      neighborhood: parseAddress.get<String>(keyAddressNeighborhood)!,
      state: parseAddress.get<String>(keyAddressState)!,
      city: parseAddress.get<String>(keyAddressCity)!,
    );
  }
}
