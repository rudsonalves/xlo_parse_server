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

import 'dart:developer';

import 'package:flutter/material.dart';

import '../../components/buttons/big_button.dart';
import 'advertisement_controller.dart';
import 'widgets/horizontal_image_gallery.dart';
import 'widgets/advertisement_form.dart';

class AdvertisementScreen extends StatefulWidget {
  const AdvertisementScreen({super.key});

  static const routeName = '/insert';

  @override
  State<AdvertisementScreen> createState() => _AdvertisementScreenState();
}

class _AdvertisementScreenState extends State<AdvertisementScreen> {
  final controller = AdvertisementController();

  @override
  void initState() {
    super.initState();
    if (controller.currentUser.address != null) {
      controller.cepController.text =
          controller.currentUser.address!.addressString();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _createAnnounce() {
    if (!controller.formValidate()) return;
    log(controller.titleController.text);
    log(controller.descriptionController.text);
    log(controller.categoryController.text);
    log(controller.cepController.text);
    log(controller.custController.text);
    log(controller.hidePhone.value.toString());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 12,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImagesListView(
                controller: controller,
                validator: true,
              ),
              AnimatedBuilder(
                animation: Listenable.merge(
                    [controller.valit, controller.imagesLength]),
                builder: (context, _) {
                  if ((controller.imagesLength.value == 0 &&
                          controller.valit.value == null) ||
                      controller.imagesLength.value > 0) {
                    return Container();
                  } else {
                    return Text(
                      'É obrigatório a adicione algumas imagens.',
                      style: TextStyle(
                        color: colorScheme.error,
                      ),
                    );
                  }
                },
              ),
              AdvertisementForm(controller: controller),
              BigButton(
                color: Colors.orange,
                label: 'Envia',
                onPress: _createAnnounce,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ImagesListView extends StatelessWidget {
  final AdvertisementController controller;
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
