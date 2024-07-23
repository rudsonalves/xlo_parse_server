import 'dart:convert';

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

// enum UserType { particular, professional }

class UserModel {
  String? id;
  String? name;
  String email;
  String? phone;
  String? password;
  // UserType type;
  DateTime? createAt;

  UserModel({
    this.id,
    this.name,
    required this.email,
    this.phone,
    this.password,
    // this.type = UserType.particular,
    DateTime? createdAt,
  }) : createAt = createdAt ?? DateTime.now();

  @override
  String toString() {
    return 'User(id: $id, name:'
        ' $name, email:'
        ' $email, phone: $phone,'
        ' password: $password,'
        ' createAt: $createAt';
  }

  UserModel copyFromUsreModel(UserModel user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      password: user.password,
      // type: user.type,
      createdAt: user.createAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      // 'type': type.name,
      'createdAt': createAt?.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] as String,
      phone: map['phone'] != null ? map['phone'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      // type: UserType.values[map['type']],
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createAt'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
