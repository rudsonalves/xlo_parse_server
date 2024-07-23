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

class AdvertRepository {
  static Future<List<AdvertModel>?> getAdvertisements({
    required FilterModel? filter,
    required String? search,
  }) async {
    search = search ?? '';
    filter = filter ?? FilterModel();
    final queryBuilder = QueryBuilder<ParseObject>(ParseObject(keyAdvertTable));

    queryBuilder.setLimit(20);
    queryBuilder.whereEqualTo(keyAdvertStatus, AdvertStatus.pending.index);

    // Filter by search String
    if (search.trim().isEmpty) {
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
      queryBuilder.whereGreaterThanOrEqualsTo(keyAdvertPrice, filter.minPrice);
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
      log(response.error.toString());
      return null;
    }

    if (response.results == null) {
      log('Search return a empty list');
      return null;
    }

    return response.results!
        .map((ad) => _parserServerToAdSale(ad as ParseObject))
        .toList();
  }

  static Future<AdvertModel?> save(AdvertModel advert) async {
    List<ParseFile> parseImages = [];

    try {
      final parseUser = await ParseUser.currentUser() as ParseUser?;
      if (parseUser == null) {
        throw Exception('Current user access error');
      }

      parseImages = await _saveImages(advert.images, parseUser);

      final List<ParseObject> parseMechanics = advert.mechanicsId.map((id) {
        final parse = ParseObject(keyMechanicTable);
        parse.objectId = id;
        return parse;
      }).toList();

      final parseAddress = ParseObject(keyAddressTable);
      parseAddress.objectId = advert.addressId;

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

      return _parserServerToAdSale(parseAd);
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

  static AdvertModel _parserServerToAdSale(ParseObject parseAd) {
    return AdvertModel(
      id: parseAd.objectId,
      userId: parseAd.get<ParseUser>(keyAdvertOwner)!.objectId!,
      images: (parseAd.get<List<dynamic>>(keyAdvertImages) as List<dynamic>)
          .map((item) => (item as ParseFile).url!)
          .toList(),
      title: parseAd.get<String>(keyAdvertTitle)!,
      description: parseAd.get<String>(keyAdvertDescription)!,
      mechanicsId:
          (parseAd.get<List<dynamic>>(keyAdvertMechanics) as List<dynamic>)
              .map((item) => (item as ParseObject).objectId!)
              .toList(),
      addressId: parseAd.get<ParseObject>(keyAdvertAddress)!.objectId!,
      price: parseAd.get<num>(keyAdvertPrice)!.toDouble(),
      hidePhone: parseAd.get<bool>(keyAdvertHidePhone)!,
      status: AdvertStatus.values
          .firstWhere((s) => s.index == parseAd.get<int>(keyAdvertStatus)!),
      condition: ProductCondition.values
          .firstWhere((c) => c.index == parseAd.get<int>(keyAdvertCondition)),
    );
  }
}
