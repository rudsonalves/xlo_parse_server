// Copyright (C) 2024 Rudson Alves
//
// This file is part of bgbazzar.
//
// bgbazzar is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// bgbazzar is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with bgbazzar.  If not, see <https://www.gnu.org/licenses/>.

import '../common/models/bgg_rank.dart';
import '../repository/bgg_rank_repository.dart';

class BggRankManager {
  final repository = BggRankRepository();

  final List<BggRankModel> _ranks = [];
  final List<BGName> _bgNames = [];

  List<BggRankModel> get ranks => _ranks;
  List<BGName> get bgNames => _bgNames;

  Future<void> init() async {
    if (_bgNames.isNotEmpty) return;
    await getBGNames();
  }

  Future<void> getBGNames() async {
    final names = await BggRankRepository.getBGNames(1978);
    _bgNames.clear();
    _bgNames.addAll(names);
  }

  Future<BggRankModel?> getBGRank(int id) async {
    if (_hasRank(id)) {
      return _ranks.firstWhere((item) => item.id == id);
    }
    final rank = await BggRankRepository.getBggRankById(id);
    if (rank != null) {
      _ranks.add(rank);
    }

    return rank;
  }

  bool _hasRank(int id) {
    return _ranks
            .firstWhere(
              (item) => item.id == id,
              orElse: () => BggRankModel(gameName: ''),
            )
            .id !=
        null;
  }

  int? gameId(String gameName) {
    final id = _bgNames
        .firstWhere(
          (item) => item.gameName == gameName,
          orElse: () => BGName(id: -1, gameName: ''),
        )
        .id;
    return id == -1 ? null : id;
  }

  String gameName(int id) {
    final name = _bgNames
        .firstWhere(
          (item) => item.id == id,
          orElse: () => BGName(id: -1, gameName: ''),
        )
        .gameName;
    return name;
  }
}
