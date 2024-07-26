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

import '../../../../common/models/advert.dart';
import '../../../../features/shop/widgets/ad_text_info.dart';
import '../../../../features/shop/widgets/ad_text_price.dart';
import '../../../../features/shop/widgets/ad_text_title.dart';
import 'show_image.dart';

class AdCardView extends StatelessWidget {
  final AdvertModel ads;
  final Widget? itemButton;

  const AdCardView({
    super.key,
    required this.ads,
    this.itemButton,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        color: colorScheme.surfaceContainer,
        child: Row(
          children: [
            ShowImage(image: ads.images[0]),
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
                          child: AdTextTitle(ads.title),
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
                    AdTextPrice(ads.price),
                    AdTextInfo(
                      date: ads.createdAt,
                      city: ads.address.city,
                      state: ads.address.state,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
