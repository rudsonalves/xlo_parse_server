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

import 'package:xlo_mobx/common/basic_controller/basic_state.dart';

import '../../common/models/advert.dart';
import '../../repository/advert_repository.dart';
import '../../common/basic_controller/basic_controller.dart';

class MyAdsController extends BasicController {
  AdvertStatus _productStatus = AdvertStatus.active;
  AdvertStatus get productStatus => _productStatus;

  @override
  void init() {
    setProductStatus(AdvertStatus.active);
  }

  @override
  Future<void> getAds() async {
    try {
      changeState(BasicStateLoading());
      final newsAds = await AdvertRepository.getMyAds(
        currentUser.user!,
        _productStatus.index,
      );
      ads.clear();
      if (newsAds != null) {
        ads.addAll(newsAds);
      }
      changeState(BasicStateSuccess());
    } catch (err) {
      log(err.toString());
      changeState(BasicStateError());
    }
  }

  void setProductStatus(AdvertStatus newStatus) {
    _productStatus = newStatus;
    getAds();
  }

  @override
  Future<void> getMoreAds() async {
    log('Ops...');
  }
}
