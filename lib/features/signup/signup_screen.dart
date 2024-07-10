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

import '../../common/validators/validators.dart';
import '../../components/buttons/big_button.dart';
import '../../components/dialogs/simple_message.dart';
import '../../components/form_fields/custom_form_field.dart';
import '../../components/form_fields/password_form_field.dart';
import '../login/login_screen.dart';
import 'signup_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const routeName = '/signup';
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = SignupController();

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  Future<void> signupUser() async {
    final valid =
        _formKey.currentState != null && _formKey.currentState!.validate();
    if (valid) {
      try {
        final user = await _controller.signupUser();
        log(user.toString());
        if (!mounted) return;
        await SimpleMessage.open(
          context,
          title: 'Usuário Criado',
          message: 'Usuário foi criado com sucesso.'
              ' Agora pode logar em sua conta.',
        );
        if (mounted) Navigator.pop(context);
        return;
      } catch (err) {
        final errCode = err.toString().split(':')[0];

        String message;
        switch (errCode) {
          case '203':
            message = 'Este e-mail já foi utilizado. Tente '
                'um outro e-mail ou recupere a senha na página de login.';
          default:
            message = 'Desculpe. Ocorreu um erro. Favor tentar mais tarde.';
        }
        if (!mounted) return;
        await SimpleMessage.open(
          context,
          title: 'Ocorreu um Error',
          message: message,
          type: MessageType.error,
        );
        log(err.toString());
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: _controller.app.isDark
          ? null
          : colorScheme.onPrimary.withOpacity(0.85),
      appBar: AppBar(
        title: const Text('Cadastrar'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            color: _controller.app.isDark
                ? colorScheme.primary.withOpacity(.15)
                : null,
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
                          controller: _controller.nicknameController,
                          validator: Validator.nickname,
                          nextFocusNode: _controller.emailFocusNode,
                        ),
                        CustomFormField(
                          labelText: 'E-mail',
                          hintText: 'seu-email@provedor.com',
                          controller: _controller.emailController,
                          validator: Validator.email,
                          keyboardType: TextInputType.emailAddress,
                          focusNode: _controller.emailFocusNode,
                          nextFocusNode: _controller.celularFocusNode,
                        ),
                        CustomFormField(
                          labelText: 'Celular',
                          hintText: '(19) 9999-9999',
                          controller: _controller.phoneController,
                          validator: Validator.phone,
                          keyboardType: TextInputType.phone,
                          focusNode: _controller.celularFocusNode,
                          nextFocusNode: _controller.passwordFocusNode,
                        ),
                        PasswordFormField(
                          labelText: 'Senha',
                          hintText: '6+ letras e números',
                          passwordController: _controller.passwordController,
                          validator: Validator.password,
                          focusNode: _controller.passwordFocusNode,
                          textInputAction: TextInputAction.next,
                          nextFocusNode: _controller.checkPassFocusNode,
                        ),
                        PasswordFormField(
                          labelText: 'Confirmar senha',
                          hintText: '6+ letras e números',
                          passwordController:
                              _controller.checkPasswordController,
                          focusNode: _controller.checkPassFocusNode,
                          validator: (value) => Validator.checkPassword(
                            _controller.passwordController.text,
                            value,
                          ),
                        ),
                        BigButton(
                          color: Colors.amber,
                          label: 'Registrar',
                          onPress: signupUser,
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
