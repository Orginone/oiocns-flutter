import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';

class Demo1State extends BaseBreadcrumbNavState {

  Demo1State() {
    model = Get.arguments?['data'] ?? testModel[0];
    title = model?.name??"";
  }
}

List<BreadcrumbNavModel> testModel = [
  BreadcrumbNavModel(name: '0', children: [
    BreadcrumbNavModel(name: "1", children: [
      BreadcrumbNavModel(name: "2", children: [
        BreadcrumbNavModel(name: "5", children: []),
        BreadcrumbNavModel(name: "6", children: []),
        BreadcrumbNavModel(name: "7", children: []),
      ]),
      BreadcrumbNavModel(name: "3", children: [
        BreadcrumbNavModel(name: "7", children: []),
        BreadcrumbNavModel(name: "8", children: []),
        BreadcrumbNavModel(name: "9", children: []),
      ]),
      BreadcrumbNavModel(name: "4", children: [
        BreadcrumbNavModel(name: "10", children: []),
        BreadcrumbNavModel(name: "11", children: []),
        BreadcrumbNavModel(name: "12", children: []),
      ]),
    ]),
  ])
];

class BreadcrumbNavModel extends BaseBreadcrumbNavModel {
  BreadcrumbNavModel(
      {super.id = '', super.name = '', super.children = const []});
}
