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

import '../../manager/mechanics_manager.dart';
import '../../common/models/boardgame.dart';
import '../../components/custon_field_controllers/numeric_edit_controller.dart';
import '../../get_it.dart';
import '../../manager/bgg_rank_manager.dart';
import '../../repository/bgg_xmlapi_repository.dart';
import 'boardgame_state.dart';

class BoardgameController extends ChangeNotifier {
  BoardgameState _state = BoardgameStateInitial();

  final rankManager = getIt<BggRankManager>();
  final mechManager = getIt<MechanicsManager>();

  final nameController = TextEditingController();
  final minPlayersController = TextEditingController();
  final maxPlayersController = TextEditingController();
  final minTimeController = TextEditingController();
  final maxTimeController = TextEditingController();
  final ageController = TextEditingController();
  final descriptionController = TextEditingController();
  final weightController = NumericEditController();
  final averageController = NumericEditController();
  final mechsController = TextEditingController();

  BoardgameState get state => _state;
  List<String> get bgNames =>
      rankManager.bgNames.map((bg) => bg.gameName).toList();

  void init() {
    initBggRank();
  }

  @override
  void dispose() {
    nameController.dispose();
    minPlayersController.dispose();
    maxPlayersController.dispose();
    minTimeController.dispose();
    maxTimeController.dispose();
    ageController.dispose();
    descriptionController.dispose();
    weightController.dispose();
    averageController.dispose();
    mechsController.dispose();
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

  Future<void> getBggInfo() async {
    try {
      _changeState(BoardgameStateLoading());
      if (nameController.text.isEmpty) return;
      final bgId = rankManager.gameId(nameController.text);
      if (bgId == null) return;
      final bggInfo = await BggXMLApiRepository.fentchBoardGame(bgId);
      if (bggInfo != null) loadBoardInfo(bggInfo);
      log(bggInfo.toString());
      _changeState(BoardgameStateSuccess());
    } catch (err) {
      _changeState(BoardgameStateError());
    }
  }

  loadBoardInfo(BoardgameModel bggInfo) {
    minPlayersController.text = bggInfo.minplayers.toString();
    maxPlayersController.text = bggInfo.maxplayers.toString();
    minTimeController.text = bggInfo.minplaytime.toString();
    maxTimeController.text = bggInfo.maxplaytime.toString();
    ageController.text = bggInfo.age.toString();
    descriptionController.text = bggInfo.description ?? '';
    weightController.numericValue = bggInfo.averageweight ?? 0;
    averageController.numericValue = bggInfo.average ?? 0;
    mechsController.text = mechManager.namesFromIdListString(bggInfo.mechanics);
  }

  void closeErroMessage() {
    _changeState(BoardgameStateSuccess());
  }
}
