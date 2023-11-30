import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_page_view.dart';
import 'logic.dart';
import 'state.dart';
import 'store_sub_page/view.dart';

class StorePage extends BaseSubmenuPage<StoreController, StoreState> {
  const StorePage({super.key});

  @override
  Widget buildPageView(String type, String label) {
    return StoreSubPage(type);
  }
}
