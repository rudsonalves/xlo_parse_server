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
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'photo_origin_bottom_sheet.dart';

const maxImages = 5;

class ImageGallery extends StatefulWidget {
  final int length;
  final List<String> images;
  final void Function(String path) addImage;
  final void Function(int index) removeImage;

  const ImageGallery({
    super.key,
    required this.length,
    required this.images,
    required this.addImage,
    required this.removeImage,
  });

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  Future<void> getFromCamera() async {
    Navigator.pop(context);
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    imageSelected(image);
  }

  Future<void> getFromGallery() async {
    Navigator.pop(context);
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    imageSelected(image);
  }

  Future<void> imageSelected(XFile? image) async {
    final colorScheme = Theme.of(context).colorScheme;

    if (image == null) return;
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cortar Imagem',
            toolbarColor: colorScheme.primary,
            toolbarWidgetColor: colorScheme.onPrimary,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cortar Imagem',
          cancelButtonTitle: 'Cancelar',
          doneButtonTitle: 'Concluir',
        ),
      ],
    );

    if (croppedFile != null) {
      log(croppedFile.path);
      widget.addImage(croppedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.length < maxImages ? widget.length + 1 : maxImages,
      itemBuilder: (context, index) {
        if (index < widget.length) {
          return Padding(
            padding: const EdgeInsets.all(2),
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    backgroundColor: colorScheme.onSecondary,
                    title: const Text('Image'),
                    content: Image.file(
                      File(widget.images[index]),
                    ),
                    actions: [
                      TextButton.icon(
                        onPressed: () {
                          widget.removeImage(index);
                          Navigator.pop(context);
                        },
                        label: const Text('Remover'),
                        icon: const Icon(Icons.delete),
                      ),
                      TextButton.icon(
                        onPressed: Navigator.of(context).pop,
                        label: const Text('Fechar'),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                );
              },
              child: SizedBox(
                width: 108,
                height: 108,
                child: Image.file(
                  File(
                    widget.images[index],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(2),
            child: SizedBox(
              width: 108,
              height: 108,
              child: IconButton.filledTonal(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => PhotoOriginBottomSheet(
                      getFromCamera: getFromCamera,
                      getFromGallery: getFromGallery,
                    ),
                  );
                },
                icon: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 55,
                    ),
                    Text('+ inserir'),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
