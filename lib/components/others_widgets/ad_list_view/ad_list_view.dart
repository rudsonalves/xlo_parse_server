// Copyright (C) 2024 Rudson Alves
//
// This file is part of bgbazzar.
//
// bgbazzar is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// bgbazzar is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with bgbazzar.  If not, see <https://www.gnu.org/licenses/>.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../common/basic_controller/basic_controller.dart';
import '../../../common/models/ad.dart';
import '../../../features/product/product_screen.dart';
import 'widgets/ad_card_view.dart';
import 'widgets/dismissible_ad.dart';

class AdListView extends StatefulWidget {
  final BasicController ctrl;
  final ScrollController scrollController;
  final bool buttonBehavior;
  final bool enableDismissible;
  final Color? colorLeft;
  final Color? colorRight;
  final IconData? iconLeft;
  final IconData? iconRight;
  final String? labelLeft;
  final String? labelRight;
  final AdStatus? statusLeft;
  final AdStatus? statusRight;
  final Function(AdModel ad)? editAd;
  final Function(AdModel ad)? deleteAd;

  const AdListView({
    super.key,
    required this.ctrl,
    required this.scrollController,
    required this.buttonBehavior,
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
  double _scrollPosition = 0;
  bool _isScrolling = false;

  @override
  initState() {
    super.initState();

    ctrl = widget.ctrl;
    _scrollController = widget.scrollController;
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  Future<void> _scrollListener() async {
    if (_scrollController.hasClients &&
        _scrollController.position.atEdge &&
        !_isScrolling) {
      final isBottom = _scrollController.position.pixels != 0;
      if (isBottom) {
        _scrollPosition = _scrollController.position.pixels;
        _isScrolling = true;
        await ctrl.getMoreAds();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // _scrollController.animateTo(
          //   _scrollPosition,
          //   duration: const Duration(microseconds: 300),
          //   curve: Curves.easeInOut,
          // );
          _scrollController.jumpTo(_scrollPosition);
          _isScrolling = false;
        });
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

  Widget _editButon(AdModel ad) {
    return IconButton(
      onPressed: () {
        if (widget.editAd != null) widget.editAd!(ad);
      },
      icon: Icon(
        Icons.edit,
        color: Colors.yellowAccent.withOpacity(0.65),
      ),
    );
  }

  Widget _deleteButton(AdModel ad) {
    return IconButton(
      onPressed: () {
        if (widget.deleteAd != null) widget.deleteAd!(ad);
      },
      icon: Icon(
        Icons.delete,
        color: Colors.redAccent.withOpacity(0.65),
      ),
    );
  }

  void _showAd(AdModel ad) {
    Navigator.pushNamed(
      context,
      ProductScreen.routeName,
      arguments: ad,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView.builder(
      controller: _scrollController,
      itemCount: ctrl.ads.length,
      itemBuilder: (context, index) => SizedBox(
        height: 150,
        child: Stack(
          children: [
            InkWell(
              onTap: () => _showAd(ctrl.ads[index]),
              child: widget.enableDismissible
                  ? DismissibleAd(
                      ad: ctrl.ads[index],
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
            if (widget.buttonBehavior)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _editButon(ctrl.ads[index]),
                        _deleteButton(ctrl.ads[index]),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
