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

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:xlo_mobx/repository/constants.dart';

import '../common/models/category.dart';

class CategoryRepositories {
  static Future<List<CategoryModel>?> getList() async {
    final categories = <CategoryModel>[];

    final parseCategories = ParseObject(keyCategoryTable);
    final queryBuilder = QueryBuilder<ParseObject>(parseCategories)
      ..orderByAscending(
        keyCategoryName,
      );

    final response = await queryBuilder.query();

    if (!response.success) {
      throw Exception('${response.error!.code} - ${response.error}');
    }

    categories.addAll(
      response.results!.map(
        (objParse) => parseCategory(objParse),
      ),
    );

    return categories;
  }

  static parseCategory(ParseObject parseCategory) {
    return CategoryModel(
      id: parseCategory.objectId,
      name: parseCategory.get(keyCategoryName),
      description: parseCategory.get(keyCategoryDescription),
      createAt: parseCategory.createdAt,
    );
  }
}
