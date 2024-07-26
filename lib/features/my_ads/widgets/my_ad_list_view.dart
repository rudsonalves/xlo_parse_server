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
import '../../product/product_screen.dart';
import '../../shop/widgets/ad_text_info.dart';
import '../../shop/widgets/ad_text_price.dart';
import '../../shop/widgets/ad_text_title.dart';

class AdListView extends StatefulWidget {
  final BasicController ctrl;
  final ScrollController scrollController;

  const AdListView({
    super.key,
    required this.ctrl,
    required this.scrollController,
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            clipBehavior: Clip.antiAlias,
            color: colorScheme.surfaceContainer,
            child: Row(
              children: [
                showImage(ctrl.ads[index].images[0]),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AdTextTitle(ctrl.ads[index].title),
                        AdTextPrice(ctrl.ads[index].price),
                        AdTextInfo(
                          date: ctrl.ads[index].createdAt,
                          city: ctrl.ads[index].address.city,
                          state: ctrl.ads[index].address.state,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
