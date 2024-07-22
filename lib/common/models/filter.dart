import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
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

enum AdvertiserOrder { all, particular, commercial }

enum SortOrder { date, price }

class FilterModel {
  String state;
  String city;
  SortOrder sortBy;
  AdvertiserOrder advertiser;
  List<String> mechanicsId;
  int minPrice;
  int maxPrice;

  FilterModel({
    this.state = '',
    this.city = '',
    this.sortBy = SortOrder.date,
    this.advertiser = AdvertiserOrder.all,
    List<String>? mechanicsId,
    this.minPrice = 0,
    this.maxPrice = 0,
  }) : mechanicsId = mechanicsId ?? [];

  bool get isEmpty {
    return state.isEmpty &&
        city.isEmpty &&
        sortBy == SortOrder.date &&
        advertiser == AdvertiserOrder.all &&
        mechanicsId.isEmpty &&
        minPrice == 0 &&
        maxPrice == 0;
  }

  @override
  String toString() {
    return 'FilterModel(state: $state,'
        ' city: $city,'
        ' sortBy: $sortBy,'
        ' advertiser: $advertiser,'
        ' mechanicsId: $mechanicsId,'
        ' minPrice: $minPrice,'
        ' maxPrice: $maxPrice)';
  }

  @override
  bool operator ==(covariant FilterModel other) {
    if (identical(this, other)) return true;

    return other.state == state &&
        other.city == city &&
        other.sortBy == sortBy &&
        other.advertiser == advertiser &&
        listEquals(other.mechanicsId, mechanicsId) &&
        other.minPrice == minPrice &&
        other.maxPrice == maxPrice;
  }

  @override
  int get hashCode {
    return state.hashCode ^
        city.hashCode ^
        sortBy.hashCode ^
        advertiser.hashCode ^
        mechanicsId.hashCode ^
        minPrice.hashCode ^
        maxPrice.hashCode;
  }
}
