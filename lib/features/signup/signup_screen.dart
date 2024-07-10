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

import '../../common/singletons/app_settings.dart';
import '../../common/validators/validators.dart';
import '../../components/buttons/big_button.dart';
import '../../components/form_fields/custom_form_field.dart';
import '../../components/form_fields/password_form_field.dart';
import '../login/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const routeName = '/signup';
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final checkPasswordController = TextEditingController();
  final nicknameController = TextEditingController();
  final phoneController = TextEditingController();
  final app = AppSettings.instance;

  final emailFocusNode = FocusNode();
  final celularFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final checkPassFocusNode = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    checkPasswordController.dispose();
    nicknameController.dispose();
    phoneController.dispose();

    emailFocusNode.dispose();
    celularFocusNode.dispose();
    passwordFocusNode.dispose();
    checkPassFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor:
          app.isDark ? null : colorScheme.onPrimary.withOpacity(0.85),
      appBar: AppBar(
        title: const Text('Cadastrar'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            color: app.isDark ? colorScheme.primary.withOpacity(.15) : null,
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BigButton(
                    color: Colors.blue,
                    label: 'Cadastrar com Facebook',
                    onPress: () {},
                  ),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('ou'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomFormField(
                          labelText: 'Apelido',
                          hintText: 'Como aparecerá em seus anúncios',
                          controller: nicknameController,
                          validator: Validator.nickname,
                          nextFocusNode: emailFocusNode,
                        ),
                        CustomFormField(
                          labelText: 'E-mail',
                          hintText: 'seu-email@provedor.com',
                          controller: emailController,
                          validator: Validator.email,
                          keyboardType: TextInputType.emailAddress,
                          focusNode: emailFocusNode,
                          nextFocusNode: celularFocusNode,
                        ),
                        CustomFormField(
                          labelText: 'Celular',
                          hintText: '(19) 9999-9999',
                          controller: phoneController,
                          validator: Validator.phone,
                          keyboardType: TextInputType.phone,
                          focusNode: celularFocusNode,
                          nextFocusNode: passwordFocusNode,
                        ),
                        PasswordFormField(
                          labelText: 'Senha',
                          hintText: '6+ letras e números',
                          passwordController: passwordController,
                          validator: Validator.password,
                          focusNode: passwordFocusNode,
                          textInputAction: TextInputAction.next,
                          nextFocusNode: checkPassFocusNode,
                        ),
                        PasswordFormField(
                          labelText: 'Confirmar senha',
                          hintText: '6+ letras e números',
                          passwordController: checkPasswordController,
                          focusNode: checkPassFocusNode,
                          validator: (value) => Validator.checkPassword(
                            passwordController.text,
                            value,
                          ),
                        ),
                        BigButton(
                          color: Colors.amber,
                          label: 'Registrar',
                          onPress: () {
                            final valid = _formKey.currentState != null &&
                                _formKey.currentState!.validate();
                            if (valid) {
                              log('${emailController.text}, ${passwordController.text}');
                            }
                          },
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Possui uma conta?'),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                  context,
                                  LoginScreen.routeName,
                                );
                              },
                              child: const Text('Entrar'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
