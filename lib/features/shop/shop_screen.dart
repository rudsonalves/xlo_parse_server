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

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:xlo_mobx/features/advertisement/advert_screen.dart';

import '../../common/basic_controller/basic_state.dart';
import '../../common/singletons/current_user.dart';
import '../../common/theme/app_text_style.dart';
import '../../get_it.dart';
import '../login/login_screen.dart';
import 'shop_controller.dart';
import '../../components/others_widgets/ad_list_view/ad_list_view.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  static const routeName = '/shop';

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen>
    with SingleTickerProviderStateMixin {
  final ctrl = ShopController();
  late AnimationController _animationController;
  late Animation<Offset> _fabOffsetAnimation;
  final _scrollController = ScrollController();
  Timer? _timer;

  final currentUser = getIt<CurrentUser>();

  @override
  void initState() {
    super.initState();
    ctrl.init();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fabOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scrollController.addListener(_scrollListener);
    _animationController.forward();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward ||
        _scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
      _hideFab();
      _resetTimer();
    }
  }

  void _showFab() {
    _animationController.forward();
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 5), () {
      _showFab();
    });
  }

  void _hideFab() {
    _animationController.reverse();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _animationController.dispose();
    _timer?.cancel();
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ValueListenableBuilder(
        valueListenable: currentUser.isLogedListernable,
        builder: (context, isLoged, _) {
          return SlideTransition(
            position: _fabOffsetAnimation,
            child: isLoged
                ? FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.pushNamed(context, AdvertScreen.routeName);
                    },
                    backgroundColor:
                        colorScheme.primaryContainer.withOpacity(0.75),
                    icon: const Icon(Icons.camera),
                    label: const Text('Adicionar anúncio'),
                  )
                : FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.pushNamed(context, LoginScreen.routeName);
                    },
                    backgroundColor: colorScheme.tertiaryContainer,
                    icon: const Icon(Icons.login),
                    label: const Text('Faça Login'),
                  ),
          );
        },
      ),
      body: NotificationListener<ScrollStartNotification>(
        onNotification: (scrollNotification) {
          _hideFab();
          _resetTimer();
          return false;
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListenableBuilder(
              listenable: ctrl,
              builder: (context, _) {
                return Stack(
                  children: [
                    // state HomeState Success
                    // empty search
                    if (ctrl.ads.isEmpty && ctrl.state is BasicStateSuccess)
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
                    if (ctrl.ads.isNotEmpty && ctrl.state is BasicStateSuccess)
                      AdListView(
                        ctrl: ctrl,
                        scrollController: _scrollController,
                      ),
                    if (ctrl.state is BasicStateError)
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
                    if (ctrl.state is BasicStateLoading)
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
      ),
    );
  }
}
