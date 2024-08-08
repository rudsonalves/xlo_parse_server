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

import '../../common/models/ad.dart';
import '../../common/models/mechanic.dart';
import '../../common/singletons/app_settings.dart';
import '../../common/singletons/current_user.dart';
import '../../components/custon_field_controllers/currency_text_controller.dart';
import '../../get_it.dart';
import '../../manager/bgg_rank_manager.dart';
import '../../manager/mechanics_manager.dart';
import '../../repository/ad_repository.dart';
import 'edit_ad_state.dart';

class EditAdController extends ChangeNotifier {
  EditAdState _state = EditAdStateInitial();

  EditAdState get state => _state;

  final app = getIt<AppSettings>();
  final currentUser = getIt<CurrentUser>();
  final mechanicsManager = getIt<MechanicsManager>();
  final rankManager = getIt<BggRankManager>();

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  String? bggName;
  final descriptionController = TextEditingController();
  final mechanicsController = TextEditingController();
  final addressController = TextEditingController();
  final priceController = CurrencyTextController();
  final hidePhone = ValueNotifier<bool>(false);

  final _images = <String>[];
  final _imagesLength = ValueNotifier<int>(0);
  final List<int> _selectedMechIds = [];

  String _selectedAddressId = '';
  String get selectedAddressId => _selectedAddressId;
  ProductCondition _condition = ProductCondition.used;
  AdStatus _adStatus = AdStatus.pending;

  List<MechanicModel> get mechanics => mechanicsManager.mechanics;
  List<String> get mechanicsNames => mechanicsManager.mechanicsNames;
  ProductCondition get condition => _condition;
  AdStatus get adStatus => _adStatus;

  List<int> get selectedMechIds => _selectedMechIds;
  List<String> get selectedMachNames => mechanics
      .where((c) => _selectedMechIds.contains(c.id!))
      .map((c) => c.name)
      .toList();

  ValueNotifier<int> get imagesLength => _imagesLength;
  List<String> get images => _images;

  final _valit = ValueNotifier<bool?>(null);
  ValueNotifier<bool?> get valit => _valit;

  void init(AdModel? ad) {
    if (ad != null) {
      nameController.text = ad.title;
      bggName = rankManager.gameName(ad.bggId ?? -1);
      descriptionController.text = ad.description;
      hidePhone.value = ad.hidePhone;
      priceController.currencyValue = ad.price;
      setAdStatus(ad.status);
      setMechanicsIds(ad.mechanicsId);
      setSelectedAddress(ad.address.name);
      setImages(ad.images);
      setCondition(ad.condition);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    mechanicsController.dispose();
    addressController.dispose();
    priceController.dispose();
    _imagesLength.dispose();
    hidePhone.dispose();
    super.dispose();
  }

  void _changeState(EditAdState newState) {
    _state = newState;
    notifyListeners();
  }

  void addImage(String path) {
    _images.add(path);
    _imagesLength.value = _images.length;
  }

  void setImages(List<String> images) {
    _images.clear();
    _images.addAll(images);
    _imagesLength.value = _images.length;
  }

  void removeImage(int index) {
    final image = images[index];
    if (index < images.length) {
      if (image.contains(RegExp(r'^http'))) {
        _images.removeAt(index);
        _imagesLength.value = _images.length;
      } else {
        final file = File(image);
        _images.removeAt(index);
        _imagesLength.value = _images.length;
        file.delete();
      }
    }
  }

  void setMechanicsIds(List<int> mechanicsIds) {
    _selectedMechIds.clear();
    _selectedMechIds.addAll(
      mechanics.where((c) => mechanicsIds.contains(c.id!)).map((c) => c.id!),
    );
    mechanicsController.text = selectedMachNames.join(', ');
  }

  bool get formValit {
    _valit.value = formKey.currentState != null &&
        formKey.currentState!.validate() &&
        imagesLength.value > 0;
    return _valit.value!;
  }

  Future<AdModel?> updateAds(String id) async {
    if (!formValit) return null;
    try {
      _changeState(EditAdStateLoading());
      final ad = AdModel(
        id: id,
        owner: currentUser.user!,
        bggId: rankManager.gameId(bggName ?? ''),
        images: _images,
        title: nameController.text,
        description: descriptionController.text,
        mechanicsId: _selectedMechIds,
        address: currentUser.addresses
            .firstWhere((address) => address.id == _selectedAddressId),
        price: priceController.currencyValue,
        hidePhone: hidePhone.value,
        condition: _condition,
        status: _adStatus,
      );
      await AdRepository.update(ad);
      _changeState(EditAdStateSuccess());
      return ad;
    } catch (err) {
      log(err.toString());
      _changeState(EditAdStateError());
      return null;
    }
  }

  Future<AdModel?> createAds() async {
    if (!formValit) return null;
    try {
      _changeState(EditAdStateLoading());
      final ad = AdModel(
        owner: currentUser.user!,
        bggId: rankManager.gameId(bggName ?? ''),
        images: _images,
        title: nameController.text,
        description: descriptionController.text,
        mechanicsId: _selectedMechIds,
        address: currentUser.addresses
            .firstWhere((address) => address.id == _selectedAddressId),
        price: priceController.currencyValue,
        hidePhone: hidePhone.value,
        condition: _condition,
        status: _adStatus,
      );
      await AdRepository.save(ad);
      _changeState(EditAdStateSuccess());
      return ad;
    } catch (err) {
      log(err.toString());
      _changeState(EditAdStateError());
      return null;
    }
  }

  void setCondition(ProductCondition newCondition) {
    _condition = newCondition;
  }

  void setAdStatus(AdStatus newStatus) {
    _adStatus = newStatus;
  }

  void setSelectedAddress(String addressName) {
    final addressNames = currentUser.addressNames;
    if (addressNames.contains(addressName)) {
      final address = currentUser.addressByName(addressName)!;
      addressController.text = address.addressString();
      _selectedAddressId = address.id!;
    }
  }

  void gotoSuccess() {
    _changeState(EditAdStateSuccess());
  }
}
