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

import 'package:flutter/material.dart';

import '../../common/models/advert.dart';
import '../../components/buttons/big_button.dart';
import '../base/base_screen.dart';
import 'advert_controller.dart';
import 'advert_state.dart';
import 'widgets/advert_form.dart';
import 'widgets/image_list_view.dart';

class AdvertScreen extends StatefulWidget {
  final AdvertModel? advert;

  const AdvertScreen({
    super.key,
    this.advert,
  });

  static const routeName = '/insert';

  @override
  State<AdvertScreen> createState() => _AdvertScreenState();
}

class _AdvertScreenState extends State<AdvertScreen> {
  final ctrl = AdvertController();

  @override
  void initState() {
    super.initState();

    ctrl.init(widget.advert);
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  Future<void> _createAnnounce() async {
    if (!ctrl.formValit) return;
    FocusScope.of(context).unfocus();
    await ctrl.createAnnounce();
    if (mounted) Navigator.pushNamed(context, BaseScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: ListenableBuilder(
        listenable: ctrl,
        builder: (context, _) => Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImagesListView(
                      controller: ctrl,
                      validator: true,
                    ),
                    AnimatedBuilder(
                      animation:
                          Listenable.merge([ctrl.valit, ctrl.imagesLength]),
                      builder: (context, _) {
                        if ((ctrl.imagesLength.value == 0 &&
                                ctrl.valit.value == null) ||
                            ctrl.imagesLength.value > 0) {
                          return Container();
                        } else {
                          return Text(
                            'Adicionar algumas imagens.',
                            style: TextStyle(
                              color: colorScheme.error,
                            ),
                          );
                        }
                      },
                    ),
                    Column(
                      children: [
                        AdvertForm(controller: ctrl),
                        BigButton(
                          color: Colors.orange,
                          label: 'Enviar',
                          onPress: _createAnnounce,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (ctrl.state is AdvertStateLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (ctrl.state is AdvertStateError)
              AlertDialog(
                icon: Icon(
                  Icons.error,
                  size: 80,
                  color: colorScheme.error,
                ),
                title: const Text('Erro'),
                content: const Text('Desculpe. Por favor, tente mais tarde.'),
                actions: [
                  FilledButton(
                    onPressed: () {
                      ctrl.gotoSuccess();
                    },
                    child: const Text('Fechar'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
