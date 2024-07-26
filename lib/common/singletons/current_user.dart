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

import 'package:flutter/foundation.dart';

import '../../manager/address_manager.dart';
import '../../repository/user_repository.dart';
import '../models/address.dart';
import '../models/user.dart';

class CurrentUser {
  CurrentUser();

  UserModel? _user;
  UserModel? get user => _user;

  final addressManager = AddressManager.instance;

  List<AddressModel> get addresses => addressManager.addresses;
  Iterable<String> get addressNames => addressManager.addressNames;

  final _isLoged = ValueNotifier<bool>(false);

  String get userId => _user!.id!;
  ValueListenable<bool> get isLogedListernable => _isLoged;
  bool get isLoged => _isLoged.value;

  void dispose() {
    _isLoged.dispose();
  }

  Future<void> init([UserModel? user]) async {
    user ??= await UserRepository.getCurrentUser();
    if (user == null) return;

    _user = user;
    _isLoged.value = true;
    await addressManager.init(user.id!);
  }

  AddressModel? addressByName(String name) =>
      addressManager.getByUserName(name);

  Future<void> saveAddress(AddressModel address) async =>
      addressManager.save(address);

  Future<void> logout() async {
    await UserRepository.logout();
    _user = null;
    _isLoged.value = false;
  }
}
