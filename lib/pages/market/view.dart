import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/base_frequently_used_list_page_view.dart';
import 'package:orginone/widget/unified.dart';

import 'logic.dart';
import 'state.dart';

class MarketPage extends BaseFrequentlyUsedListPage<MarketController, MarketState> {
  @override
  Widget buildView() {
    return Container(
      color: XColors.bgColor,
      child: Container(),
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
