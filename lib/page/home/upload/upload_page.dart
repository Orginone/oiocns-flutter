import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/api/bucket_api.dart';
import 'package:orginone/component/form_widget.dart';
import 'package:orginone/component/unified_scaffold.dart';

import '../../../component/a_font.dart';
import '../../../util/widget_util.dart';

List<FormItem> formConfig = const [
  FormItem(fieldKey: "version", fieldName: "版本", itemType: ItemType.text),
  FormItem(fieldKey: "remark", fieldName: "更新信息", itemType: ItemType.text),
];

class UploadPage extends GetView<UploadController> {
  const UploadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarTitle: Text("APK 文件上传", style: AFont.instance.size22Black3),
      appBarCenterTitle: true,
      appBarLeading: WidgetUtil.defaultBackBtn,
      body: Column(
        children: [
          FormWidget(formConfig),
          ElevatedButton(
            onPressed: () async {
              var fileResult = await FilePicker.platform
                  .pickFiles(allowedExtensions: ["apk"]);
              if (fileResult != null) {
                if (fileResult.paths.length != 1) {
                  Fluttertoast.showToast(msg: "请选择一个 APK 文件！");
                  return;
                }
                var path = fileResult.paths[0];
                if (path == null) {
                  Fluttertoast.showToast(msg: "未获取到文件路径！");
                  return;
                }
                BucketApi.uploadChunk(
                    prefix: "",
                    filePath: path,
                    fileName: "fileName",
                    shareDomain: "all");
              }
            },
            child: Text("上传文件", style: AFont.instance.size22WhiteW500),
          ),
        ],
      ),
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
