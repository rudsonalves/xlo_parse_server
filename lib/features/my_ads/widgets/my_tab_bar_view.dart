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

import '../../../common/models/advert.dart';
import '../../../components/others_widgets/ad_list_view/ad_list_view.dart';
import '../my_ads_controller.dart';

class MyTabBarView extends StatefulWidget {
  final MyAdsController ctrl;
  final ScrollController scrollController;

  const MyTabBarView({
    super.key,
    required this.ctrl,
    required this.scrollController,
  });

  @override
  State<MyTabBarView> createState() => _MyTabBarViewState();
}

class _MyTabBarViewState extends State<MyTabBarView> {
  Color? getColorLeft(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return Colors.blue.withOpacity(0.45);
      case 1:
        return Colors.green.withOpacity(0.45);
      default:
        return null;
    }
  }

  Color? getColorRight(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return null;
      case 1:
        return Colors.yellow.withOpacity(0.45);
      default:
        return Colors.blue.withOpacity(0.45);
    }
  }

  String getLabelLeft(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return 'Mover para Ativos';
      case 1:
        return 'Mover para Vendidos';
      default:
        return '';
    }
  }

  String getLabelRight(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return '';
      case 1:
        return 'Mover para Pendentes';
      default:
        return 'Mover para Ativos';
    }
  }

  IconData? getIconLeft(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return Icons.notifications_active;
      case 1:
        return Icons.currency_exchange_rounded;
      default:
        return null;
    }
  }

  IconData? getIconRight(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return null;
      case 1:
        return Icons.notifications_off_outlined;
      default:
        return Icons.notifications_active;
    }
  }

  ButtonBehavior? getItemButton(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return ButtonBehavior.edit;

      case 1:
        return null;
      default:
        return ButtonBehavior.delete;
    }
  }

  AdvertStatus? getStatusLeft(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return AdvertStatus.active;
      case 1:
        return AdvertStatus.sold;
      default:
        return null;
    }
  }

  AdvertStatus? getStatusRight(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return null;
      case 1:
        return AdvertStatus.pending;
      default:
        return AdvertStatus.active;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
        3,
        (tabIndex) => Padding(
          padding: const EdgeInsets.all(8),
          child: AdListView(
            ctrl: widget.ctrl,
            scrollController: widget.scrollController,
            enableDismissible: true,
            colorLeft: getColorLeft(tabIndex),
            colorRight: getColorRight(tabIndex),
            labelLeft: getLabelLeft(tabIndex),
            labelRight: getLabelRight(tabIndex),
            iconLeft: getIconLeft(tabIndex),
            iconRight: getIconRight(tabIndex),
            buttonBehavior: getItemButton(tabIndex),
            statusLeft: getStatusLeft(tabIndex),
            statusRight: getStatusRight(tabIndex),
          ),
        ),
      ),
    );
  }
}
