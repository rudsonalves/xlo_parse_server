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

class BoardgameModel {
  final int? id;
  final String name;
  final int yearpublished;
  final int minplayers;
  final int maxplayers;
  final int minplaytime;
  final int maxplaytime;
  final int age;
  final String? designer;
  final String? artist;
  String? description;
  final double? average;
  final double? bayesaverage;
  final double? averageweight;
  final List<int> mechanics;
  final List<int> categories;

  BoardgameModel({
    this.id,
    required this.name,
    required this.yearpublished,
    required this.minplayers,
    required this.maxplayers,
    required this.minplaytime,
    required this.maxplaytime,
    required this.age,
    this.designer,
    this.artist,
    this.description,
    this.average,
    this.bayesaverage,
    this.averageweight,
    required this.mechanics,
    required this.categories,
  });

  static String cleanDescription(String text) {
    String description = text.replaceAll('<br/>', '\n');

    while (description[description.length - 1] == '\n') {
      description = description.substring(0, description.length - 1);
    }

    return description;
  }

  @override
  String toString() {
    return 'BoardgameModel('
        ' id: $id,\n'
        ' name: $name,\n'
        ' yearpublished: $yearpublished,\n'
        ' minplayers: $minplayers,\n'
        ' maxplayers: $maxplayers,\n'
        ' minplaytime: $minplaytime,\n'
        ' maxplaytime: $maxplaytime,\n'
        ' age: $age,\n'
        ' designer: $designer,\n'
        ' artist: $artist,\n'
        ' description: $description,\n'
        ' average: $average,\n'
        ' bayesaverage: $bayesaverage,\n'
        ' averageweight: $averageweight,\n'
        ' boardgamemechanic: $mechanics,\n'
        ' boardgamecategory: $categories)';
  }
}
