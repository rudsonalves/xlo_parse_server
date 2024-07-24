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
import 'dart:io';

import 'package:path/path.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../common/models/advert.dart';
import '../common/models/filter.dart';
import 'constants.dart';
import 'parse_to_model.dart';

class AdvertRepository {
  static const maxAdsPerList = 20;

  static Future<List<AdvertModel>?> getAdvertisements({
    required FilterModel filter,
    required String search,
    int page = 0,
  }) async {
    final queryBuilder = QueryBuilder<ParseObject>(ParseObject(keyAdvertTable));

    try {
      queryBuilder.setAmountToSkip(page * maxAdsPerList);
      queryBuilder.setLimit(maxAdsPerList);

      queryBuilder.includeObject([keyAdvertOwner, keyAdvertAddress]);

      queryBuilder.whereEqualTo(keyAdvertStatus, AdvertStatus.active.index);

      // Filter by search String
      if (search.trim().isNotEmpty) {
        queryBuilder.whereContains(
          keyAdvertTitle,
          search.trim(),
          caseSensitive: false,
        );
      }

      // Filter by machanics
      if (filter.mechanicsId.isNotEmpty) {
        for (final mechId in filter.mechanicsId) {
          final mechParse = ParseObject(keyMechanicTable)
            ..set(keyMechanicId, mechId);
          queryBuilder.whereEqualTo(keyAdvertMechanics, mechParse.toPointer());
        }
      }

      switch (filter.sortBy) {
        case SortOrder.price:
          // Filter by price
          queryBuilder.orderByAscending(keyAdvertPrice);
          break;
        case SortOrder.date:
        default:
          // Filter by date
          queryBuilder.orderByAscending(keyAdvertCreatedAt);
      }

      // Filter minPrice
      if (filter.minPrice > 0) {
        queryBuilder.whereGreaterThanOrEqualsTo(
            keyAdvertPrice, filter.minPrice);
      }

      // Filter maxPrice
      if (filter.maxPrice > 0) {
        queryBuilder.whereLessThanOrEqualTo(keyAdvertPrice, filter.maxPrice);
      }

      // Filter by
      if (filter.condition != ProductCondition.all) {
        queryBuilder.whereEqualTo(keyAdvertCondition, filter.condition.index);
      }

      final response = await queryBuilder.query();
      if (!response.success) {
        throw Exception(response.error.toString());
      }

      if (response.results == null) {
        throw Exception('Search return a empty list');
      }

      List<AdvertModel> ads = [];
      for (final ParseObject ad in response.results!) {
        final adModel = ParseToModel.advert(ad);
        if (adModel != null) ads.add(adModel);
      }

      return ads;
    } catch (err) {
      log('AdvertRepository.getAdvertisements: $err');
      return null;
    }
  }

  static Future<AdvertModel?> save(AdvertModel advert) async {
    try {
      final parseUser = await ParseUser.currentUser() as ParseUser?;
      if (parseUser == null) {
        throw Exception('Current user access error');
      }

      List<ParseFile> parseImages = await _saveImages(advert.images, parseUser);

      final List<ParseObject> parseMechanics = advert.mechanicsId.map((id) {
        final parse = ParseObject(keyMechanicTable);
        parse.objectId = id;
        return parse;
      }).toList();

      final parseAddress = ParseObject(keyAddressTable);
      parseAddress.objectId = advert.address.id;

      final parseAd = ParseObject(keyAdvertTable);
      if (advert.id != null) {
        parseAd.objectId = advert.id;
      }

      final parseAcl = ParseACL(owner: parseUser);
      parseAcl.setPublicReadAccess(allowed: true);
      parseAcl.setPublicWriteAccess(allowed: false);

      parseAd
        ..setACL(parseAcl)
        ..set<ParseUser>(keyAdvertOwner, parseUser)
        ..set<String>(keyAdvertTitle, advert.title)
        ..set<String>(keyAdvertDescription, advert.description)
        ..set<bool>(keyAdvertHidePhone, advert.hidePhone)
        ..set<double>(keyAdvertPrice, advert.price)
        ..set<int>(keyAdvertStatus, advert.status.index)
        ..set<int>(keyAdvertCondition, advert.condition.index)
        ..set<ParseObject>(keyAdvertAddress, parseAddress)
        ..set<List<ParseFile>>(keyAdvertImages, parseImages)
        ..set<List<ParseObject>>(keyAdvertMechanics, parseMechanics);

      final response = await parseAd.save();
      if (!response.success) {
        if (response.count > 0) {
          for (final item in response.results!) {
            log('>> ${item.toString()}');
          }
        } else {
          log('parseAd.save error: ${response.error?.message}');
        }
        throw Exception(response.error);
      }

      return ParseToModel.advert(parseAd);
    } catch (err) {
      log(err.toString());
      return null;
    }
  }

  static Future<List<ParseFile>> _saveImages(
    List<String> imagesPaths,
    ParseUser parseUser,
  ) async {
    final parseImages = <ParseFile>[];

    try {
      for (final path in imagesPaths) {
        if (!path.contains('://')) {
          final file = File(path);
          final parseFile = ParseFile(file, name: basename(path));

          final acl = ParseACL(owner: parseUser);
          acl.setPublicReadAccess(allowed: true);
          acl.setPublicWriteAccess(allowed: false);

          parseFile.setACL(acl);

          final response = await parseFile.save();
          if (!response.success) {
            log('Error saving file: ${response.error}');
            throw Exception(response.error);
          }

          if (parseFile.url == null) {
            throw Exception('Failed to get URL after saving the file');
          }

          parseImages.add(parseFile);
        } else {
          final parseFile = ParseFile(null, name: basename(path), url: path);
          parseImages.add(parseFile);
        }
      }

      return parseImages;
    } catch (err) {
      log('Exception in _saveImages: $err');
      throw Exception(err);
    }
  }
}
