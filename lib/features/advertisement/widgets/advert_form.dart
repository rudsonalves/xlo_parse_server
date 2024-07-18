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
import '../advert_controller.dart';

class AdvertForm extends StatefulWidget {
  final AdvertController controller;

  const AdvertForm({
    super.key,
    required this.controller,
  });

  @override
  State<AdvertForm> createState() => _AdvertFormState();
}

class _AdvertFormState extends State<AdvertForm> {
  AdvertController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _addMecanics() async {
    final result = await Navigator.pushNamed(
      context,
      MecanicsScreen.routeName,
      arguments: controller.selectedMechIds,
    ) as List<String>?;

    if (result != null) {
      controller.setMechanicsIds(result);
      if (mounted) FocusScope.of(context).nextFocus();
    }
  }

  Future<void> _addAddress() async {
    final addressName =
        await Navigator.pushNamed(context, AddressScreen.routeName) as String;
    controller.setSelectedAddress(addressName);
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
            textCapitalization: TextCapitalization.sentences,
            validator: Validator.title,
          ),
          CustomFormField(
            controller: controller.descriptionController,
            labelText: 'Descrição *',
            fullBorder: false,
            maxLines: null,
            floatingLabelBehavior: null,
            textCapitalization: TextCapitalization.sentences,
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
