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

import '../../../common/models/boardgame.dart';
import '../../../common/theme/app_text_style.dart';
import '../../product/widgets/description_product.dart';
import '../../product/widgets/title_product.dart';

class BGInfoCard extends StatelessWidget {
  final BoardgameModel game;

  const BGInfoCard(
    this.game, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleProduct(
              title: '${game.name} (${game.yearpublished})',
              color: colorScheme.primary,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '${game.minplayers}-${game.maxplayers} ',
                      style: AppTextStyle.font16.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    Text(
                      'Jogadores',
                      style: AppTextStyle.font16,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${game.minplaytime}-${game.maxplaytime}',
                      style: AppTextStyle.font16.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    Text(
                      ' Min',
                      style: AppTextStyle.font16,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Idade: ',
                      style: AppTextStyle.font16,
                    ),
                    Text(
                      '${game.age}+',
                      style: AppTextStyle.font16.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Peso: ',
                      style: AppTextStyle.font16,
                    ),
                    Text(
                      game.averageweight?.toStringAsFixed(2) ?? '*',
                      style: AppTextStyle.font16.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    Text(
                      '/5 *',
                      style: AppTextStyle.font16,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Pontuação: ',
                      style: AppTextStyle.font16,
                    ),
                    Text(
                      game.average?.toStringAsFixed(2) ?? '*',
                      style: AppTextStyle.font16
                          .copyWith(color: colorScheme.primary),
                    ),
                    Text(
                      '/10 *',
                      style: AppTextStyle.font16,
                    ),
                  ],
                ),
              ],
            ),
            if (game.designer != null)
              Row(
                children: [
                  Text(
                    '${game.designer!.contains(', ') ? 'Designers' : 'Designer'}: ',
                    style: AppTextStyle.font16,
                  ),
                  Text(
                    game.designer!,
                    style: AppTextStyle.font16.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            if (game.artist != null)
              Row(
                children: [
                  Text(
                    '${game.artist!.contains(', ') ? 'Artistas' : 'Artista'}: ',
                    style: AppTextStyle.font16,
                  ),
                  Text(
                    game.artist!,
                    style: AppTextStyle.font16.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            DescriptionProduct(
              description: game.description ?? '- * -',
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text('* dados exclusivos do BGG'),
            ),
          ],
        ),
      ),
    );
  }
}
