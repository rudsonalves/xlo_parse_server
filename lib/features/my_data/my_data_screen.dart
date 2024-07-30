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
import 'package:xlo_mobx/components/others_widgets/state_loading_message.dart';
import 'package:xlo_mobx/features/my_data/my_data_state.dart';

import '../../common/validators/validators.dart';
import '../../components/buttons/big_button.dart';
import '../../components/form_fields/custom_form_field.dart';
import '../../components/form_fields/password_form_field.dart';
import '../../components/others_widgets/state_error_message.dart';
import '../shop/widgets/ad_text_subtitle.dart';
import 'my_data_controller.dart';

class MyDataScreen extends StatefulWidget {
  const MyDataScreen({super.key});

  static const routeName = '/mydata';

  @override
  State<MyDataScreen> createState() => _MyDataScreenState();
}

class _MyDataScreenState extends State<MyDataScreen> {
  final ctrl = MyDataController();

  @override
  void initState() {
    super.initState();

    ctrl.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Dados'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListenableBuilder(
          listenable: ctrl,
          builder: (context, _) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Form(
                      key: ctrl.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomFormField(
                            labelText: 'Nome',
                            hintText: 'Como aparecerá em seus anúncios',
                            controller: ctrl.nameController,
                            validator: DataValidator.name,
                            fullBorder: false,
                          ),
                          CustomFormField(
                            labelText: 'Telefone',
                            hintText: '(19) 9999-9999',
                            controller: ctrl.phoneController,
                            validator: DataValidator.phone,
                            keyboardType: TextInputType.phone,
                            fullBorder: false,
                          ),
                          PasswordFormField(
                            labelText: 'Senha',
                            hintText: '6+ letras e números',
                            passwordController: ctrl.passwordController,
                            validator: DataValidator.password,
                            textInputAction: TextInputAction.next,
                            nextFocusNode: ctrl.passwordFocusNode,
                            fullBorder: false,
                          ),
                          PasswordFormField(
                            labelText: 'Confirmar senha',
                            hintText: '6+ letras e números',
                            passwordController: ctrl.checkPasswordController,
                            focusNode: ctrl.passwordFocusNode,
                            fullBorder: false,
                            validator: (value) => DataValidator.checkPassword(
                              ctrl.passwordController.text,
                              value,
                            ),
                          ),
                          const AdTextSubtitle('Endereços:'),
                          Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: ctrl.addressNames.length,
                              itemBuilder: (context, index) {
                                final address = ctrl.addresses[index];
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      title: Text(address.name),
                                      subtitle: Text(
                                        address.addressString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          BigButton(
                            color: Colors.blue.withOpacity(0.75),
                            label: 'Salvar',
                            onPress: ctrl.updateUserData,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (ctrl.state is MyDataStateLoading)
                  const Positioned.fill(
                    child: StateLoadingMessage(),
                  ),
                if (ctrl.state is MyDataStateError)
                  const Positioned.fill(
                    child: StateErrorMessage(),
                  ),
              ],
            );
          }),
    );
  }
}
