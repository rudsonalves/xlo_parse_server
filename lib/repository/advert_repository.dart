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
import 'constants.dart';

class AdvertRepository {
  static Future<AdvertModel?> save(AdvertModel ad) async {
    List<ParseFile> parseImages = [];

    try {
      final parseUser = await ParseUser.currentUser() as ParseUser?;
      if (parseUser == null) {
        throw Exception('Current user access error');
      }

      parseImages = await _saveImages(ad.images, parseUser);

      final List<ParseObject> parseMechanics = ad.mechanicsId
          .map<ParseObject>(
            (id) => ParseObject(keyMechanicTable)..set(keyMechanicId, id),
          )
          .toList();

      final parseAddress = ParseObject(keyAddressTable)
        ..set(keyAdAddress, ad.addressId);

      final parseAd = ParseObject(keyAdTable);
      if (ad.id != null) {
        parseAd.objectId = ad.id;
      }

      final parseAcl = ParseACL(owner: parseUser);
      parseAcl.setPublicReadAccess(allowed: true);
      parseAcl.setPublicWriteAccess(allowed: false);

      parseAd
        ..setACL(parseAcl)
        ..set<ParseUser>(keyAdOwner, parseUser)
        ..set<List<ParseFile>>(keyAdImages, parseImages)
        ..set<String>(keyAdTitle, ad.title)
        ..set<String>(keyAdDescription, ad.description)
        ..set<bool>(keyAdHidePhone, ad.hidePhone)
        ..set<double>(keyAdPrice, ad.price)
        ..set<String>(keyAdStatus, ad.status.name)
        ..set<List<ParseObject>>(keyAdMechanics, parseMechanics)
        ..set<ParseObject>(keyAdAddress, parseAddress);
      // ..set<int>(keyAdViews, ad.views);

      final response = await parseAd.save();
      if (!response.success) {
        throw Exception(response.error);
      }

      return _parserServerToAdSale(parseAd);
    } catch (err) {
      await _deleteOrphanImages(parseImages);
      log(err.toString());
      return null;
    }
  }

  static Future<void> _deleteOrphanImages(List<ParseFile> images) async {
    for (final image in images) {
      try {
        final parseFile = ParseFile(null, name: image.name, url: image.url);
        log('Attempting to delete file with URL: ${parseFile.url} and name: ${parseFile.name}');

        final response = await parseFile.delete();
        if (!response.success) {
          throw Exception('Failed to delete image: ${response.error}');
        }
      } catch (err) {
        log('Failed to delete image: ${image.url}');
        log(err.toString());
      }
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
          log('ParseFile save response: ${response.results}');
          if (!response.success) {
            log('Error saving file: ${response.error}');
            throw Exception(response.error);
          }

          log('Saved file URL: ${parseFile.url}');
          log('Saved file name: ${parseFile.name}');

          if (parseFile.url == null) {
            const message = 'Failed to get URL after saving the file';
            log(message);
            throw Exception(message);
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
      userId: parseAd.get<ParseUser>(keyAdOwner)!.objectId!,
      images: parseAd
          .get<List<ParseFile>>(keyAdImages)!
          .map((item) => item.url!)
          .toList(),
      title: parseAd.get<String>(keyAdTitle)!,
      description: parseAd.get<String>(keyAdDescription)!,
      mechanicsId: parseAd
          .get<List<ParseObject>>(keyAdMechanics)!
          .map((item) => item.objectId!)
          .toList(),
      addressId: parseAd.get<ParseObject>(keyAdAddress)!.objectId!,
      price: parseAd.get<double>(keyAdPrice)!,
      hidePhone: parseAd.get<bool>(keyAdHidePhone)!,
      status: AdStatus.values
          .firstWhere((s) => s.name == parseAd.get<String>(keyAdStatus)!),
    );
  }
}
