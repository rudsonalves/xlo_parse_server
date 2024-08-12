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

import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../common/models/ad.dart';
import '../../../../common/singletons/current_user.dart';
import '../../../../get_it.dart';
import '../../fav_button.dart';
import 'owner_rating.dart';
import 'shop_text_price.dart';
import 'shop_text_title.dart';
import 'show_image.dart';

class AdShopView extends StatelessWidget {
  final AdModel ad;
  final Widget? itemButton;

  const AdShopView({
    super.key,
    required this.ad,
    this.itemButton,
  });

  bool get isLogged => getIt<CurrentUser>().isLogged;

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
                image: ad.images[0],
                size: (MediaQuery.of(context).size.width - 8) / 2,
              ),
              if (isLogged)
                FavStackButton(
                  ad: ad,
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
                        child: ShopTextTitle(label: ad.title),
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
                  ShopTextPrice(ad.price),
                  OwnerRating(
                    owner: ad.owner!.name,
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
