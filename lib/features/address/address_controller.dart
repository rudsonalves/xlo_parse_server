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

import 'package:flutter/material.dart';

import '../../common/models/address.dart';
import '../../common/singletons/current_user.dart';
import '../../components/custon_field_controllers/masked_text_controller.dart';
import '../../repository/address_repository.dart';
import '../../repository/viacep_repository.dart';
import 'address_state.dart';

class AddressController extends ChangeNotifier {
  AddressState _state = AddressStateInitial();

  AddressState get state => _state;

  void _changeState(AddressState newState) {
    _state = newState;
    notifyListeners();
  }

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final zipCodeController = MaskedTextController(mask: '##.###-###');
  final streetController = TextEditingController();
  final numberController = TextEditingController();
  final complementController = TextEditingController();
  final neighborhoodController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();

  final numberFocus = FocusNode();
  final complementFocus = FocusNode();
  final buttonFocus = FocusNode();

  final currentUser = CurrentUser.instance;

  bool zipCodeReativit = true;

  void init() {
    zipCodeController.addListener(_checkZipCodeReady);

    final addresses = currentUser.addresses;
    String defaultKey = 'padrão';

    if (addresses.isEmpty) return;
    if (!addresses.containsKey(defaultKey) &&
        addresses.containsKey('residencial')) {
      defaultKey = 'residencial';
    } else {
      return;
    }

    nameController.text = currentUser.addresses[defaultKey]!.name;
    zipCodeReativit = false;
    zipCodeController.text = addresses[defaultKey]!.zipCode;
    streetController.text = addresses[defaultKey]!.street;
    numberController.text = addresses[defaultKey]!.number;
    complementController.text = addresses[defaultKey]!.complement ?? '';
    neighborhoodController.text = addresses[defaultKey]!.neighborhood;
    cityController.text = addresses[defaultKey]!.city;
    stateController.text = addresses[defaultKey]!.state;
    zipCodeReativit = true;
  }

  @override
  void dispose() {
    nameController.dispose();
    zipCodeController.dispose();
    streetController.dispose();
    numberController.dispose();
    complementController.dispose();
    neighborhoodController.dispose();
    cityController.dispose();
    stateController.dispose();
    numberFocus.dispose();
    complementFocus.dispose();
    buttonFocus.dispose();
    super.dispose();
  }

  Future<void> getAddress() async {
    try {
      _changeState(AddressStateLoading());
      final response =
          await ViacepRepository.getLocalByCEP(zipCodeController.text);
      streetController.text = response.logradouro;
      neighborhoodController.text = response.bairro;
      cityController.text = response.localidade;
      stateController.text = response.uf;
      _changeState(AddressStateSuccess());
    } catch (err) {
      log(err.toString());
      _changeState(AddressStateError());
    }
  }

  Future<void> saveAddressFrom() async {
    try {
      _changeState(AddressStateLoading());
      final newAddress = AddressModel(
        name: nameController.text,
        zipCode: zipCodeController.text,
        userId: currentUser.userId,
        street: streetController.text,
        number: numberController.text,
        complement: complementController.text,
        neighborhood: neighborhoodController.text,
        state: stateController.text,
        city: cityController.text,
      );
      await AddressRepository.saveAddress(newAddress);
      _changeState(AddressStateSuccess());
    } catch (err) {
      log(err.toString());
      _changeState(AddressStateError());
    }
  }

  void _checkZipCodeReady() {
    if (!zipCodeReativit) return;
    final cleanZip = zipCodeController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanZip.length == 8) {
      getAddress();
    } else {
      streetController.text = '';
      neighborhoodController.text = '';
      cityController.text = '';
      stateController.text = '';
    }
  }
}
