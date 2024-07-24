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
import '../common/models/user.dart';
import 'constants.dart';

class ParseToModel {
  ParseToModel._();

  static UserModel user(ParseUser parseUser) {
    return UserModel(
      id: parseUser.objectId,
      name: parseUser.get<String>(keyUserNickname),
      email: parseUser.username!,
      phone: parseUser.get<String>(keyUserPhone),
      createdAt: parseUser.createdAt,
    );
  }

  static AddressModel address(ParseObject parseAddress) {
    return AddressModel(
      id: parseAddress.objectId,
      name: parseAddress.get<String>(keyAddressName)!,
      zipCode: parseAddress.get<String>(keyAddressZipCode)!,
      userId: parseAddress.get<ParseUser>(keyAddressOwner)!.objectId!,
      street: parseAddress.get<String>(keyAddressStreet)!,
      number: parseAddress.get<String>(keyAddressNumber)!,
      complement: parseAddress.get<String?>(keyAddressComplement),
      neighborhood: parseAddress.get<String>(keyAddressNeighborhood)!,
      state: parseAddress.get<String>(keyAddressState)!,
      city: parseAddress.get<String>(keyAddressCity)!,
    );
  }

  static AdvertModel? advert(ParseObject ad) {
    final parseAddress = ad.get<ParseObject?>(keyAdvertAddress);
    if (parseAddress == null) return null;
    AddressModel? address = ParseToModel.address(parseAddress);

    final parseUser = ad.get<ParseUser?>(keyAdvertOwner);
    if (parseUser == null) return null;
    final user = ParseToModel.user(parseUser);

    return AdvertModel(
      id: ad.objectId,
      owner: user,
      title: ad.get<String>(keyAdvertTitle)!,
      description: ad.get<String>(keyAdvertDescription)!,
      price: ad.get<num>(keyAdvertPrice)!.toDouble(),
      hidePhone: ad.get<bool>(keyAdvertHidePhone)!,
      images: (ad.get<List<dynamic>>(keyAdvertImages) as List<dynamic>)
          .map((item) => (item as ParseFile).url!)
          .toList(),
      mechanicsId: (ad.get<List<dynamic>>(keyAdvertMechanics) as List<dynamic>)
          .map((item) => (item as ParseObject).objectId!)
          .toList(),
      address: address,
      status: AdvertStatus.values
          .firstWhere((s) => s.index == ad.get<int>(keyAdvertStatus)!),
      condition: ProductCondition.values
          .firstWhere((c) => c.index == ad.get<int>(keyAdvertCondition)!),
      views: ad.get<int>(keyAdvertViews, defaultValue: 0)!,
    );
  }
}
