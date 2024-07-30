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

import '../../common/app_constants.dart';
import '../../common/models/filter.dart';
import '../../common/models/user.dart';
import '../../common/singletons/current_user.dart';
import '../../common/singletons/search_filter.dart';
import '../../get_it.dart';
import 'base_state.dart';
import '../../common/singletons/app_settings.dart';

const titles = ['XLO', 'Chat', 'Favoritos', 'Minha Conta'];

class BaseController extends ChangeNotifier {
  BaseState _state = BaseStateInitial();

  final pageController = PageController();
  final app = getIt<AppSettings>();
  final ValueNotifier<String> _pageTitle = ValueNotifier<String>('XLO');
  final currentUser = getIt<CurrentUser>();
  final searchFilter = getIt<SearchFilter>();

  String get searchString => searchFilter.searchString;
  UserModel? get user => currentUser.user;

  FilterModel get filter => searchFilter.filter;
  set filter(FilterModel newFilter) {
    searchFilter.updateFilter(newFilter);
  }

  AppPage _page = AppPage.shopePage;
  AppPage get page => _page;

  BaseState get state => _state;
  double? get currentPage => pageController.page;

  ValueNotifier<String> get pageTitle => _pageTitle;
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
      setPageTitle();
      _changeState(BaseStateSuccess());
    } catch (err) {
      _changeState(BaseStateError());
    }
  }

  void jumpToPage(AppPage page) {
    _page = page;
    setPageTitle();
    pageController.jumpToPage(page.index);
  }

  void setPageTitle() {
    if (_page == AppPage.shopePage) {
      if (searchFilter.searchString.isEmpty) {
        _pageTitle.value =
            user == null ? titles[AppPage.shopePage.index] : user!.name!;
      } else {
        _pageTitle.value = searchFilter.searchString;
      }
    } else {
      _pageTitle.value = titles[_page.index];
    }
  }

  void setSearch(String value) {
    searchFilter.searchString = value;
    if (_page == AppPage.shopePage) {
      _pageTitle.value = searchFilter.searchString.isEmpty
          ? titles[AppPage.shopePage.index]
          : searchFilter.searchString;
    }
  }
}
