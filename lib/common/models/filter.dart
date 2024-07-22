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
  final String state;
  final String city;
  final SortOrder sortBy;
  final AdvertiserOrder advertiserOrder;
  final List<String> mechanicsId;

  FilterModel({
    required this.state,
    required this.city,
    required this.sortBy,
    required this.advertiserOrder,
    required this.mechanicsId,
  });

  @override
  String toString() {
    return 'FilterModel(state: $state,'
        ' city: $city,'
        ' sortBy: $sortBy,'
        ' advertiserOrder: $advertiserOrder,'
        ' mechanicsId: $mechanicsId)';
  }
}
