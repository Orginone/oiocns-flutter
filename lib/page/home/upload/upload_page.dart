import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/component/form/form_widget.dart';
import 'package:orginone/component/unified_scaffold.dart';

import '../../../component/a_font.dart';
import '../../../util/widget_util.dart';

List<FormItem> formConfig = const [
  FormItem(fieldKey: "version", fieldName: "版本", itemType: ItemType.text),
  FormItem(fieldKey: "remark", fieldName: "更新信息", itemType: ItemType.text),
  FormItem(fieldKey: "path", fieldName: "文件路径", itemType: ItemType.upload),
];

class UploadPage extends GetView<UploadController> {
  const UploadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarTitle: Text("APK 文件上传", style: AFont.instance.size22Black3),
      appBarCenterTitle: true,
      appBarLeading: WidgetUtil.defaultBackBtn,
      body: FormWidget(formConfig),
    );
  }
}

class UploadController extends GetxController {}

class UploadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UploadController());
  }
}
