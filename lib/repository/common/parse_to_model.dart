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

import '../../common/models/address.dart';
import '../../common/models/ad.dart';
import '../../common/models/favorite.dart';
import '../../common/models/user.dart';
import 'constants.dart';

/// This class provides static methods to convert Parse objects to application
/// models.
class ParseToModel {
  ParseToModel._();

  /// Converts a ParseUser object to a UserModel.
  ///
  /// [parse] - The ParseUser object to convert.
  /// Returns a UserModel representing the ParseUser.
  static UserModel user(ParseUser parse) {
    return UserModel(
      id: parse.objectId,
      name: parse.get<String>(keyUserNickname),
      email: parse.username!,
      phone: parse.get<String>(keyUserPhone),
      createdAt: parse.createdAt,
    );
  }

  /// Converts a ParseObject representing an address to an AddressModel.
  ///
  /// [parse] - The ParseObject to convert.
  /// Returns an AddressModel representing the ParseObject.
  static AddressModel address(ParseObject parse) {
    return AddressModel(
      id: parse.objectId,
      name: parse.get<String>(keyAddressName)!,
      zipCode: parse.get<String>(keyAddressZipCode)!,
      userId: parse.get<ParseUser>(keyAddressOwner)!.objectId!,
      street: parse.get<String>(keyAddressStreet)!,
      number: parse.get<String>(keyAddressNumber)!,
      complement: parse.get<String?>(keyAddressComplement),
      neighborhood: parse.get<String>(keyAddressNeighborhood)!,
      state: parse.get<String>(keyAddressState)!,
      city: parse.get<String>(keyAddressCity)!,
      createdAt: parse.get<DateTime>(keyAddressCreatedAt)!,
    );
  }

  /// Converts a ParseObject representing an advertisement to an AdModel.
  ///
  /// [parse] - The ParseObject to convert.
  /// Returns an AdModel representing the ParseObject if the address and
  /// user are not null, otherwise returns null.
  static AdModel? ad(ParseObject parse) {
    final parseAddress = parse.get<ParseObject?>(keyAdAddress);
    if (parseAddress == null) return null;
    AddressModel? address = ParseToModel.address(parseAddress);

    final parseUser = parse.get<ParseUser?>(keyAdOwner);
    if (parseUser == null) return null;
    final user = ParseToModel.user(parseUser);

    final mechs = parse.get<List<dynamic>>(keyAdMechanics) ?? [];

    return AdModel(
      id: parse.objectId,
      owner: user,
      title: parse.get<String>(keyAdTitle)!,
      bggId: parse.get<int?>(keyAdBggId)!,
      description: parse.get<String>(keyAdDescription)!,
      price: parse.get<num>(keyAdPrice)!.toDouble(),
      hidePhone: parse.get<bool>(keyAdHidePhone)!,
      images: (parse.get<List<dynamic>>(keyAdImages) as List<dynamic>)
          .map((item) => (item as ParseFile).url!)
          .toList(),
      mechanicsId: mechs.map((e) => e as int).toList(),
      address: address,
      status: AdStatus.values
          .firstWhere((s) => s.index == parse.get<int>(keyAdStatus)!),
      condition: ProductCondition.values
          .firstWhere((c) => c.index == parse.get<int>(keyAdCondition)!),
      views: parse.get<int>(keyAdViews, defaultValue: 0)!,
      createdAt: parse.get<DateTime>(keyAdCreatedAt)!,
    );
  }

  static FavoriteModel favorite(ParseObject parse) {
    final adMap = parse.get(keyFavoriteAd);

    return FavoriteModel(
      id: parse.objectId,
      adId: adMap['objectId'],
    );
  }
}
