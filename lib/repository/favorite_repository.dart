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

import '../common/models/advert.dart';
import '../common/models/favorite.dart';
import 'common/constants.dart';
import 'common/parse_to_model.dart';

class FavoriteRepository {
  static Future<FavoriteModel?> add(String userId, String adId) async {
    try {
      final parseFav = ParseObject(keyFavoriteTable);
      final parseAd = ParseObject(keyAdvertTable)..objectId = adId;

      parseFav
        ..set(keyFavoriteOwner, userId)
        ..set(keyFavoriteAd, parseAd.toPointer());

      final response = await parseFav.save();
      if (!response.success) {
        throw Exception(response.error?.message ?? 'unknown error');
      }

      if (response.results == null || response.results!.isEmpty) {
        throw Exception('No results returned from save operation');
      }

      final savedFav = response.results!.first as ParseObject;
      log('Saved Favorite: ${savedFav.get(keyFavoriteAd).runtimeType}');

      return ParseToModel.favorite(savedFav);
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

  static Future<(List<AdvertModel>, List<FavoriteModel>)> getFavorites(
      String userId) async {
    try {
      final parseFav = ParseObject(keyFavoriteTable);

      final query = QueryBuilder<ParseObject>(parseFav);

      query
        ..includeObject([keyFavoriteAd])
        ..includeObject([
          '$keyFavoriteAd.$keyAdvertOwner',
          '$keyFavoriteAd.$keyAdvertAddress',
          '$keyFavoriteAd.$keyAdvertMechanics',
        ])
        ..whereEqualTo(keyFavoriteOwner, userId);

      final response = await query.query();
      if (!response.success) {
        throw Exception(response.error?.message ?? 'unknow error!');
      }

      if (response.results == null) {
        throw Exception('return null');
      }

      List<AdvertModel> ads = [];
      List<FavoriteModel> favs = [];
      for (final ParseObject parseFav in response.results!) {
        final fav = ParseToModel.favorite(parseFav);
        final parseAd = parseFav.get(keyFavoriteAd) as ParseObject?;
        if (parseAd != null) {
          final adModel = ParseToModel.advert(parseAd);
          if (adModel != null) {
            ads.add(adModel);
            favs.add(fav);
          }
        }
      }
      return (ads, favs);
    } catch (err) {
      final message = 'FavoriteRepository.getAdsFavorites: $err';
      log(message);
      return (<AdvertModel>[], <FavoriteModel>[]);
    }
  }
}