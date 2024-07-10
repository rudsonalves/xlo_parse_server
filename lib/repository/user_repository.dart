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

import '../common/models/user.dart';
import 'constants.dart';

class UserRepository {
  static Future<User> signUp(User user) async {
    final parserUser = ParseUser(user.email, user.password, user.email);

    parserUser.set<String>(keyUserName, user.name);
    parserUser.set<String>(keyUserPhone, user.phone);
    parserUser.set<int>(keyUserType, user.type.index);

    final response = await parserUser.signUp();
    if (!response.success) {
      throw Exception('${response.error!.code}: ${response.error!.message}');
    }

    user.id = parserUser.objectId;
    user.createAt = parserUser.createdAt;
    return user;
  }
}
