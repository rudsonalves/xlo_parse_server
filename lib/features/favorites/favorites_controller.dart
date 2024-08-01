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

import '../../common/basic_controller/basic_controller.dart';
import '../../common/basic_controller/basic_state.dart';
import '../../common/models/advert.dart';
import '../../get_it.dart';
import '../../manager/favorites_manager.dart';

class FavoritesController extends BasicController {
  final favManager = getIt<FavoritesManager>();
  @override
  void init() {
    favManager.favNotifier.addListener(() {
      getAds();
    });

    getAds();
  }

  @override
  Future<void> getAds() async {
    changeState(BasicStateLoading());
    await Future.delayed(const Duration(milliseconds: 300));
    ads.clear();
    ads.addAll(favManager.ads);
    changeState(BasicStateSuccess());
  }

  @override
  Future<void> getMoreAds() {
    throw UnimplementedError();
  }

  @override
  Future<bool> updateAdStatus(AdvertModel ad) {
    throw UnimplementedError();
  }
}
