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

import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../common/models/advert.dart';
import '../../../../get_it.dart';
import '../../../../manager/favorites_manager.dart';
import 'owner_rating.dart';
import 'shop_text_price.dart';
import 'shop_text_title.dart';
import 'show_image.dart';

class AdShopView extends StatelessWidget {
  final AdvertModel advert;
  final Widget? itemButton;

  AdShopView({
    super.key,
    required this.advert,
    this.itemButton,
  });

  final favoritesManager = getIt<FavoritesManager>();

  List<String> get favAdIds => favoritesManager.favAdIds;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      color: colorScheme.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Stack(
            children: [
              ShowImage(
                image: advert.images[0],
                size: MediaQuery.of(context).size.width * .48,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: ListenableBuilder(
                        listenable: favoritesManager.favNotifier,
                        builder: (context, _) {
                          return Icon(
                            favAdIds.contains(advert.id!)
                                ? Icons.favorite
                                : Icons.favorite_border,
                          );
                        }),
                    onPressed: () {
                      favoritesManager.toggleAdFav(advert);
                    },
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ShopTextTitle(label: advert.title),
                      ),
                      if (itemButton != null)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            itemButton!,
                          ],
                        ),
                    ],
                  ),
                  ShopTextPrice(advert.price),
                  OwnerRating(
                    owner: advert.owner.name,
                    starts: Random().nextInt(5) + 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}