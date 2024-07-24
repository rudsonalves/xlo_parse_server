// Copyright (C) 2024 rudson
//
// This file is part of xlo_mobx.
//
// xlo_mobx is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// xlo_mobx is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xlo_mobx.  If not, see <https://www.gnu.org/licenses/>.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../common/theme/app_text_style.dart';
import 'home_controller.dart';
import 'home_state.dart';
import 'widgets/ad_list_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/shop';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ctrl = HomeController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ctrl.init();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    ctrl.dispose();
    super.dispose();
  }

  Widget showImage(String image) {
    if (image.isEmpty) {
      final color = Theme.of(context).colorScheme.secondaryContainer;
      return Icon(
        Icons.image_not_supported_outlined,
        color: color,
        size: 150,
      );
    } else {
      return CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListenableBuilder(
            listenable: ctrl,
            builder: (context, _) {
              return Stack(
                children: [
                  // state HomeState Success
                  // empty search
                  if (ctrl.ads.isEmpty && ctrl.state is HomeStateSuccess)
                    Center(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.warning_amber,
                            color: Colors.amber,
                            size: 80,
                          ),
                          Text(
                            'Nenhum anúncio encontrado',
                            style: AppTextStyle.font18Bold,
                          ),
                        ],
                      ),
                    ),
                  if (ctrl.ads.isNotEmpty && ctrl.state is HomeStateSuccess)
                    AdListView(ctrl: ctrl),
                  if (ctrl.state is HomeStateError)
                    Positioned.fill(
                      child: Container(
                        color: colorScheme.surface.withOpacity(0.7),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Card(
                                color: colorScheme.primaryContainer,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.error,
                                        color: colorScheme.error,
                                        size: 80,
                                      ),
                                      const Text(
                                        'Desculpe. Ocorreu algum problema.\n'
                                        ' Tente mais tarde.',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // state HomeState Loading
                  if (ctrl.state is HomeStateLoading)
                    Positioned.fill(
                      child: Container(
                        color: colorScheme.surface.withOpacity(.7),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                ],
              );
            }),
      ),
    );
  }
}
