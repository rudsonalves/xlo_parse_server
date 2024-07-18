// ignore_for_file: public_member_api_docs, sort_constructors_first
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

import '../common/models/address.dart';
import '../repository/address_repository.dart';

class DuplicateNameException implements Exception {
  DuplicateNameException();

  @override
  String toString() =>
      'This address can\'t be updated because it has a duplicate name.';
}

class AddressManager {
  AddressManager._();
  static final _instance = AddressManager._();
  static AddressManager get instance => _instance;

  final List<AddressModel> _addresses = [];
  List<AddressModel> get addresses => _addresses;
  Iterable<String> get addressNames => _addresses.map((e) => e.name);

  Future<void> init(String userId) async {
    await getUserAddresses(userId);
  }

  Future<void> getUserAddresses(String userId) async {
    _addresses.clear();
    final addrs = await AddressRepository.getUserAddresses(userId);
    if (addrs != null && addrs.isNotEmpty) {
      _addresses.addAll(addrs);
    }
  }

  Future<void> deleteAddress(String name) async {
    final index = _indexWhereName(name);
    if (index != -1) {
      final address = _addresses[index];
      await AddressRepository.delete(address);
      _addresses.removeAt(index);
    }
  }

  Future<void> saveAddress(AddressModel address) async {
    final index = _indexWhereName(address.name);
    if (address.id != null && index == -1) {
      // is update
      _addresses[_indexWhereId(address.id!)] = address;
    } else if (address.id == null && index != -1) {
      // is update with renamed
      address.id = _addresses[index].id;
      _addresses[_indexWhereId(address.id!)] = address;
    } else if (address.id != null && index != -1) {
      if (address.id != _addresses[index].id) {
        throw DuplicateNameException();
      } else {
        // is update
        _addresses[_indexWhereId(address.id!)] = address;
      }
    }

    final savedAddress = await AddressRepository.save(address);
    if (address.id == null) {
      _addresses.add(savedAddress!);
    }
  }

  AddressModel? addressByName(String name) {
    final index = _indexWhereName(name);
    return index != -1 ? _addresses[index] : null;
  }

  int _indexWhereName(String name) {
    return _addresses.indexWhere(
      (addr) => addr.name == name,
    );
  }

  int _indexWhereId(String id) {
    return _addresses.indexWhere(
      (addr) => addr.id == id,
    );
  }
}