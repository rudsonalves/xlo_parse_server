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

import '../../../../common/models/advert.dart';
import '../../base_dismissible_container.dart';
import 'ad_card_view.dart';

class DismissibleAd extends StatelessWidget {
  final AdvertModel ad;
  final Color? colorLeft;
  final Color? colorRight;
  final IconData? iconLeft;
  final IconData? iconRight;
  final String? labelLeft;
  final String? labelRight;
  final AdvertStatus? statusLeft;
  final AdvertStatus? statusRight;
  final Function(AdvertModel)? updateAdStatus;

  const DismissibleAd({
    super.key,
    required this.ad,
    this.colorLeft,
    this.colorRight,
    this.iconLeft,
    this.iconRight,
    this.labelLeft,
    this.labelRight,
    this.statusLeft,
    this.statusRight,
    this.updateAdStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: baseDismissibleContainer(
        context,
        alignment: Alignment.centerLeft,
        color: colorLeft,
        icon: iconLeft,
        label: labelLeft,
      ),
      secondaryBackground: baseDismissibleContainer(
        context,
        alignment: Alignment.centerRight,
        color: colorRight,
        icon: iconRight,
        label: labelRight,
      ),
      child: AdCardView(
        ads: ad,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          if (updateAdStatus != null && statusLeft != null) {
            ad.status = statusLeft!;
            updateAdStatus!(ad);
          }
          return false;
        } else if (direction == DismissDirection.endToStart) {
          if (updateAdStatus != null && statusRight != null) {
            ad.status = statusRight!;
            updateAdStatus!(ad);
          }
          return false;
        }
        return false;
      },
    );
  }
}
