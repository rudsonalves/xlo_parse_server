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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../common/basic_controller/basic_controller.dart';
import '../../../common/models/advert.dart';
import '../../../features/product/product_screen.dart';
import 'widgets/ad_card_view.dart';
import 'widgets/dismissible_ad.dart';

enum ButtonBehavior { edit, delete }

class AdListView extends StatefulWidget {
  final BasicController ctrl;
  final ScrollController scrollController;
  final ButtonBehavior? buttonBehavior;
  final bool enableDismissible;
  final Color? colorLeft;
  final Color? colorRight;
  final IconData? iconLeft;
  final IconData? iconRight;
  final String? labelLeft;
  final String? labelRight;
  final AdvertStatus? statusLeft;
  final AdvertStatus? statusRight;
  final Function(AdvertModel ad)? editAd;
  final Function(AdvertModel ad)? deleteAd;

  const AdListView({
    super.key,
    required this.ctrl,
    required this.scrollController,
    this.buttonBehavior,
    this.enableDismissible = false,
    this.colorLeft,
    this.colorRight,
    this.iconLeft,
    this.iconRight,
    this.labelLeft,
    this.labelRight,
    this.statusLeft,
    this.statusRight,
    this.editAd,
    this.deleteAd,
  });

  @override
  State<AdListView> createState() => _AdListViewState();
}

class _AdListViewState extends State<AdListView> {
  late ScrollController _scrollController;
  late final BasicController ctrl;
  double scrollPosition = 0;

  @override
  initState() {
    super.initState();

    ctrl = widget.ctrl;
    _scrollController = widget.scrollController;
    _scrollController.addListener(_scrollListener2);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ctrl.ads.isEmpty) return;
      _scrollController.jumpTo(scrollPosition);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener2);
    super.dispose();
  }

  void _scrollListener2() {
    if (_scrollController.position.atEdge) {
      final isTop = _scrollController.position.pixels == 0;
      if (!isTop) {
        scrollPosition = _scrollController.position.pixels;
        ctrl.getMoreAds();
      }
    }
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

  Widget? getItemButton(int index) {
    final ad = ctrl.ads[index];

    switch (widget.buttonBehavior) {
      case null:
        return null;
      case ButtonBehavior.edit:
        return InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () {
            if (widget.editAd != null) widget.editAd!(ad);
          },
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.edit,
              color: Colors.yellowAccent.withOpacity(0.65),
            ),
          ),
        );
      case ButtonBehavior.delete:
        return InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () {
            if (widget.deleteAd != null) widget.deleteAd!(ad);
          },
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.delete,
              color: Colors.redAccent.withOpacity(0.65),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: ctrl.ads.length,
      itemBuilder: (context, index) => SizedBox(
        height: 150,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              ProductScreen.routeName,
              arguments: ctrl.ads[index],
            );
          },
          child: widget.enableDismissible
              ? DismissibleAd(
                  ad: ctrl.ads[index],
                  itemButton: getItemButton(index),
                  colorLeft: widget.colorLeft,
                  colorRight: widget.colorRight,
                  iconLeft: widget.iconLeft,
                  iconRight: widget.iconRight,
                  labelLeft: widget.labelLeft,
                  labelRight: widget.labelRight,
                  statusLeft: widget.statusLeft,
                  statusRight: widget.statusRight,
                  updateAdStatus: ctrl.updateAdStatus,
                )
              : AdCardView(
                  ads: ctrl.ads[index],
                ),
        ),
      ),
    );
  }
}
