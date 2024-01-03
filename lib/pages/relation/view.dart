import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_page_view.dart';
import 'package:orginone/pages/relation/index.dart';

class RelationPage extends BaseSubmenuPage<RelationController, RelationState> {
  const RelationPage({super.key});

  @override
  Widget buildPageView(String type, String label) {
    return RelationSubPage(type);
  }
}
