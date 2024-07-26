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

import '../../common/models/advert.dart';
import '../../common/models/filter.dart';
import '../../common/singletons/app_settings.dart';
import '../../common/singletons/current_user.dart';
import '../../common/singletons/search_filter.dart';
import '../../get_it.dart';
import '../../repository/advert_repository.dart';
import 'shop_state.dart';

class ShopController extends ChangeNotifier {
  ShopState _state = ShopStateInitial();
  ShopState get state => _state;

  final app = getIt<AppSettings>();
  final CurrentUser? user = getIt<CurrentUser>();
  final searchFilter = getIt<SearchFilter>();

  FilterModel get filter => searchFilter.filter;
  set filter(FilterModel newFilter) {
    searchFilter.updateFilter(newFilter);
    _getMorePages = true;
  }

  final List<AdvertModel> _ads = [];

  List<AdvertModel> get ads => _ads;

  int _adPage = 0;

  bool _getMorePages = true;
  bool get getMorePages => _getMorePages;

  void init() {
    getAds();

    searchFilter.filterNotifier.addListener(getAds);
    searchFilter.search.addListener(getAds);
  }

  void _changeState(ShopState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> getAds() async {
    try {
      _changeState(ShopeStateLoading());
      final result = await AdvertRepository.get(
        filter: filter,
        search: searchFilter.searchString,
        page: _adPage,
      );
      _ads.clear();
      if (result != null && result.isNotEmpty) {
        _ads.addAll(result);
        _getMorePages = AdvertRepository.maxAdsPerList == result.length;
      }
      _changeState(ShopeStateSuccess());
    } catch (err) {
      log(err.toString());
      _changeState(ShopeStateError());
    }
  }

  Future<void> getMoreAds() async {
    if (!_getMorePages) return;
    _adPage++;
    try {
      _changeState(ShopeStateLoading());
      final result = await AdvertRepository.get(
        filter: filter,
        search: searchFilter.searchString,
        page: _adPage,
      );
      if (result != null && result.isNotEmpty) {
        _ads.addAll(result);
        _getMorePages = true;
      } else {
        _getMorePages = false;
      }
      _changeState(ShopeStateSuccess());
    } catch (err) {
      log(err.toString());
      _changeState(ShopeStateError());
    }
  }
}
