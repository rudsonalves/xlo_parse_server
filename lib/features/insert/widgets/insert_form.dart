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

import '../../../components/form_fields/custom_form_field.dart';
import '../insert_controller.dart';

class InsertForm extends StatefulWidget {
  final InsertController controller;

  const InsertForm({
    super.key,
    required this.controller,
  });

  @override
  State<InsertForm> createState() => _InsertFormState();
}

class _InsertFormState extends State<InsertForm> {
  final hidePhone = ValueNotifier<bool>(false);

  @override
  void dispose() {
    super.dispose();
    hidePhone.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          CustomFormField(
            controller: widget.controller.titleController,
            labelText: 'Título *',
            fullBorder: false,
            floatingLabelBehavior: null,
          ),
          CustomFormField(
            controller: widget.controller.descriptionController,
            labelText: 'Descrição *',
            fullBorder: false,
            maxLines: null,
            floatingLabelBehavior: null,
          ),
          DropdownButtonFormField(
            hint: const Text('Categoria *'),
            items: const [
              DropdownMenuItem<String>(
                value: 'Carros',
                child: Text('Carros'),
              ),
              DropdownMenuItem<String>(
                value: 'Roupas',
                child: Text('Roupas'),
              ),
              DropdownMenuItem<String>(
                value: 'Brinquedos',
                child: Text('Brinquedos'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                widget.controller.categoryController.text = value;
              }
            },
          ),
          CustomFormField(
            labelText: 'CEP *',
            controller: widget.controller.cepController,
            fullBorder: false,
            keyboardType: TextInputType.number,
            floatingLabelBehavior: null,
          ),
          CustomFormField(
            labelText: 'Preço *',
            controller: widget.controller.custController,
            fullBorder: false,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            floatingLabelBehavior: null,
          ),
          Row(
            children: [
              ValueListenableBuilder(
                valueListenable: hidePhone,
                builder: (context, value, _) {
                  return Checkbox(
                    value: value,
                    onChanged: (value) {
                      if (value != null) {
                        hidePhone.value = value;
                      }
                    },
                  );
                },
              ),
              const Text('Ocultar meu telefone neste anúncio.'),
            ],
          ),
        ],
      ),
    );
  }
}
