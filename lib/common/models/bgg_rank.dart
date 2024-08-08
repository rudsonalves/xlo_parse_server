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

class BGName {
  int id;
  String gameName;
  BGName({
    required this.id,
    required this.gameName,
  });

  factory BGName.fromMap(Map<String, dynamic> map) {
    return BGName(
      id: map['id'] as int,
      gameName: map['gameName'] as String,
    );
  }
}

class BggRankModel {
  int? id;
  String gameName;
  int? yearPublished;
  int? rank;
  double? bayesAverage;
  double? average;
  int? usersRated;
  int? isExpansion;
  int? abstractsRank;
  int? cgsRank;
  int? childrensGamesrank;
  int? familyGamesRank;
  int? partyGamesRank;
  int? strategyGamesRank;
  int? thematicRank;
  int? warGamesRank;

  BggRankModel({
    this.id,
    required this.gameName,
    this.yearPublished,
    this.rank,
    this.bayesAverage,
    this.average,
    this.usersRated,
    this.isExpansion,
    this.abstractsRank,
    this.cgsRank,
    this.childrensGamesrank,
    this.familyGamesRank,
    this.partyGamesRank,
    this.strategyGamesRank,
    this.thematicRank,
    this.warGamesRank,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'gameName': gameName,
      'yearPublished': yearPublished,
      'rank': rank,
      'bayesAverage': bayesAverage,
      'average': average,
      'usersRated': usersRated,
      'isExpansion': isExpansion,
      'abstractsRank': abstractsRank,
      'cgsRank': cgsRank,
      'childrensGamesrank': childrensGamesrank,
      'familyGamesRank': familyGamesRank,
      'partyGamesRank': partyGamesRank,
      'strategyGamesRank': strategyGamesRank,
      'thematicRank': thematicRank,
      'warGamesRank': warGamesRank,
    };
  }

  factory BggRankModel.fromMap(Map<String, dynamic> map) {
    return BggRankModel(
      id: map['id'] != null ? map['id'] as int : null,
      gameName: map['gameName'] as String,
      yearPublished:
          map['yearPublished'] != null ? map['yearPublished'] as int : null,
      rank: map['rank'] != null ? map['rank'] as int : null,
      bayesAverage:
          map['bayesAverage'] != null ? map['bayesAverage'] as double : null,
      average: map['average'] != null ? map['average'] as double : null,
      usersRated: map['usersRated'] != null ? map['usersRated'] as int : null,
      isExpansion:
          map['isExpansion'] != null ? map['isExpansion'] as int : null,
      abstractsRank:
          map['abstractsRank'] != null ? map['abstractsRank'] as int : null,
      cgsRank: map['cgsRank'] != null ? map['cgsRank'] as int : null,
      childrensGamesrank: map['childrensGamesrank'] != null
          ? map['childrensGamesrank'] as int
          : null,
      familyGamesRank:
          map['familyGamesRank'] != null ? map['familyGamesRank'] as int : null,
      partyGamesRank:
          map['partyGamesRank'] != null ? map['partyGamesRank'] as int : null,
      strategyGamesRank: map['strategyGamesRank'] != null
          ? map['strategyGamesRank'] as int
          : null,
      thematicRank:
          map['thematicRank'] != null ? map['thematicRank'] as int : null,
      warGamesRank:
          map['warGamesRank'] != null ? map['warGamesRank'] as int : null,
    );
  }

  @override
  String toString() {
    return 'BggRank(id: $id, gameName: $gameName, yearPublished: $yearPublished, rank: $rank, bayesAverage: $bayesAverage, average: $average, usersRated: $usersRated, isExpansion: $isExpansion, abstractsRank: $abstractsRank, cgsRank: $cgsRank, childrensGamesrank: $childrensGamesrank, familyGamesRank: $familyGamesRank, partyGamesRank: $partyGamesRank, strategyGamesRank: $strategyGamesRank, thematicRank: $thematicRank, warGamesRank: $warGamesRank)';
  }
}
