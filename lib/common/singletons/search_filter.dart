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

import '../models/filter.dart';

class SearchFilter {
  SearchFilter();

  final _search = ValueNotifier<String>('');

  String get searchString => _search.value;
  set searchString(String value) => _search.value = value;
  ValueNotifier<String> get search => _search;

  final _filter = FilterModel();
  final _filterNotifier = ValueNotifier<bool>(false);
  FilterModel get filter => _filter;
  ValueNotifier<bool> get filterNotifier => _filterNotifier;

  void updateFilter(FilterModel newFilter) {
    if (newFilter != _filter) {
      _filter.setFilter(newFilter);
      _filterNotifier.value = !_filterNotifier.value;
    }
  }

  dispose() {
    _search.dispose();
    _filterNotifier.dispose();
  }
}
