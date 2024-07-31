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

import '../../../common/models/advert.dart';
import '../edit_advert_controller.dart';
import 'horizontal_image_gallery.dart';

class ImagesListView extends StatelessWidget {
  final EditAdvertController ctrl;
  final bool validator;
  final Function(AdvertModel ad)? editAd;
  final Function(AdvertModel ad)? deleteAd;

  const ImagesListView({
    super.key,
    required this.ctrl,
    required this.validator,
    this.editAd,
    this.deleteAd,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: ctrl.app.isDark
            ? colorScheme.onSecondary
            : colorScheme.primary.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
      ),
      height: 120,
      child: ValueListenableBuilder(
        valueListenable: ctrl.imagesLength,
        builder: (context, length, _) => HotizontalImageGallery(
          length: length,
          images: ctrl.images,
          addImage: ctrl.addImage,
          removeImage: ctrl.removeImage,
        ),
      ),
    );
  }
}
