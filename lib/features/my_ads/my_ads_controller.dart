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

import '../../common/basic_controller/basic_state.dart';
import '../../common/models/advert.dart';
import '../../common/models/filter.dart';
import '../../repository/advert_repository.dart';
import '../../common/basic_controller/basic_controller.dart';
import '../../repository/constants.dart';

class MyAdsController extends BasicController {
  AdvertStatus _productStatus = AdvertStatus.active;
  AdvertStatus get productStatus => _productStatus;

  int _adPage = 0;

  bool _getMorePages = true;
  bool get getMorePages => _getMorePages;

  @override
  void init() {
    setProductStatus(AdvertStatus.active);
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
    final newAds = await AdvertRepository.getMyAds(
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

  void setProductStatus(AdvertStatus newStatus) {
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
    final newAds = await AdvertRepository.get(
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
  Future<bool> updateAdStatus(AdvertModel ad) async {
    int atePage = _adPage;
    try {
      changeState(BasicStateLoading());
      final result = await AdvertRepository.updateStatus(ad);
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

  void updateAd(AdvertModel ad) {
    getAds();
  }

  Future<void> deleteAd(AdvertModel ad) async {
    try {
      changeState(BasicStateLoading());
      // await AdvertRepository.delete(ad);
      ad.status = AdvertStatus.deleted;
      await AdvertRepository.updateStatus(ad);
      await _getAds();
      changeState(BasicStateSuccess());
    } catch (err) {
      log(err.toString());
      changeState(BasicStateError());
    }
  }
}
