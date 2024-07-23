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
  static Future<UserModel> signUp(UserModel user) async {
    final parseUser = ParseUser(user.email, user.password, user.email);

    parseUser.set<String>(keyUserName, user.email);
    parseUser.set<String>(keyUserNickname, user.name!);
    parseUser.set<String>(keyUserPhone, user.phone!);
    // parseUser.set<int>(keyUserType, user.type.index);

    final response = await parseUser.signUp();
    if (!response.success) {
      throw Exception(response.error);
    }

    final newUser = _parseServerToUser(parseUser);

    parseUser.logout();

    return newUser;
  }

  static Future<UserModel> loginWithEmail(UserModel user) async {
    final parseUser = ParseUser(user.email, user.password, null);

    final response = await parseUser.login();

    if (!response.success) {
      throw Exception(response.error);
    }

    return _parseServerToUser(parseUser);
  }

  static Future<UserModel?> getCurrentUser() async {
    ParseUser? parseCurrentUser = await ParseUser.currentUser() as ParseUser?;
    if (parseCurrentUser == null) return null;

    // Checks whether the user's session token is valid
    final parseResponse = await ParseUser.getCurrentUserFromServer(
        parseCurrentUser.sessionToken!);

    if (parseResponse != null && parseResponse.success) {
      return _parseServerToUser(parseCurrentUser);
    } else {
      // Invalid session. Logout
      await parseCurrentUser.logout();
      return null;
    }
  }

  static UserModel _parseServerToUser(ParseUser parseUser) {
    return UserModel(
      id: parseUser.objectId,
      name: parseUser.get<String>(keyUserNickname),
      email: parseUser.username!,
      phone: parseUser.get<String>(keyUserPhone),
      // type: UserType.values[parseUser.get(keyUserType)],
      createdAt: parseUser.createdAt,
    );
  }
}
