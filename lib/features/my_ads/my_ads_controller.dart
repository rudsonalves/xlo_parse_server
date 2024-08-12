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

import 'dart:developer';

import '../../common/basic_controller/basic_state.dart';
import '../../common/models/ad.dart';
import '../../common/models/filter.dart';
import '../../repository/parse_server/ad_repository.dart';
import '../../common/basic_controller/basic_controller.dart';
import '../../repository/parse_server/common/constants.dart';

class MyAdsController extends BasicController {
  AdStatus _productStatus = AdStatus.active;
  AdStatus get productStatus => _productStatus;

  int _adPage = 0;

  bool _getMorePages = true;
  bool get getMorePages => _getMorePages;

  @override
  void init() {
    setProductStatus(AdStatus.active);
  }

  @override
  Future<void> getAds() async {
    try {
      changeState(BasicStateLoading());
      await _getAds();
      changeState(BasicStateSuccess());
    } catch (err) {
      log(err.toString());
      changeState(BasicStateError());
    }
  }

  Future<void> _getAds() async {
    final newAds = await AdRepository.getMyAds(
      currentUser.user!,
      _productStatus.index,
    );
    _adPage = 0;
    ads.clear();
    if (newAds != null && newAds.isNotEmpty) {
      ads.addAll(newAds);
      _getMorePages = maxAdsPerList == newAds.length;
    } else {
      _getMorePages = false;
    }
  }

  void setProductStatus(AdStatus newStatus) {
    _productStatus = newStatus;
    getAds();
  }

  @override
  Future<void> getMoreAds() async {
    if (!_getMorePages) return;
    try {
      changeState(BasicStateLoading());
      await _getMoreAds();
      changeState(BasicStateSuccess());
    } catch (err) {
      log(err.toString());
      changeState(BasicStateError());
    }
  }

  Future<void> _getMoreAds() async {
    _adPage++;
    final newAds = await AdRepository.get(
      filter: FilterModel(),
      search: '',
      page: _adPage,
    );
    if (newAds != null && newAds.isNotEmpty) {
      ads.addAll(newAds);
      _getMorePages = maxAdsPerList == newAds.length;
    } else {
      _getMorePages = false;
    }
  }

  @override
  Future<bool> updateAdStatus(AdModel ad) async {
    int atePage = _adPage;
    try {
      changeState(BasicStateLoading());
      final result = await AdRepository.updateStatus(ad);
      await _getAds();
      while (atePage > 0) {
        await _getMoreAds();
        atePage--;
      }
      changeState(BasicStateSuccess());
      return result;
    } catch (err) {
      log(err.toString());
      changeState(BasicStateError());
      return false;
    }
  }

  void updateAd(AdModel ad) {
    getAds();
  }

  Future<void> deleteAd(AdModel ad) async {
    try {
      changeState(BasicStateLoading());
      ad.status = AdStatus.deleted;
      await AdRepository.updateStatus(ad);
      await _getAds();
      changeState(BasicStateSuccess());
    } catch (err) {
      log(err.toString());
      changeState(BasicStateError());
    }
  }

  void closeErroMessage() {
    changeState(BasicStateSuccess());
  }
}
