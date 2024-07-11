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

import '../../common/models/user.dart';
import '../../common/parse_server/errors_mensages.dart';
import '../../components/buttons/big_button.dart';
import '../../components/dialogs/simple_message.dart';
import '../signup/signup_screen.dart';
import 'login_controller.dart';
import 'login_state.dart';
import 'widgets/login_form.dart';
import '../../components/others_widgets/or_row.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _controller = LoginController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  Future<void> _userLogin() async {
    final valid =
        _formKey.currentState != null && _formKey.currentState!.validate();

    if (valid) {
      try {
        final user = await _controller.login(
          UserModel(
            email: _controller.emailController.text,
            password: _controller.passwordController.text,
          ),
        );

        if (user == null || user.id == null) {
          throw Exception(
              '-1	Error code indicating that an unknown error or an error unrelated to Parse occurred.');
        }

        if (mounted) Navigator.pop(context);
        return;
      } catch (err) {
        if (!mounted) return;
        await SimpleMessage.open(
          context,
          title: 'Ocorreu um Error',
          message: ParserServerErrors.message(err),
          type: MessageType.error,
        );

        return;
      }
    }
  }

  void _navSignUp() {
    Navigator.pop(context);
    Navigator.pushNamed(
      context,
      SignUpScreen.routeName,
    );
  }

  void _navLostPassword() {
    // TODO: not implemented
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: _controller.app.isDark
          ? null
          : colorScheme.onPrimary.withOpacity(0.85),
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,
        elevation: 5,
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          return Stack(
            children: [
              Positioned.fill(
                child: Center(
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
                              label: 'Entrar com Facebook',
                              onPress: () {},
                            ),
                            const OrRow(),
                            LoginForm(
                              formKey: _formKey,
                              controller: _controller,
                              userLogin: _userLogin,
                              navSignUp: _navSignUp,
                              navLostPassword: _navLostPassword,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (_controller.state is LoginStateLoading)
                const Positioned.fill(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
