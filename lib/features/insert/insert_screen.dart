// Copyright (C) 2024 rudson
//
// This file is part of xlo_mobx.
//
// xlo_mobx is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// xlo_mobx is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xlo_mobx.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';

import '../../components/buttons/big_button.dart';
import 'insert_controller.dart';
import 'widgets/image_gallery.dart';
import 'widgets/insert_form.dart';

class InsertScreen extends StatefulWidget {
  const InsertScreen({super.key});

  static const routeName = '/insert';

  @override
  State<InsertScreen> createState() => _InsertScreenState();
}

class _InsertScreenState extends State<InsertScreen> {
  final controller = InsertController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
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
                          builder: (context, length, _) => ImageGallery(
                            length: length,
                            images: controller.images,
                            addImage: controller.addImage,
                            removeImage: controller.removeImage,
                          ),
                        ),
                      ),
                    ),
                    InsertForm(controller: controller),
                    BigButton(
                      color: Colors.orange,
                      label: 'Envia',
                      onPress: () {},
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
