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

  final user = CurrentUser.instance;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final zipCodeController = MaskedTextController(mask: '##.###-###');
  final streetController = TextEditingController();
  final numberController = TextEditingController();
  final complementController = TextEditingController();
  final neighborhoodController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();

  final zipFocus = FocusNode();
  final numberFocus = FocusNode();
  final complementFocus = FocusNode();
  final buttonFocus = FocusNode();

  Map<String, AddressModel> get addresses => user.addresses;

  bool zipCodeReativit = true;
  String _selectedAddress = '';
  String get selectedAddress => _selectedAddress;

  bool get valid {
    return formKey.currentState != null && formKey.currentState!.validate();
  }

  void init() {
    zipCodeController.addListener(_checkZipCodeReady);

    String defaultKey = 'Padrão';

    if (addresses.isEmpty) return;
    if (!addresses.containsKey(defaultKey) &&
        addresses.containsKey('Residencial')) {
      defaultKey = 'Residencial';
    } else {
      return;
    }
    setFormFromAdresses(defaultKey);
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
    zipFocus.dispose();
    super.dispose();
  }

  void setFormFromAdresses(String addressKey) {
    _selectedAddress = addressKey;
    nameController.text = addresses[addressKey]!.name;
    zipCodeReativit = false;
    zipCodeController.text = addresses[addressKey]!.zipCode;
    streetController.text = addresses[addressKey]!.street;
    numberController.text = addresses[addressKey]!.number;
    complementController.text = addresses[addressKey]!.complement ?? '';
    neighborhoodController.text = addresses[addressKey]!.neighborhood;
    cityController.text = addresses[addressKey]!.city;
    stateController.text = addresses[addressKey]!.state;
    zipCodeReativit = true;
  }

  Future<void> getAddressFromViacep() async {
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
        userId: user.userId,
        street: streetController.text,
        number: numberController.text,
        complement: complementController.text,
        neighborhood: neighborhoodController.text,
        state: stateController.text,
        city: cityController.text,
      );

      if (addresses.containsKey(newAddress.name)) {
        newAddress.id = addresses[newAddress.name]!.id;
      }
      if (addresses[newAddress.name] != newAddress) {
        await AddressRepository.saveAddress(newAddress);
      }
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
      getAddressFromViacep();
    } else {
      streetController.text = '';
      neighborhoodController.text = '';
      cityController.text = '';
      stateController.text = '';
    }
  }

  void changeAddressType(String? addressType) {
    if (addressType == null || !addresses.containsKey(addressType)) return;
    setFormFromAdresses(addressType);
  }
}
