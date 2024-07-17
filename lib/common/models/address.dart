// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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

class AddressModel {
  String? id;
  String name;
  String zipCode;
  String userId;
  String street;
  String number;
  String? complement;
  String neighborhood;
  String state;
  String city;

  AddressModel({
    this.id,
    required this.name,
    required this.zipCode,
    required this.userId,
    required this.street,
    required this.number,
    this.complement,
    required this.neighborhood,
    required this.state,
    required this.city,
  });

  String addressString() {
    return '$street, '
        'N° $number, '
        '${complement != null && complement!.isNotEmpty ? 'Complemento $complement, ' : ''}'
        'Bairro $neighborhood, '
        '$city - $state, '
        'CEP: $zipCode';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'zipCode': zipCode,
      'userId': userId,
      'street': street,
      'number': number,
      'complement': complement,
      'neighborhood': neighborhood,
      'state': state,
      'city': city,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      zipCode: map['zipCode'] as String,
      userId: map['userId'] as String,
      street: map['street'] as String,
      number: map['number'] as String,
      complement:
          map['complement'] != null ? map['complement'] as String : null,
      neighborhood: map['neighborhood'] as String,
      state: map['state'] as String,
      city: map['city'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AddressModel(id: $id,'
        ' name: $name,'
        ' zipCode: $zipCode,'
        ' userId: $userId,'
        ' street: $street,'
        ' number: $number,'
        ' complement: $complement,'
        ' neighborhood: $neighborhood,'
        ' state: $state,'
        ' city: $city)';
  }

  @override
  bool operator ==(covariant AddressModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.zipCode == zipCode &&
        other.userId == userId &&
        other.street == street &&
        other.number == number &&
        other.complement == complement &&
        other.neighborhood == neighborhood &&
        other.state == state &&
        other.city == city;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        zipCode.hashCode ^
        userId.hashCode ^
        street.hashCode ^
        number.hashCode ^
        complement.hashCode ^
        neighborhood.hashCode ^
        state.hashCode ^
        city.hashCode;
  }
}