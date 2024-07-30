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

import 'package:get_it/get_it.dart';

import 'common/singletons/app_settings.dart';
import 'common/singletons/current_user.dart';
import 'common/singletons/search_filter.dart';
import 'common/singletons/search_history.dart';
import 'features/base/base_controller.dart';
import 'manager/address_manager.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  try {
    getIt.registerSingleton<AppSettings>(AppSettings());

    getIt.registerLazySingleton<CurrentUser>(() => CurrentUser());

    getIt.registerLazySingleton<AddressManager>(() => AddressManager());

    getIt.registerLazySingleton<SearchFilter>(() => SearchFilter());

    getIt.registerLazySingleton<SearchHistory>(() => SearchHistory());

    // Pages controllers
    getIt.registerLazySingleton<BaseController>(() => BaseController());
  } catch (err) {
    log('GetIt Locator Error: $err');
  }
}

void disposeDependencies() {
  getIt<BaseController>().dispose();
  getIt<SearchFilter>().dispose();
  getIt<SearchFilter>().dispose();
  getIt<CurrentUser>().dispose();
  getIt<AppSettings>().dispose();
}
