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

class MechanicModel {
  String? id;
  String? name;
  String? description;
  DateTime? createAt;

  MechanicModel({
    this.id,
    this.name,
    this.description,
    this.createAt,
  });

  @override
  String toString() {
    return 'CategoryModel(id: $id,'
        ' name: $name,'
        ' description: $description,'
        ' createAt: $createAt)';
  }
}