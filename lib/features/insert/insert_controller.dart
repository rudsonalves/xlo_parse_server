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

import 'dart:io';

import 'package:flutter/material.dart';

import '../../common/singletons/app_settings.dart';
import '../../components/custon_field_controllers/currency_text_controller.dart';
import '../../components/custon_field_controllers/masked_text_controller.dart';

class InsertController {
  final app = AppSettings.instance;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final cepController = MaskedTextController(mask: '###.###.###-##');
  final custController = CurrencyTextController();

  final _images = <String>[];
  final _imagesLength = ValueNotifier<int>(0);

  ValueNotifier<int> get imagesLength => _imagesLength;
  List<String> get images => _images;

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    cepController.dispose();
    custController.dispose();
    _imagesLength.dispose();
  }

  void addImage(String path) {
    _images.add(path);
    _imagesLength.value = _images.length;
  }

  void removeImage(int index) {
    if (index < images.length) {
      final file = File(images[index]);
      _images.removeAt(index);
      _imagesLength.value = _images.length;
      file.delete();
    }
  }
}
