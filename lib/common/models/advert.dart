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

enum AdvertStatus { pending, active, sold, closed }

enum ProductCondition { all, used, sealed }

class AdvertModel {
  String? id;
  String userId;
  List<String> images;
  String title;
  String description;
  List<String> mechanicsId;
  String addressId;
  double price;
  bool hidePhone;
  AdvertStatus status;
  ProductCondition condition;
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
    this.condition = ProductCondition.all,
    this.hidePhone = false,
    this.status = AdvertStatus.pending,
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
        ' condition: $condition,'
        ' views: $views,'
        ' createdAt: $createdAt)';
  }
}
