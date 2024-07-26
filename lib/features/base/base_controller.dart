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
import 'package:xlo_mobx/common/singletons/search_filter.dart';

import '../../common/models/filter.dart';
import '../../common/singletons/current_user.dart';
import '../../get_it.dart';
import 'base_state.dart';
import '../../common/singletons/app_settings.dart';

const titles = ['XLO', 'Adicionar Anúncio', 'Chat', 'Favoritos', 'Minha Conta'];

class BaseController extends ChangeNotifier {
  BaseState _state = BaseStateInitial();

  final pageController = PageController();
  final app = getIt<AppSettings>();
  final ValueNotifier<String> _pageTitle = ValueNotifier<String>('XLO');
  final currentUser = getIt<CurrentUser>();
  final searchFilter = getIt<SearchFilter>();

  String get searchString => searchFilter.searchString;

  FilterModel get filter => searchFilter.filter;
  set filter(FilterModel newFilter) {
    searchFilter.updateFilter(newFilter);
  }

  int _page = 0;
  int get page => _page;

  BaseState get state => _state;
  String get pageTitle => _pageTitle.value;
  double? get currentPage => pageController.page;

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
    _page = page;
    if (_page == 0) {
      _pageTitle.value = searchFilter.searchString.isEmpty
          ? titles[0]
          : searchFilter.searchString;
    } else {
      _pageTitle.value = titles[_page];
    }

    pageController.jumpToPage(page);
  }

  void setSearch(String value) {
    searchFilter.searchString = value;
    if (_page == 0) {
      _pageTitle.value = searchFilter.searchString.isEmpty
          ? titles[0]
          : searchFilter.searchString;
    }
  }
}
