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

import '../common/models/address.dart';
import 'constants.dart';
import 'parse_to_model.dart';

class AddressRepository {
  static Future<AddressModel?> save(AddressModel address) async {
    try {
      final parseAddress = ParseObject(keyAddressTable);

      final parseUser = await ParseUser.currentUser() as ParseUser?;
      if (parseUser == null) {
        throw Exception('Current user not found');
      }

      if (address.id != null) {
        parseAddress.objectId = address.id;
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
        log('parseAddress.save error');
        throw Exception(response.error.toString());
      }

      return ParseToModel.address(parseAddress);
    } catch (err) {
      log(err.toString());
      throw Exception(err);
    }
  }

  static Future<bool> delete(AddressModel address) async {
    try {
      if (address.id == null) {
        log('Address ID is null');
        throw Exception('Address ID is required to delete the address');
      }

      final parseAddress = ParseObject(keyAddressTable);
      parseAddress.objectId = address.id!;

      final response = await parseAddress.delete();
      if (!response.success) {
        log('parseAddress.delete error: ${response.error?.message}');
        return false;
      }
      return true;
    } catch (err) {
      log('Error deleting address: $err');
      throw Exception(err);
    }
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
          .map((parse) => ParseToModel.address(parse as ParseObject))
          .toList();

      return addresses;
    } catch (err) {
      log(err.toString());
      throw Exception(err);
    }
  }
}
