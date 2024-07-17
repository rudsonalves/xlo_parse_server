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

import '../advertisement_controller.dart';
import 'horizontal_image_gallery.dart';

class ImagesListView extends StatelessWidget {
  final AdvertController controller;
  final bool validator;

  const ImagesListView({
    super.key,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: controller.app.isDark
            ? colorScheme.onSecondary
            : colorScheme.primary.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
      ),
      height: 120,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder(
          valueListenable: controller.imagesLength,
          builder: (context, length, _) => HotizontalImageGallery(
            length: length,
            images: controller.images,
            addImage: controller.addImage,
            removeImage: controller.removeImage,
          ),
        ),
      ),
    );
  }
}
