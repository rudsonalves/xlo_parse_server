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

import 'package:flutter/material.dart';

import '../../common/models/address.dart';
import '../../get_it.dart';
import '../../manager/address_manager.dart';

class AddressController extends ChangeNotifier {
  final addressManager = getIt<AddressManager>();
  List<AddressModel> get addresses => addressManager.addresses;
  List<String> get addressNames => addressManager.addressNames.toList();

  final _selectedAddressName = ValueNotifier<String>('');
  ValueNotifier<String> get selectedAddressName => _selectedAddressName;

  Future<void> init() async {}

  @override
  void dispose() {
    _selectedAddressName.dispose();
    super.dispose();
  }

  void selectAddress(String name) {
    if (addressNames.contains(name)) {
      _selectedAddressName.value = name;
    }
  }

  Future<void> removeAddress() async {
    final name = _selectedAddressName.value;
    if (name.isNotEmpty &&
        addressNames.isNotEmpty &&
        addressNames.contains(name)) {
      await addressManager.delete(name);
      _selectedAddressName.value = '';
    }
  }
}
