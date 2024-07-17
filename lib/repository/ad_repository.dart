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

import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../common/models/ad_sale.dart';
import 'constants.dart';

class AdvertRepository {
  static Future<AdSaleModel> save(AdSaleModel ad) async {
    final parseImages = await _saveImages(ad.images);

    final parseUser = await ParseUser.currentUser() as ParseUser?;
    if (parseUser == null) {
      throw Exception('Current user access error');
    }

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
      ..set<String>(keyAdImages, ad.images.toString())
      ..set<String>(keyAdTitle, ad.title)
      ..set<String>(keyAdDescription, ad.description)
      ..set<String>(keyAdMechanics, ad.mechanicsId.toString())
      ..set<ParseObject>(keyAdAddress, parseAddress)
      ..set<String>(keyAdPrice, ad.price)
      ..set<bool>(keyAdHidePhone, ad.hidePhone)
      ..set<String>(keyAdStatus, ad.status.name)
      ..set<int>(keyAdViews, ad.views)
      ..set<List<ParseFile>>(keyAdImages, parseImages)
      ..set<List<ParseObject>>(keyAdMechanics, parseMechanics);

    final response = await parseAd.save();
    if (!response.success) {
      throw Exception(response.error);
    }

    return _parserServerToAdSale(parseAd);
  }

  static Future<List<ParseFile>> _saveImages(List<dynamic> images) async {
    final parseImages = <ParseFile>[];

    try {
      for (final image in images) {
        if (image is File) {
          final parseFile = ParseFile(image, name: path.basename(image.path));
          final response = await parseFile.save();
          if (!response.success) {
            throw Exception(response.error);
          }
          parseImages.add(parseFile);
        } else {
          final parseFile = ParseFile(null);
          parseFile.name = path.basename(image);
          parseFile.url = image;
          parseImages.add(parseFile);
        }
      }

      return parseImages;
    } catch (err) {
      throw Exception(err);
    }
  }

  static AdSaleModel _parserServerToAdSale(ParseObject parseAd) {
    return AdSaleModel(
      userId: 'userId',
      images: ['images'],
      title: 'title',
      description: 'description',
      mechanicsId: ['mechanics'],
      addressId: 'address',
      price: 'price',
      hidePhone: false,
    );
  }
}
