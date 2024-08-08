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
import 'package:xlo_mobx/components/buttons/big_button.dart';

import '../../../common/models/advert.dart';
import '../../../common/validators/validators.dart';
import '../../../components/form_fields/custom_form_field.dart';
import '../../../components/others_widgets/fitted_button_segment.dart';
import '../../address/address_screen.dart';
import '../../boardgames/boardgame_screen.dart';
import '../../mecanics/mecanics_screen.dart';
import '../edit_advert_controller.dart';

class AdvertForm extends StatefulWidget {
  final EditAdvertController controller;

  const AdvertForm({
    super.key,
    required this.controller,
  });

  @override
  State<AdvertForm> createState() => _AdvertFormState();
}

class _AdvertFormState extends State<AdvertForm> {
  EditAdvertController get ctrl => widget.controller;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _addMecanics() async {
    final result = await Navigator.pushNamed(
      context,
      MecanicsScreen.routeName,
      arguments: ctrl.selectedMechIds,
    ) as List<int>?;

    if (result != null) {
      ctrl.setMechanicsIds(result);
      if (mounted) FocusScope.of(context).nextFocus();
    }
  }

  Future<void> _addAddress() async {
    final addressName =
        await Navigator.pushNamed(context, AddressScreen.routeName) as String;
    ctrl.setSelectedAddress(addressName);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: ctrl.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomFormField(
            controller: ctrl.nameController,
            labelText: 'Nome do Jogo *',
            fullBorder: false,
            maxLines: null,
            floatingLabelBehavior: null,
            textCapitalization: TextCapitalization.sentences,
            validator: Validator.title,
          ),
          Center(
            child: BigButton(
              color: Colors.cyan.withOpacity(0.45),
              onPressed: () {
                Navigator.pushNamed(context, BoardgamesScreen.routeName);
              },
              label: 'Informações do Jogo',
            ),
          ),
          CustomFormField(
            controller: ctrl.descriptionController,
            labelText: 'Descreva o estado do Jogo *',
            fullBorder: false,
            maxLines: null,
            floatingLabelBehavior: null,
            textCapitalization: TextCapitalization.sentences,
            validator: Validator.description,
          ),
          const Text('Produto'),
          Row(
            children: [
              Expanded(
                child: SegmentedButton<ProductCondition>(
                  segments: const [
                    ButtonSegment(
                      value: ProductCondition.used,
                      label: Text('Usado'),
                      icon: Icon(Icons.recycling),
                    ),
                    ButtonSegment(
                      value: ProductCondition.sealed,
                      label: Text('Lacrado'),
                      icon: Icon(Icons.new_releases_outlined),
                    ),
                  ],
                  selected: {ctrl.condition},
                  onSelectionChanged: (p0) {
                    setState(() {
                      ctrl.setCondition(p0.first);
                    });
                  },
                ),
              ),
            ],
          ),
          InkWell(
            onTap: _addMecanics,
            child: AbsorbPointer(
              child: CustomFormField(
                labelText: 'Mecânicas *',
                controller: ctrl.mechanicsController,
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
                controller: ctrl.addressController,
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
            controller: ctrl.priceController,
            fullBorder: false,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            floatingLabelBehavior: null,
            validator: Validator.cust,
          ),
          Row(
            children: [
              ValueListenableBuilder(
                valueListenable: ctrl.hidePhone,
                builder: (context, value, _) {
                  return Checkbox(
                    value: value,
                    onChanged: (value) {
                      if (value != null) {
                        ctrl.hidePhone.value = value;
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
          const Text('Status do Anúncio'),
          Row(
            children: [
              Expanded(
                child: SegmentedButton<AdvertStatus>(
                  segments: [
                    FittedButtonSegment(
                      value: AdvertStatus.pending,
                      label: 'Pendente',
                      iconData: Icons.hourglass_empty,
                    ),
                    FittedButtonSegment(
                      value: AdvertStatus.active,
                      label: 'Ativo',
                      iconData: Icons.verified,
                    ),
                    FittedButtonSegment(
                      value: AdvertStatus.sold,
                      label: 'Vendido',
                      iconData: Icons.attach_money,
                    ),
                  ],
                  selected: {ctrl.adStatus},
                  onSelectionChanged: (p0) {
                    setState(() {
                      ctrl.setAdStatus(p0.first);
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
