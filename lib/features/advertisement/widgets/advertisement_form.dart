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
import '../../address/address_screen.dart';
import '../../mecanics/mecanics_screen.dart';
import '../advertisement_controller.dart';

class AdvertisementForm extends StatefulWidget {
  final AdvertisementController controller;

  const AdvertisementForm({
    super.key,
    required this.controller,
  });

  @override
  State<AdvertisementForm> createState() => _AdvertisementFormState();
}

class _AdvertisementFormState extends State<AdvertisementForm> {
  late final AdvertisementController controller;

  @override
  void initState() {
    super.initState();

    controller = widget.controller;
  }

  void _addMecanics() {
    Navigator.pushNamed(
      context,
      MecanicsScreen.routeName,
      arguments: {
        'selectedIds': controller.selectedMechanicsIds,
        'callBack': controller.getCategoriesIds
      },
    );
  }

  void _addAddress() {
    Navigator.pushNamed(context, AddressScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          CustomFormField(
            controller: controller.titleController,
            labelText: 'Título *',
            fullBorder: false,
            floatingLabelBehavior: null,
            validator: Validator.title,
          ),
          CustomFormField(
            controller: controller.descriptionController,
            labelText: 'Descrição *',
            fullBorder: false,
            maxLines: null,
            floatingLabelBehavior: null,
            validator: Validator.description,
          ),
          InkWell(
            onTap: _addMecanics,
            child: AbsorbPointer(
              child: CustomFormField(
                labelText: 'Mecânicas *',
                controller: controller.mechanicsController,
                fullBorder: false,
                maxLines: null,
                floatingLabelBehavior: null,
                readOnly: true,
                suffixIcon: const Icon(Icons.ads_click),
                validator: Validator.mechanics,
              ),
            ),
          ),
          InkWell(
            onTap: _addAddress,
            child: AbsorbPointer(
              child: CustomFormField(
                labelText: 'Endereço *',
                controller: controller.addressController,
                fullBorder: false,
                maxLines: null,
                floatingLabelBehavior: null,
                readOnly: true,
                suffixIcon: const Icon(Icons.ads_click),
                validator: Validator.address,
              ),
            ),
          ),
          CustomFormField(
            labelText: 'Preço *',
            controller: controller.priceController,
            fullBorder: false,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            floatingLabelBehavior: null,
            validator: Validator.cust,
          ),
          Row(
            children: [
              ValueListenableBuilder(
                valueListenable: controller.hidePhone,
                builder: (context, value, _) {
                  return Checkbox(
                    value: value,
                    onChanged: (value) {
                      if (value != null) {
                        controller.hidePhone.value = value;
                      }
                    },
                  );
                },
              ),
              const Expanded(
                child: Text('Ocultar meu telefone neste anúncio.'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
