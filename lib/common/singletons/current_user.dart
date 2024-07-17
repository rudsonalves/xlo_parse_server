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

import '../../repository/address_repository.dart';
import '../../repository/user_repository.dart';
import '../models/address.dart';
import '../models/user.dart';

class CurrentUser {
  CurrentUser._();
  static final CurrentUser _instance = CurrentUser._();
  static CurrentUser get instance => _instance;

  UserModel? _user;
  UserModel? get user => _user;

  final Map<String, AddressModel> _addresses = {};
  Map<String, AddressModel> get addresses => _addresses;

  String get userId => _user!.id!;
  bool get isLogin => _user != null;

  Future<void> init([UserModel? user]) async {
    user ??= await UserRepository.getCurrentUser();
    if (user == null) return;

    _user = user;
    await _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    _user = user;
    final addressesList = await AddressRepository.getUserAddresses(user!.id!);

    _addresses.clear();
    _addresses.addEntries(
      addressesList.map(
        (address) => MapEntry(address.name, address),
      ),
    );
  }
}
