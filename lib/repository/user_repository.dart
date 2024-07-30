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

import '../common/models/user.dart';
import 'constants.dart';
import 'parse_to_model.dart';

/// This class manages user-related operations in the Parse Server,
/// such as signing up, logging in, logging out, and getting the current user.
class UserRepository {
  /// Signs up a new user in the Parse Server.
  ///
  /// [user] - A `UserModel` containing the user details for signing up.
  /// Returns a `UserModel` representing the newly created user if the signup
  /// is successful, otherwise returns `null`.
  static Future<UserModel> signUp(UserModel user) async {
    try {
      final parseUser = ParseUser(user.email, user.password, user.email);

      parseUser
        ..set<String>(keyUserName, user.email)
        ..set<String>(keyUserNickname, user.name!)
        ..set<String>(keyUserPhone, user.phone!);

      final response = await parseUser.signUp();
      if (!response.success) {
        throw Exception(response.error?.message ?? 'unknown error');
      }

      final newUser = ParseToModel.user(parseUser);

      parseUser.logout();

      return newUser;
    } catch (err) {
      final message = 'UserRepository.signUp: $err';
      log(message);
      throw Exception(message);
    }
  }

  /// Logs in a user with email and password.
  ///
  /// [user] - A `UserModel` containing the user details for login.
  /// Returns a `UserModel` representing the logged-in user if the login
  /// is successful, otherwise returns create an error.
  static Future<UserModel> loginWithEmail(UserModel user) async {
    try {
      final parseUser = ParseUser(user.email, user.password, null);

      final response = await parseUser.login();

      if (!response.success) {
        throw Exception(response.error?.message ?? 'unknown error');
      }

      await _checksPermissions(parseUser);
      return ParseToModel.user(parseUser);
    } catch (err) {
      final message = 'UserRepository.loginWithEmail: $err';
      log(message);
      throw Exception(message);
    }
  }

  /// Logs out the current user.
  static Future<void> logout() async {
    try {
      final user = await ParseUser.currentUser() as ParseUser;
      user.logout();
    } catch (err) {
      log('UserRepository.loginWithEmail: $err');
    }
  }

  /// Gets the current logged-in user.
  ///
  /// Returns a `UserModel` representing the current user if the session token
  /// is valid, otherwise returns `null`.
  static Future<UserModel?> getCurrentUser() async {
    try {
      ParseUser? parseCurrentUser = await ParseUser.currentUser() as ParseUser?;
      if (parseCurrentUser == null) {
        throw Exception('user token is invalid');
      }

      // Checks whether the user's session token is valid
      final response = await ParseUser.getCurrentUserFromServer(
          parseCurrentUser.sessionToken!);

      if (response != null && response.success) {
        await _checksPermissions(response.result as ParseUser);
        return ParseToModel.user(parseCurrentUser);
      } else {
        // Invalid session. Logout
        await parseCurrentUser.logout();
        throw Exception(response?.error.toString() ?? 'unknown error');
      }
    } catch (err) {
      log('UserRepository.getCurrentUser: $err');
      return null;
    }
  }

  static Future<void> _checksPermissions(ParseUser parseUser) async {
    final parseAcl = parseUser.getACL();
    if (parseAcl.getPublicReadAccess() == true) return;

    parseAcl.setPublicReadAccess(allowed: true);
    parseAcl.setPublicWriteAccess(allowed: false);

    parseUser.setACL(parseAcl);
    final aclResponse = await parseUser.save();
    if (!aclResponse.success) {
      throw Exception(
          'error setting ACL permissions: ${aclResponse.error?.message ?? 'unknown error'}');
    }
  }

  static Future<void> update(UserModel user) async {
    try {
      final parseUser = ParseUser(null, null, null)..objectId = user.id;

      if (user.name != null) {
        parseUser.set(keyUserNickname, user.name);
      }

      if (user.phone != null) {
        parseUser.set(keyUserPhone, user.phone);
      }

      if (user.password != null) {
        parseUser.set(keyUserPassword, user.password);
      }

      final response = await parseUser.update();

      if (!response.success) {
        throw Exception(response.error.toString());
      }
    } catch (err) {
      log('UserRepository.update: $err');
    }
  }
}
