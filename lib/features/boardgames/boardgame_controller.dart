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

import 'dart:developer';

import 'package:flutter/material.dart';

import '../../get_it.dart';
import '../../manager/bgg_rank_manager.dart';
import '../../repository/bgg_xmlapi_repository.dart';
import 'boardgame_state.dart';

class BoardgameController extends ChangeNotifier {
  BoardgameState _state = BoardgameStateInitial();

  final rankManager = getIt<BggRankManager>();

  final bggName = TextEditingController();

  BoardgameState get state => _state;
  List<String> get bgNames =>
      rankManager.bgNames.map((bg) => bg.gameName).toList();

  void init() {
    initBggRank();
  }

  @override
  void dispose() {
    bggName.dispose();
    super.dispose();
  }

  void _changeState(BoardgameState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> initBggRank() async {
    try {
      _changeState(BoardgameStateLoading());
      await rankManager.init();
      _changeState(BoardgameStateSuccess());
    } catch (err) {
      _changeState(BoardgameStateError());
    }
  }

  Future<void> getBggInfos() async {
    if (bggName.text.isEmpty) return;
    final bgId = rankManager.gameId(bggName.text);
    if (bgId == null) return;
    final bggInfo = await BggXMLApiRepository.fentchBoardGame(bgId);
    log(bggInfo.toString());
  }

  void closeErroMessage() {
    _changeState(BoardgameStateSuccess());
  }
}
