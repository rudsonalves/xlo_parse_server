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

import '../../common/models/advert.dart';
import '../../common/models/category.dart';
import '../../common/singletons/app_settings.dart';
import '../../common/singletons/current_user.dart';
import '../../components/custon_field_controllers/currency_text_controller.dart';
import '../../manager/mechanics_manager.dart';
import '../../repository/advert_repository.dart';

class AdvertController {
  final app = AppSettings.instance;
  final currentUser = CurrentUser.instance;
  final mechanicsManager = MechanicsManager.instance;

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final mechanicsController = TextEditingController();
  final addressController = TextEditingController();
  final priceController = CurrencyTextController();
  final hidePhone = ValueNotifier<bool>(false);

  final _images = <String>[];
  final _imagesLength = ValueNotifier<int>(0);
  final List<MechanicModel> _selectedMechanics = [];

  String _selectedAddressId = '';
  String get selectedAddressId => _selectedAddressId;

  List<MechanicModel> get mechanics => mechanicsManager.mechanics;
  List<String> get mechanicsNames => mechanicsManager.mechanicsNames;

  List<String> get selectedMechanicsIds =>
      _selectedMechanics.map((c) => c.id!).toList();
  List<String> get selectedCategoriesNames =>
      _selectedMechanics.map((c) => c.name!).toList();

  ValueNotifier<int> get imagesLength => _imagesLength;
  List<String> get images => _images;

  final _valit = ValueNotifier<bool?>(null);
  ValueNotifier<bool?> get valit => _valit;

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    mechanicsController.dispose();
    addressController.dispose();
    priceController.dispose();
    _imagesLength.dispose();
    hidePhone.dispose();
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

  void setMechanicsIds(List<String> mechanicsIds) {
    _selectedMechanics.clear();
    _selectedMechanics.addAll(
      mechanics.where((c) => mechanicsIds.contains(c.id!)),
    );
    mechanicsController.text = selectedCategoriesNames.join(', ');
  }

  bool get formValit {
    _valit.value = formKey.currentState != null &&
        formKey.currentState!.validate() &&
        imagesLength.value > 0;
    return _valit.value!;
  }

  Future<void> createAnnounce() async {
    if (!formValit) return;

    final ad = AdvertModel(
      userId: currentUser.userId,
      images: _images,
      title: titleController.text,
      description: descriptionController.text,
      mechanicsId: [mechanicsController.text],
      addressId: addressController.text,
      price: double.parse(priceController.text),
      hidePhone: hidePhone.value,
    );

    await AdvertRepository.save(ad);
  }

  void setSelectedAddress(String addressKey) {
    final addresses = currentUser.addresses;
    if (addresses.containsKey(addressKey)) {
      final address = currentUser.addresses[addressKey]!;
      addressController.text = address.addressString();
      _selectedAddressId = address.id!;
    }
  }
}