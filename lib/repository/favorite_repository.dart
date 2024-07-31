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

import '../common/models/advert.dart';
import '../common/models/favorite.dart';
import 'parse_to_model.dart';

class FavoriteRepository {
  static Future<FavoriteModel?> add(int userId, AdvertModel ad) async {
    try {
      final parseFav = ParseObject(keyFavoriteTable);
      final parseAd = ParseObject(keyAdvertTable)..objectId = ad.id;

      parseFav
        ..set(keyFavoriteOwner, userId)
        ..set(keyFavoriteAd, parseAd.toPointer());

      final response = await parseFav.save();
      if (!response.success) {
        throw Exception(response.error?.message ?? 'unknown error');
      }
      return ParseToModel.favotire(parseFav);
    } catch (err) {
      final message = 'FavoriteRepository.add: $err';
      log(message);
      return null;
    }
  }

  static Future<void> delete(String favId) async {
    try {
      final parseFav = ParseObject(keyFavoriteTable)..objectId = favId;

      final response = await parseFav.delete();
      if (!response.success) {
        throw Exception(response.error?.message ?? 'unknown error');
      }
    } catch (err) {
      final message = 'FavoriteRepository.delete: $err';
      log(message);
      throw Exception(message);
    }
  }
}
