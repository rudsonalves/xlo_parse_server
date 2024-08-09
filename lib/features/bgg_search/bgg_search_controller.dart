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

import 'package:flutter/material.dart';

import '../../common/models/bgg_boards.dart';
import '../../common/models/boardgame.dart';
import '../../repository/bgg_xmlapi_repository.dart';
import 'bgg_search_state.dart';

class BggController extends ChangeNotifier {
  BggSearchState _state = BggSearchStateInitial();

  final bgName = TextEditingController();
  List<BGGBoardsModel> bggSearchList = [];
  BoardgameModel? selectedGame;

  BggSearchState get state => _state;

  @override
  void dispose() {
    bgName.dispose();
    super.dispose();
  }

  void _changeState(BggSearchState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> searchBgg() async {
    final search = bgName.text.trim();
    if (search.isEmpty) return;

    try {
      _changeState(BggSearchStateLoading());
      bggSearchList = await BggXMLApiRepository.searchInBGG(search);
      _changeState(BggSearchStateSuccess());
    } catch (err) {
      _changeState(BggSearchStateError());
    }
  }

  closeError() {
    _changeState(BggSearchStateSuccess());
  }

  Future<void> getBoardInfo(int id) async {
    try {
      _changeState(BggSearchStateLoading());
      selectedGame = await BggXMLApiRepository.fentchBoardGame(id);
      _changeState(BggSearchStateSuccess());
    } catch (err) {
      _changeState(BggSearchStateError());
    }
  }
}
