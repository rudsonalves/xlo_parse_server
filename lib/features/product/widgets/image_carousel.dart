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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';

import '../../../common/models/advert.dart';

class ImageCarousel extends StatelessWidget {
  final AdvertModel advert;

  const ImageCarousel({
    super.key,
    required this.advert,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 8),
      color: colorScheme.surfaceContainer,
      child: CarouselSlider.builder(
        itemCount: advert.images.length,
        slideBuilder: (index) => CachedNetworkImage(
          imageUrl: advert.images[index],
          fit: BoxFit.fill,
        ),
        slideIndicator: CircularSlideIndicator(
          padding: const EdgeInsets.only(bottom: 32),
        ),
        unlimitedMode: true,
      ),
    );
  }
}
