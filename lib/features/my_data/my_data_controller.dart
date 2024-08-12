// Copyright (C) 2024 Rudson Alves
//
// This file is part of bgbazzar.
//
// bgbazzar is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// bgbazzar is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with bgbazzar.  If not, see <https://www.gnu.org/licenses/>.

import 'dart:developer';

import 'package:flutter/material.dart';

import '../../common/models/user.dart';
import '../../common/utils/extensions.dart';
import '../../common/models/address.dart';
import '../../common/singletons/current_user.dart';
import '../../components/custon_field_controllers/masked_text_controller.dart';
import '../../get_it.dart';
import '../../manager/address_manager.dart';
import '../../repository/parse_server/user_repository.dart';

class MyDataController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = MaskedTextController(mask: '(##) ####-#####');
  final passwordController = TextEditingController();
  final checkPasswordController = TextEditingController();

  final passwordFocusNode = FocusNode();

  final user = getIt<CurrentUser>().user!;

  final addressManager = getIt<AddressManager>();
  List<AddressModel> get addresses => addressManager.addresses;
  List<String> get addressNames => addressManager.addressNames.toList();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    checkPasswordController.dispose();
    passwordFocusNode.dispose();

    super.dispose();
  }

  void init() {
    nameController.text = user.name ?? '';
    phoneController.text = user.phone ?? '';
  }

  bool get haveChanges {
    return (nameController.text.isNotEmpty &&
            nameController.text != user.name) ||
        (phoneController.text.isNotEmpty &&
            phoneController.text.onlyNumbers() != user.phone!.onlyNumbers()) ||
        (passwordController.text.trim().isNotEmpty &&
            checkPasswordController.text.trim().isNotEmpty &&
            passwordController.text.trim() ==
                checkPasswordController.text.trim());
  }

  bool get valid {
    return (formKey.currentState != null && formKey.currentState!.validate());
  }

  Future<void> updateUserData() async {
    try {
      final newName = nameController.text.trim();
      final newPhone = phoneController.text;
      final newPass = passwordController.text.trim();

      if (haveChanges && valid) {
        final newUser = UserModel(email: 'none@none');
        newUser.id = user.id;
        newUser.name =
            newName.isNotEmpty && newName != user.name ? newName : null;
        newUser.phone = newPhone.isNotEmpty &&
                newPhone.onlyNumbers() != user.phone!.onlyNumbers()
            ? newPhone
            : null;
        newUser.password = newPass.isNotEmpty ? newPass : null;

        await UserRepository.update(newUser);

        user.name = newUser.name ?? user.name;
        user.phone = newUser.phone ?? user.phone;
      }
    } catch (err) {
      log(err.toString());
    }
  }
}
