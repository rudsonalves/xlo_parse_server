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

class CustomFormField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  CustomFormField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.nextFocusNode,
  });

  final errorString = ValueNotifier<String?>(null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ValueListenableBuilder(
        valueListenable: errorString,
        builder: (context, errorText, _) {
          return TextFormField(
            controller: controller,
            validator: validator,
            focusNode: focusNode,
            keyboardType: keyboardType,
            textInputAction: textInputAction ?? TextInputAction.next,
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              errorText: errorText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            onChanged: (value) {
              if (value.length > 2 && validator != null) {
                errorString.value = validator!(value);
              }
            },
            onFieldSubmitted: (value) {
              if (nextFocusNode != null) {
                FocusScope.of(context).requestFocus(nextFocusNode);
              }
            },
          );
        },
      ),
    );
  }
}
