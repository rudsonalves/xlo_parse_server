// ignore_for_file: public_member_api_docs, sort_constructors_first
// Copyright (C) 2024 Rudson Alves
//
// This file is part of bgbazzar.
//
// bgbazzar is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// bgbazzar is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with bgbazzar.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/foundation.dart';

import '../../get_it.dart';
import '../../manager/address_manager.dart';
import '../../manager/favorites_manager.dart';
import '../../repository/parse_server/user_repository.dart';
import '../models/address.dart';
import '../models/user.dart';

class CurrentUser {
  CurrentUser();

  UserModel? _user;
  UserModel? get user => _user;

  final addressManager = getIt<AddressManager>();
  final favoritesManager = getIt<FavoritesManager>();

  List<AddressModel> get addresses => addressManager.addresses;
  Iterable<String> get addressNames => addressManager.addressNames;

  final _isLoged = ValueNotifier<bool>(false);

  String get userId => _user!.id!;
  ValueListenable<bool> get isLogedListernable => _isLoged;
  bool get isLogged => _isLoged.value;

  void dispose() {
    _isLoged.dispose();
  }

  Future<void> init([UserModel? user]) async {
    user ??= await UserRepository.getCurrentUser();
    if (user == null) return;
    await login(user);
  }

  Future<void> login(UserModel user) async {
    _user = user;
    _isLoged.value = true;
    await addressManager.login();
    await favoritesManager.login();
  }

  AddressModel? addressByName(String name) =>
      addressManager.getByUserName(name);

  Future<void> saveAddress(AddressModel address) async =>
      addressManager.save(address);

  Future<void> logout() async {
    await UserRepository.logout();
    addressManager.logout();
    favoritesManager.logout();
    _user = null;
    _isLoged.value = false;
  }
}
