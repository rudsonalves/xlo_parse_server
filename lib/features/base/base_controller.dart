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

import '../../common/singletons/current_user.dart';
import 'base_state.dart';
import '../../common/singletons/app_settings.dart';

class BaseController extends ChangeNotifier {
  BaseState _state = BaseStateInitial();

  final pageController = PageController();
  final app = AppSettings.instance;
  final ValueNotifier<String> _pageTitle = ValueNotifier<String>('XLO');
  final currentUser = CurrentUser.instance;

  BaseState get state => _state;
  String get pageTitle => _pageTitle.value;

  ValueNotifier<String> get titleNotifier => _pageTitle;
  void _changeState(BaseState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    _pageTitle.dispose();
    super.dispose();
  }

  Future<void> init() async {
    try {
      _changeState(BaseStateLoading());
      await currentUser.init();
      _changeState(BaseStateSuccess());
    } catch (err) {
      _changeState(BaseStateError());
    }
  }

  void jumpToPage(int page) {
    switch (page) {
      case 0:
        _pageTitle.value = 'XLO';
        break;
      case 1:
        _pageTitle.value = 'Criar Anúncio';
        break;
      case 2:
        _pageTitle.value = 'Chat';
        break;
      case 3:
        _pageTitle.value = 'Favoritos';
        break;
      case 4:
        _pageTitle.value = 'Minha Conta';
        break;
      default:
        _pageTitle.value = 'XLO';
    }
    pageController.jumpToPage(page);
  }
}
