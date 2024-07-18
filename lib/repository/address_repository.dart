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
  static Future<AddressModel?> save(AddressModel address) async {
    try {
      log('Save address');
      final parseAddress = ParseObject(keyAddressTable);

      log('Get parseUser');
      final parseUser = await ParseUser.currentUser() as ParseUser?;
      log('Get parseUser depois');
      if (parseUser == null) {
        throw Exception('Current user not found');
      }

      log('Check if is a update address');
      if (address.id != null) {
        parseAddress.objectId = address.id;
      }

      log('preper parseAcl');
      final parseAcl = ParseACL(owner: parseUser);
      parseAcl.setPublicReadAccess(allowed: true);
      parseAcl.setPublicWriteAccess(allowed: false);

      log('parseAddress');
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

      log('parseAddress.save');
      final response = await parseAddress.save();
      if (!response.success) {
        log('parseAddress.save error');
        throw Exception(response.error.toString());
      }

      log('parseAddress.save success');
      return _parseServerToAddress(parseAddress);
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
          .map((parse) => _parseServerToAddress(parse as ParseObject))
          .toList();

      return addresses;
    } catch (err) {
      log(err.toString());
      throw Exception(err);
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
