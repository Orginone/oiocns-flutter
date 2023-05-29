import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/widget/common_widget.dart';

import 'logic.dart';
import 'state.dart';

class MarketPage extends BaseGetPageView<MarketController,MarketState>{


  List<String> imageList = [
    "images/bg_center1.png",
    "images/bg_center2.png",
    "images/bg_center1.png",
    "images/bg_center2.png",
  ];

  @override
  Widget buildView() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          CommonWidget.commonSearchBarWidget(hint: "请输入内容",searchColor: Colors.grey.shade200),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                GFCarousel(
                hasPagination: false,
                aspectRatio: 2 / 1,
                activeIndicator: GFColors.WHITE,
                // 自动播放
                autoPlay: true,
                items: imageList.map(
                      (img) {
                    return ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                      child: Image.asset(img, fit: BoxFit.fill, width: 1000.0),
                    );
                  },
                ).toList(),
              ),
                ],
              ),
            )
          )
        ],
      ),
    );
  }


  @override
  MarketController getController() {
    return MarketController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return "market";
  }
}