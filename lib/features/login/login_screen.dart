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
import '../signup/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordFocusNode = FocusNode();
  final app = AppSettings.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor:
          app.isDark ? null : colorScheme.onPrimary.withOpacity(0.85),
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,
        elevation: 5,
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
                    label: 'Entrar com Facebook',
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
                        const Text('Acessar com E-mail'),
                        CustomFormField(
                          labelText: 'E-mail',
                          hintText: 'seu-email@provedor.com',
                          controller: emailController,
                          validator: Validator.email,
                          keyboardType: TextInputType.emailAddress,
                          nextFocusNode: passwordFocusNode,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {},
                            child: Text(
                              'Esqueceu a senha?',
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        PasswordFormField(
                          labelText: 'Senha',
                          passwordController: passwordController,
                          validator: Validator.password,
                          focusNode: passwordFocusNode,
                        ),
                        BigButton(
                          color: Colors.amber,
                          label: 'Entrar',
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
                            const Text('Não possui uma conta?'),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                  context,
                                  SignUpScreen.routeName,
                                );
                              },
                              child: const Text('Cadastrar'),
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
