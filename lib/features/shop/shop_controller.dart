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

import '../../common/basic_controller/basic_controller.dart';
import '../../common/basic_controller/basic_state.dart';
import '../../common/models/advert.dart';
import '../../common/models/filter.dart';
import '../../common/singletons/app_settings.dart';
import '../../common/singletons/search_filter.dart';
import '../../get_it.dart';
import '../../repository/advert_repository.dart';
import '../../repository/common/constants.dart';

class ShopController extends BasicController {
  final app = getIt<AppSettings>();
  final searchFilter = getIt<SearchFilter>();

  FilterModel get filter => searchFilter.filter;
  set filter(FilterModel newFilter) {
    searchFilter.updateFilter(newFilter);
    _getMorePages = true;
  }

  int _adPage = 0;

  bool _getMorePages = true;
  bool get getMorePages => _getMorePages;

  @override
  void init() {
    getAds();

    searchFilter.filterNotifier.addListener(getAds);
    searchFilter.search.addListener(getAds);
  }

  @override
  Future<void> getAds() async {
    try {
      changeState(BasicStateLoading());
      final newAds = await AdvertRepository.get(
        filter: filter,
        search: searchFilter.searchString,
      );
      _adPage = 0;
      ads.clear();
      if (newAds != null && newAds.isNotEmpty) {
        ads.addAll(newAds);
        _getMorePages = maxAdsPerList == newAds.length;
      } else {
        _getMorePages = false;
      }
      changeState(BasicStateSuccess());
    } catch (err) {
      log(err.toString());
      changeState(BasicStateError());
    }
  }

  @override
  Future<void> getMoreAds() async {
    if (!_getMorePages) return;
    _adPage++;
    try {
      changeState(BasicStateLoading());
      final newAds = await AdvertRepository.get(
        filter: filter,
        search: searchFilter.searchString,
        page: _adPage,
      );
      if (newAds != null && newAds.isNotEmpty) {
        ads.addAll(newAds);
        _getMorePages = maxAdsPerList == newAds.length;
      } else {
        _getMorePages = false;
      }
      changeState(BasicStateSuccess());
    } catch (err) {
      log(err.toString());
      changeState(BasicStateError());
    }
  }

  @override
  Future<bool> updateAdStatus(AdvertModel ad) {
    throw UnimplementedError();
  }
}
