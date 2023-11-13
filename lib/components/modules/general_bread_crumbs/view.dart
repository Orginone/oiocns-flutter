import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_multiplex_page.dart';
import 'logic.dart';
import 'state.dart';
import 'item.dart';
class GeneralBreadCrumbsPage extends BaseBreadcrumbNavMultiplexPage<
    GeneralBreadCrumbsController, GeneralBreadCrumbsState> {
  @override
  Widget body() {
    return SingleChildScrollView(
      child: Column(
        children: state.model.value!.children.map((e) {
          return Item(
            item: e,
            onTap: () {
              controller.jumpDetails(e);
            },
            onNext: () {
              controller.onNext(e);
            },
            onSelected: (key,item){
              controller.operation(key,item);
            },
          );
        }).toList(),
      ),
    );
  }

  @override
  GeneralBreadCrumbsController getController() {
    return GeneralBreadCrumbsController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return hashCode.toString();
  }
}
