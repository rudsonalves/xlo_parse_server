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

import '../../components/buttons/big_button.dart';
import 'address_controller.dart';
import 'address_state.dart';
import 'widgets/address_form.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  static const routeName = '/address';

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final controller = AddressController();

  @override
  void initState() {
    super.initState();
    controller.init();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _saveAddressFrom() {
    if (controller.valid) {
      controller.saveAddressFrom();
      Navigator.pop(context, controller.selectedAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Endereço'),
          centerTitle: true,
          // automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: _saveAddressFrom,
          ),
        ),
        body: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            String? errorText;
            if (controller.state is AddressStateError) {
              errorText = 'CEP Inválido';
            }
            return Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      child: Column(
                        children: [
                          AddressForm(
                            controller: controller,
                            errorText: errorText,
                          ),
                          BigButton(
                            color: Colors.deepPurpleAccent,
                            focusNode: controller.buttonFocus,
                            label: 'Salvar Endereço',
                            onPress: _saveAddressFrom,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (controller.state is AddressStateLoading)
                  const Positioned.fill(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
