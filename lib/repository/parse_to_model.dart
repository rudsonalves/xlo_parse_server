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

import '../common/models/address.dart';
import '../common/models/advert.dart';
import '../common/models/mechanic.dart';
import '../common/models/user.dart';
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

  /// Converts a ParseObject representing an advertisement to an AdvertModel.
  ///
  /// [parse] - The ParseObject to convert.
  /// Returns an AdvertModel representing the ParseObject if the address and
  /// user are not null, otherwise returns null.
  static AdvertModel? advert(ParseObject parse) {
    final parseAddress = parse.get<ParseObject?>(keyAdvertAddress);
    if (parseAddress == null) return null;
    AddressModel? address = ParseToModel.address(parseAddress);

    final parseUser = parse.get<ParseUser?>(keyAdvertOwner);
    if (parseUser == null) return null;
    final user = ParseToModel.user(parseUser);

    return AdvertModel(
      id: parse.objectId,
      owner: user,
      title: parse.get<String>(keyAdvertTitle)!,
      description: parse.get<String>(keyAdvertDescription)!,
      price: parse.get<num>(keyAdvertPrice)!.toDouble(),
      hidePhone: parse.get<bool>(keyAdvertHidePhone)!,
      images: (parse.get<List<dynamic>>(keyAdvertImages) as List<dynamic>)
          .map((item) => (item as ParseFile).url!)
          .toList(),
      mechanicsId:
          (parse.get<List<dynamic>>(keyAdvertMechanics) as List<dynamic>)
              .map((item) => (item as ParseObject).objectId!)
              .toList(),
      address: address,
      status: AdvertStatus.values
          .firstWhere((s) => s.index == parse.get<int>(keyAdvertStatus)!),
      condition: ProductCondition.values
          .firstWhere((c) => c.index == parse.get<int>(keyAdvertCondition)!),
      views: parse.get<int>(keyAdvertViews, defaultValue: 0)!,
      createdAt: parse.get<DateTime>(keyAdvertCreatedAt)!,
    );
  }

  /// Converts a ParseObject representing a mechanic to a MechanicModel.
  ///
  /// [parse] - The ParseObject to convert.
  /// Returns a MechanicModel representing the ParseObject.
  static mechanic(ParseObject parse) {
    return MechanicModel(
      id: parse.objectId,
      name: parse.get(keyMechanicName),
      description: parse.get(keyMechanicDescription),
      createAt: parse.createdAt,
    );
  }
}
