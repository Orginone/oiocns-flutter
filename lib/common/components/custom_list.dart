import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';

typedef ItemBuilderFun = Function(
    List list, int index, CustomListController controller);

class CustomListPage extends GetView<CustomListController> {
  final List datas;
  final ItemBuilderFun itemBuilder;

  const CustomListPage(
    this.datas, {
    Key? key,
    required this.itemBuilder,
  }) : super(key: key);

//分割线列表视图
  Widget _buildListView() {
    return controller.items.isNotEmpty
        ? ListView.builder(
            itemCount: controller.items.length,
            itemBuilder: (BuildContext context, int index) {
              return itemBuilder(controller.items, index, controller);
            },
          ).expanded()
        : const PlaceholdWidget().expanded();
  }

  // 主视图
  Widget _buildView() {
    //返回一个Column
    return <Widget>[
      //返回一个header

      _buildListView()
    ].toColumn().paddingAll(AppSpace.button);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomListController>(
      init: CustomListController(),
      id: "custom_list_page",
      builder: (_) {
        CustomListController c = Get.find<CustomListController>();
        c.setData = datas;
        return _buildView();
      },
    );
  }
}

class CustomListController extends GetxController {
  CustomListController();

  set setData(List value) {
    items = value;
    update(["custom_list_page"]);
  }

// 列表
  List items = [];

  _initData() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }
}
