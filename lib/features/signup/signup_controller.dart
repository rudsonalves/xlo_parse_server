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
import '../../common/singletons/app_settings.dart';
import '../../components/form_fields/masked_text_controller.dart';
import '../../repository/user_repository.dart';

class SignupController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final checkPasswordController = TextEditingController();
  final nicknameController = TextEditingController();
  final phoneController = MaskedTextController(mask: '(##) ####-#####');

  final app = AppSettings.instance;

  final emailFocusNode = FocusNode();
  final celularFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final checkPassFocusNode = FocusNode();

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
  }

  Future<User?> signupUser() async {
    final user = User(
      name: nicknameController.text,
      email: emailController.text,
      phone: phoneController.text,
      password: passwordController.text,
    );

    return await UserRepository.signUp(user);
  }
}
