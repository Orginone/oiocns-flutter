import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/api/market_api.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/form/form_widget.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/controller/market/market_controller.dart';
import 'package:orginone/util/widget_util.dart';

List<FormItem> formConfig = const [
  FormItem(fieldKey: "name", fieldName: "商店名称", itemType: ItemType.text),
  FormItem(fieldKey: "code", fieldName: "商店编码", itemType: ItemType.text),
  FormItem(fieldKey: "remark", fieldName: "商店介绍", itemType: ItemType.text),
  FormItem(
    fieldKey: "public",
    fieldName: "是否公开",
    itemType: ItemType.onOff,
    defaultValue: true,
  ),
];

class ApplicationMaintainPage extends GetView<MarketController> {
  const ApplicationMaintainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = Get.arguments;
    ApplicationMarketFunc func = args["func"];
    Map<String, dynamic> market = args["market"] ?? {};
    return UnifiedScaffold(
      appBarTitle: Text("创建市场", style: AFont.instance.size22Black3),
      appBarCenterTitle: true,
      appBarLeading: WidgetUtil.defaultBackBtn,
      body: FormWidget(
        formConfig,
        initValue: market,
        submitCallback: (value) async {
          if (func == ApplicationMarketFunc.create) {
            MarketApi.create(value).then((value) {
              Fluttertoast.showToast(msg: "市场创建成功!");
              controller.onLoad();
              Get.back();
            });
          } else if (func == ApplicationMarketFunc.update) {
            MarketApi.update(value).then((value) {
              Fluttertoast.showToast(msg: "更新市场成功!");
              controller.onLoad();
              Get.back();
            });
          }
        },
      ),
    );
  }
}
