// ignore_for_file: public_member_api_docs, sort_constructors_first
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

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import '../common/models/boardgame.dart';

class BggXMLApiRepository {
  static const baseUrl = 'https://api.geekdo.com/xmlapi';

  static Future<BoardgameModel?> fentchBoardGame(int id) async {
    final url = '$baseUrl/boardgame/$id?&stats=1';
    log(url);

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return _parseBoardGame(response.body);
    } else {
      return null;
    }
  }

  static BoardgameModel? _parseBoardGame(String xmlString) {
    try {
      final document = XmlDocument.parse(xmlString);
      final boardgame = document.findAllElements('boardgame').first;

      final nameElement = boardgame
          .findElements('name')
          .firstWhere((element) => element.getAttribute('primary') == 'true');
      log(nameElement.toString());
      final name = nameElement.innerText;

      final yearpublished = _getIntElement(boardgame, 'yearpublished');
      final minplayers = _getIntElement(boardgame, 'minplayers');
      final maxplayers = _getIntElement(boardgame, 'maxplayers');
      final minplaytime = _getIntElement(boardgame, 'minplaytime');
      final maxplaytime = _getIntElement(boardgame, 'maxplaytime');
      final age = _getIntElement(boardgame, 'age');
      final description = _getStringElement(boardgame, 'description');

      double? average, bayesaverage, averageweight;
      final ratingsElement = boardgame.findAllElements('ratings').firstOrNull;
      if (ratingsElement != null) {
        average = _getDoubleElement(ratingsElement, 'average');
        bayesaverage = _getDoubleElement(ratingsElement, 'bayesaverage');
        averageweight = _getDoubleElement(ratingsElement, 'averageweight');
      }

      final boardgamemechanic =
          _getIntListElement(boardgame, 'boardgamemechanic');
      final boardgamecategory =
          _getIntListElement(boardgame, 'boardgamecategory');

      return BoardgameModel(
          name: name,
          yearpublished: yearpublished ?? 0,
          minplayers: minplayers ?? 0,
          maxplayers: maxplayers ?? 0,
          minplaytime: minplaytime ?? 0,
          maxplaytime: maxplaytime ?? 0,
          age: age ?? 0,
          description: description != null
              ? BoardgameModel.cleanDescription(description)
              : '',
          average: average,
          bayesaverage: bayesaverage,
          averageweight: averageweight,
          boardgamemechanic: boardgamemechanic,
          boardgamecategory: boardgamecategory);
    } catch (err) {
      log(err.toString());
      return null;
    }
  }

  static List<int> _getIntListElement(XmlElement element, String key) {
    try {
      final tag = element.findElements(key);
      return tag
          .map((item) => int.parse(item.getAttribute('objectid')!))
          .toList();
    } catch (err) {
      log(err.toString());
      return [];
    }
  }

  static double? _getDoubleElement(XmlElement element, String key) {
    try {
      final tag = element.findElements(key).firstOrNull;
      if (tag != null && tag.innerText.isNotEmpty) {
        return double.tryParse(tag.innerText);
      }
      return null;
    } catch (err) {
      log(err.toString());
      return null;
    }
  }

  static int? _getIntElement(XmlElement element, String key) {
    try {
      final tag = element.findElements(key).first.innerText;
      if (tag.isEmpty) return null;
      return int.tryParse(tag);
    } catch (err) {
      log(err.toString());
      return null;
    }
  }

  static String? _getStringElement(XmlElement element, String key) {
    try {
      final tag = element.findElements(key);
      return tag.isNotEmpty ? tag.first.innerText : null;
    } catch (err) {
      log(err.toString());
      return null;
    }
  }
}