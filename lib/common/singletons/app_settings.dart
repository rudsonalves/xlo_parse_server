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

import '../../repository/user_repository.dart';
import '../models/user.dart';

class AppSettings {
  AppSettings._();
  static final _instance = AppSettings._();
  static AppSettings get instance => _instance;

  final ValueNotifier<Brightness> _brightness =
      ValueNotifier<Brightness>(Brightness.dark);
  // late final ValueNotifier<Contrast> _contrast;
  UserModel? user;

  bool get isLogin => user != null;

  ValueNotifier<Brightness> get brightness => _brightness;
  bool get isDark => _brightness.value == Brightness.dark;

  Future<void> init() async {
    user = await UserRepository.getCurrentUser();
  }

  void toggleBrightnessMode() {
    _brightness.value = _brightness.value == Brightness.dark
        ? Brightness.light
        : Brightness.dark;
  }

  void setBrightnessMode(Brightness brightness) {
    _brightness.value = brightness;
  }

  void dispose() {
    _brightness.dispose();
  }
}
