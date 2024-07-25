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
import 'package:flutter/rendering.dart';

import '../../common/theme/app_text_style.dart';
import 'shop_controller.dart';
import 'shop_state.dart';
import 'widgets/ad_list_view.dart';

class ShopScreen extends StatefulWidget {
  final void Function(int page) changeToPage;

  const ShopScreen(
    this.changeToPage, {
    super.key,
  });

  static const routeName = '/shop';

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen>
    with SingleTickerProviderStateMixin {
  final ctrl = ShopController();
  final _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<Offset> _fabAnimation;

  @override
  void initState() {
    super.initState();
    ctrl.init();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fabAnimation = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      _animationController.forward();
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _animationController.dispose();
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
      floatingActionButton: SlideTransition(
        position: _fabAnimation,
        child: FloatingActionButton.extended(
          onPressed: () {
            widget.changeToPage(1);
          },
          backgroundColor: colorScheme.primaryContainer.withOpacity(0.65),
          icon: const Icon(Icons.camera),
          label: const Text('Adicionar anúncio'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListenableBuilder(
            listenable: ctrl,
            builder: (context, _) {
              return Stack(
                children: [
                  // state HomeState Success
                  // empty search
                  if (ctrl.ads.isEmpty && ctrl.state is ShopeStateSuccess)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Card(
                            color:
                                colorScheme.primaryContainer.withOpacity(.45),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
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
                          ),
                        ),
                      ],
                    ),
                  if (ctrl.ads.isNotEmpty && ctrl.state is ShopeStateSuccess)
                    AdListView(
                      ctrl: ctrl,
                      scrollController: _scrollController,
                    ),
                  if (ctrl.state is ShopeStateError)
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
                  if (ctrl.state is ShopeStateLoading)
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
