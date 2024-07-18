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

import '../../manager/address_manager.dart';
import '../../repository/user_repository.dart';
import '../models/address.dart';
import '../models/user.dart';

class CurrentUser {
  CurrentUser._();
  static final CurrentUser _instance = CurrentUser._();
  static CurrentUser get instance => _instance;

  UserModel? _user;
  UserModel? get user => _user;

  final addressManager = AddressManager.instance;

  List<AddressModel> get addresses => addressManager.addresses;
  Iterable<String> get addressNames => addressManager.addressNames;

  String get userId => _user!.id!;
  bool get isLogin => _user != null;

  Future<void> init([UserModel? user]) async {
    user ??= await UserRepository.getCurrentUser();
    if (user == null) return;

    _user = user;
    await addressManager.init(user.id!);
  }

  AddressModel? addressByName(String name) =>
      addressManager.addressByName(name);

  Future<void> saveAddress(AddressModel address) async =>
      addressManager.saveAddress(address);
}
