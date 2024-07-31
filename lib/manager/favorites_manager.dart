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

import 'package:flutter/foundation.dart';

import '../common/models/advert.dart';
import '../common/models/favorite.dart';
import '../common/singletons/current_user.dart';
import '../get_it.dart';
import '../repository/favorite_repository.dart';

class FavoritesManager {
  final List<FavoriteModel> _favs = [];
  final List<AdvertModel> _ads = [];
  final List<String> _favIds = [];

  List<FavoriteModel> get favs => _favs;
  List<String> get favAdIds => _favIds;
  bool get isLogged => getIt<CurrentUser>().isLogged;
  String? get userId => getIt<CurrentUser>().userId;

  final favNotifier = ValueNotifier<bool>(true);

  Future<void> login() async {
    if (isLogged) {
      await getFavorites();
    }
  }

  void _toggleFavNotifier() {
    favNotifier.value = !favNotifier.value;
  }

  Future<void> logout() async {
    if (isLogged) {
      _favs.clear();
      _ads.clear();
      _favIds.clear();
      _toggleFavNotifier();
    }
  }

  Future<void> getFavorites() async {
    try {
      final List<AdvertModel> ads;
      final List<FavoriteModel> favs;
      (ads, favs) = await FavoriteRepository.getFavorites(userId!);

      _ads.clear();
      _favs.clear();
      _favIds.clear();
      if (ads.isNotEmpty) {
        _ads.addAll(ads);
        _favs.addAll(favs);
        _favIds.addAll(_favs.map((fav) => fav.adId));
      }
      _toggleFavNotifier();
    } catch (err) {
      log('Error fetching favorites: $err');
    }
  }

  Future<void> toggleAdFav(AdvertModel ad) async {
    if (_favIds.contains(ad.id!)) {
      _remove(ad);
    } else {
      _add(ad);
    }
  }

  Future<void> _add(AdvertModel ad) async {
    try {
      final fav = await FavoriteRepository.add(userId!, ad.id!);

      if (fav != null) {
        _ads.add(ad);
        _favs.add(fav);
        _favIds.add(ad.id!);
        _toggleFavNotifier();
      }
    } catch (err) {
      log('Error fetching favorites: $err');
    }
  }

  Future<void> _remove(AdvertModel ad) async {
    try {
      final favId = _getFavId(ad);
      if (favId != null) {
        await FavoriteRepository.delete(favId);
        _favs.removeWhere((f) => f.adId == ad.id);
        _ads.removeWhere((a) => a.id == ad.id);
        _favIds.removeWhere((id) => id == ad.id);
        _toggleFavNotifier();
      }
    } catch (err) {
      log('Error fetching favorites: $err');
    }
  }

  String? _getFavId(ad) {
    return _favs
        .firstWhere(
          (f) => f.adId == ad.id,
          orElse: () => FavoriteModel(adId: ''),
        )
        .id;
  }
}
