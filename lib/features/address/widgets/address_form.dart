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

import '../../../common/validators/validators.dart';
import '../../../components/form_fields/custom_form_field.dart';
import '../../../components/form_fields/dropdown_form_field.dart';
import '../address_controller.dart';

class AddressForm extends StatelessWidget {
  AddressForm({
    super.key,
    required this.controller,
    required this.errorText,
  });

  final AddressController controller;
  final String? errorText;

  final List<String> addressType = ['Residencial', 'Comercial'];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          DropdownFormField(
            controller: controller.nameController,
            labelText: 'Tipo de Endereço',
            hintText: 'Residencial, Comercial, ...',
            fullBorder: false,
            stringList: addressType,
          ),
          CustomFormField(
            labelText: 'CEP',
            controller: controller.zipCodeController,
            fullBorder: false,
            floatingLabelBehavior: null,
            validator: Validator.zipCode,
            keyboardType: TextInputType.number,
            errorText: errorText,
            nextFocusNode: controller.numberFocus,
            suffixIcon: IconButton(
              onPressed: controller.getAddress,
              icon: const Icon(Icons.refresh),
            ),
          ),
          CustomFormField(
            labelText: 'Logadouro',
            controller: controller.streetController,
            fullBorder: false,
            readOnly: true,
            floatingLabelBehavior: null,
            // validator: Validator.zipCode,
            suffixIcon: const Icon(Icons.auto_fix_high),
          ),
          CustomFormField(
            labelText: 'Número',
            controller: controller.numberController,
            fullBorder: false,
            floatingLabelBehavior: null,
            // validator: Validator.zipCode,
            keyboardType: TextInputType.streetAddress,
            focusNode: controller.numberFocus,
            nextFocusNode: controller.complementFocus,
          ),
          CustomFormField(
            labelText: 'Complemento',
            controller: controller.complementController,
            fullBorder: false,
            floatingLabelBehavior: null,
            focusNode: controller.complementFocus,
            nextFocusNode: controller.buttonFocus,
          ),
          CustomFormField(
            labelText: 'Bairro',
            controller: controller.neighborhoodController,
            fullBorder: false,
            readOnly: true,
            floatingLabelBehavior: null,
            suffixIcon: const Icon(Icons.auto_fix_high),
          ),
          CustomFormField(
            labelText: 'Estado',
            controller: controller.stateController,
            fullBorder: false,
            readOnly: true,
            floatingLabelBehavior: null,
            suffixIcon: const Icon(Icons.auto_fix_high),
          ),
          CustomFormField(
            labelText: 'Cidade',
            controller: controller.cityController,
            fullBorder: false,
            readOnly: true,
            floatingLabelBehavior: null,
            suffixIcon: const Icon(Icons.auto_fix_high),
          ),
        ],
      ),
    );
  }
}
