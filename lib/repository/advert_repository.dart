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
import 'package:xlo_mobx/common/models/user.dart';

import '../common/models/advert.dart';
import '../common/models/filter.dart';
import 'constants.dart';
import 'parse_to_model.dart';

/// This class provides methods to interact with the Parse Server
/// to retrieve and save advertisements.
class AdvertRepository {
  static Future<bool> updateStatus(AdvertModel ad) async {
    try {
      final parse = ParseObject(keyAdvertTable)
        ..objectId = ad.id!
        ..set(keyAdvertStatus, ad.status.index);

      final response = await parse.update();

      if (!response.success) {
        throw Exception(response.error ?? 'update advert table error');
      }

      return true;
    } catch (err) {
      final message = 'AdvertRepository.getMyAds: $err';
      log(message);
      return false;
    }
  }

  /// Fetches a list of advertisements from an user.
  ///
  /// [user] - The user to apply to the search.
  /// Returns a list of `AdvertModel` if the query is successful, otherwise
  /// returns `null`.
  static Future<List<AdvertModel>?> getMyAds(UserModel usr, int status) async {
    try {
      final query = QueryBuilder<ParseObject>(ParseObject(keyAdvertTable));

      final parseUser = await ParseUser.currentUser() as ParseUser?;
      if (parseUser == null) {
        throw Exception('current user not found. Make login again.');
      }

      query
        ..setLimit(100)
        ..whereEqualTo(keyAdvertOwner, parseUser.toPointer())
        ..whereEqualTo(keyAdvertStatus, status)
        ..orderByDescending(keyAdvertCreatedAt)
        ..includeObject([keyAdvertOwner, keyAdvertAddress]);

      final response = await query.query();
      if (!response.success) {
        throw Exception(response.error.toString());
      }

      if (response.results == null) {
        throw Exception('search return a empty list');
      }

      List<AdvertModel> ads = [];
      for (final ParseObject p in response.results!) {
        final adModel = ParseToModel.advert(p);
        if (adModel != null) ads.add(adModel);
      }

      return ads;
    } catch (err) {
      final message = 'AdvertRepository.getMyAds: $err';
      log(message);
      return null;
    }
  }

  /// Fetches a list of advertisements from the Parse Server based on the
  /// provided filters and search string.
  ///
  /// [filter] - The filter model to apply to the search.
  /// [search] - The search string to filter advertisements by title.
  /// [page] - The page number to retrieve, used for pagination.
  /// Returns a list of `AdvertModel` if the query is successful, otherwise
  /// returns `null`.
  static Future<List<AdvertModel>?> get({
    required FilterModel filter,
    required String search,
    int page = 0,
  }) async {
    final query = QueryBuilder<ParseObject>(ParseObject(keyAdvertTable));

    try {
      query.setAmountToSkip(page * maxAdsPerList);
      query.setLimit(maxAdsPerList);

      query.includeObject([keyAdvertOwner, keyAdvertAddress]);

      query.whereEqualTo(keyAdvertStatus, AdvertStatus.active.index);

      // Filter by search String
      if (search.trim().isNotEmpty) {
        query.whereContains(
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
          query.whereEqualTo(keyAdvertMechanics, mechParse.toPointer());
        }
      }

      switch (filter.sortBy) {
        case SortOrder.price:
          // Filter by price
          query.orderByAscending(keyAdvertPrice);
          break;
        case SortOrder.date:
        default:
          // Filter by date
          query.orderByDescending(keyAdvertCreatedAt);
      }

      // Filter minPrice
      if (filter.minPrice > 0) {
        query.whereGreaterThanOrEqualsTo(keyAdvertPrice, filter.minPrice);
      }

      // Filter maxPrice
      if (filter.maxPrice > 0) {
        query.whereLessThanOrEqualTo(keyAdvertPrice, filter.maxPrice);
      }

      // Filter by product condition
      if (filter.condition != ProductCondition.all) {
        query.whereEqualTo(keyAdvertCondition, filter.condition.index);
      }

      final response = await query.query();
      if (!response.success) {
        throw Exception(response.error.toString());
      }

      if (response.results == null) {
        throw Exception('search return a empty list');
      }

      List<AdvertModel> ads = [];
      for (final ParseObject ad in response.results!) {
        final adModel = ParseToModel.advert(ad);
        if (adModel != null) ads.add(adModel);
      }

      return ads;
    } catch (err) {
      final message = 'AdvertRepository.get: $err';
      log(message);
      return null;
    }
  }

  /// Saves an advertisement to the Parse Server.
  ///
  /// [advert] - The advertisement model to save.
  /// Returns the saved `AdvertModel` if successful, otherwise throws an
  /// exception.
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
      final message = 'AdvertRepository.save: $err';
      log(message);
      throw Exception(message);
    }
  }

  static Future<AdvertModel?> update(AdvertModel advert) async {
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

      if (advert.id == null) {
        throw Exception('Advert ID cannot be null for update');
      }

      final parseAd = ParseObject(keyAdvertTable)..objectId = advert.id!;

      parseAd
        ..set<String>(keyAdvertTitle, advert.title)
        ..set<String>(keyAdvertDescription, advert.description)
        ..set<bool>(keyAdvertHidePhone, advert.hidePhone)
        ..set<double>(keyAdvertPrice, advert.price)
        ..set<int>(keyAdvertStatus, advert.status.index)
        ..set<int>(keyAdvertCondition, advert.condition.index)
        ..set<ParseObject>(keyAdvertAddress, parseAddress)
        ..set<List<ParseFile>>(keyAdvertImages, parseImages)
        ..set<List<ParseObject>>(keyAdvertMechanics, parseMechanics);

      final response = await parseAd.update();
      if (!response.success) {
        if (response.count > 0) {
          for (final item in response.results!) {
            log('>> ${item.toString()}');
          }
        } else {
          log('parseAd.update error: ${response.error?.message}');
        }
        throw Exception(response.error);
      }

      return advert;
    } catch (err) {
      final message = 'AdvertRepository.update: $err';
      log(message);
      throw Exception(message);
    }
  }

  /// Saves the images to the Parse Server.
  ///
  /// [imagesPaths] - The list of image paths to save.
  /// [parseUser] - The current Parse user.
  /// Returns a list of `ParseFile` representing the saved images.
  /// Throws an exception if the save operation fails.
  static Future<List<ParseFile>> _saveImages(
    List<String> imagesPaths,
    ParseUser parseUser,
  ) async {
    final parseImages = <ParseFile>[];

    try {
      for (final path in imagesPaths) {
        if (!path.contains(RegExp(r'http'))) {
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
            throw Exception('failed to get URL after saving the file');
          }

          parseImages.add(parseFile);
        } else {
          final parseFile = ParseFile(null, name: basename(path), url: path);
          parseImages.add(parseFile);
        }
      }

      return parseImages;
    } catch (err) {
      log('exception in _saveImages: $err');
      throw Exception(err);
    }
  }

  static Future<void> delete(AdvertModel ad) async {
    try {
      final parse = ParseObject(keyAdvertTable)..objectId = ad.id;

      final response = await parse.delete();
      if (!response.success) {
        throw Exception(response.error ?? 'delete advert table error');
      }
      return;
    } catch (err) {
      final message = 'AdvertRepository.delete: $err';
      log(message);
    }
  }
}
