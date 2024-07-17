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

enum AdStatus { pending, active, sold, closed }

class AdvertModel {
  String? id;
  String userId;
  List<dynamic> images;
  String title;
  String description;
  List<String> mechanicsId;
  String addressId;
  String price;
  bool hidePhone;
  AdStatus status;
  int views;
  DateTime createdAt;

  AdvertModel({
    this.id,
    required this.userId,
    required this.images,
    required this.title,
    required this.description,
    required this.mechanicsId,
    required this.addressId,
    required this.price,
    required this.hidePhone,
    this.status = AdStatus.pending,
    this.views = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  @override
  String toString() {
    return 'AdModel(id: $id,'
        ' userId: $userId,'
        ' images: ${images.toString()},'
        ' title: $title,'
        ' description: $description,'
        ' mechanics: $mechanicsId,'
        ' address: $addressId,'
        ' price: $price,'
        ' hidePhone: $hidePhone,'
        ' status: $status,'
        ' views: $views,'
        ' createdAt: $createdAt)';
  }
}
