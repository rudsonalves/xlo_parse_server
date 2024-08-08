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
  final String name;
  final int yearpublished;
  final int minplayers;
  final int maxplayers;
  final int minplaytime;
  final int maxplaytime;
  final int age;
  final String? description;
  final double? average;
  final double? bayesaverage;
  final double? averageweight;
  final List<int> boardgamemechanic;
  final List<int> boardgamecategory;

  BoardgameModel({
    required this.name,
    required this.yearpublished,
    required this.minplayers,
    required this.maxplayers,
    required this.minplaytime,
    required this.maxplaytime,
    required this.age,
    this.description,
    this.average,
    this.bayesaverage,
    this.averageweight,
    required this.boardgamemechanic,
    required this.boardgamecategory,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'yearpublished': yearpublished,
      'minplayers': minplayers,
      'maxplayers': maxplayers,
      'minplaytime': minplaytime,
      'maxplaytime': maxplaytime,
      'age': age,
      'description': description,
      'average': average,
      'bayesaverage': bayesaverage,
      'averageweight': averageweight,
      'boardgamemechanic': boardgamemechanic,
      'boardgamecategory': boardgamecategory,
    };
  }

  factory BoardgameModel.fromMap(Map<String, dynamic> map) {
    return BoardgameModel(
      name: map['name'] as String,
      yearpublished: map['yearpublished'] as int,
      minplayers: map['minplayers'] as int,
      maxplayers: map['maxplayers'] as int,
      minplaytime: map['minplaytime'] as int,
      maxplaytime: map['maxplaytime'] as int,
      age: map['age'] as int,
      description:
          map['description'] != null ? map['description'] as String : null,
      average: map['average'] != null ? map['average'] as double : null,
      bayesaverage:
          map['bayesaverage'] != null ? map['bayesaverage'] as double : null,
      averageweight:
          map['averageweight'] != null ? map['averageweight'] as double : null,
      boardgamemechanic: List<int>.from(map['boardgamemechanic'] as List<int>),
      boardgamecategory: List<int>.from(map['boardgamecategory'] as List<int>),
    );
  }

  @override
  String toString() {
    return 'BoardgameModel(name: $name,\n'
        ' yearpublished: $yearpublished,\n'
        ' minplayers: $minplayers,\n'
        ' maxplayers: $maxplayers,\n'
        ' minplaytime: $minplaytime,\n'
        ' maxplaytime: $maxplaytime,\n'
        ' age: $age,\n'
        ' description: $description,\n'
        ' average: $average,\n'
        ' bayesaverage: $bayesaverage,\n'
        ' averageweight: $averageweight,\n'
        ' boardgamemechanic: $boardgamemechanic,\n'
        ' boardgamecategory: $boardgamecategory)';
  }
}
