import 'package:common_utils/common_utils.dart';
import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
// import 'package:logging/logging.dart';
import 'package:orginone/api/hub/any_store.dart';
import 'package:orginone/api/kernelapi.dart';
import 'package:orginone/api_resp/api_resp.dart';
import 'package:orginone/core/store/LogUtil.dart';

import '../api_resp/version_entity.dart';

class FileController extends GetxController {
  // final Logger log = Logger("fileController");

  Future<void> apkUpload(Map<String, dynamic> value) async {
    var key = SubscriptionKey.apkFile.keyWord;
    var domain = Domain.all.name;
    var data = {
      "operation": "replaceAll",
      "data": {"apk": value}
    };
    await Kernel.getInstance.anyStore.set(key, data, domain);
  }

  Future<Map<String, dynamic>> apkDetail() async {
    var key = SubscriptionKey.apkFile.keyWord;
    var domain = Domain.all.name;
    ApiResp resp = await Kernel.getInstance.anyStore.get(key, domain);
    return resp.data["apk"];
  }

  Future<VersionEntity?> versionList() async {
    var key = SubscriptionKey.version.keyWord;
    var domain = Domain.all.name;
    ApiResp resp = await Kernel.getInstance.anyStore.get(key, domain);
    Loggers.init(title: "全部", isDebug: true, limitLength: 800);
    var json = jsonEncode(resp);
    Loggers.d("公共域所哟数据：$json");
    if(resp.success){
      return VersionEntity.fromJson(resp.data);
    }
    return null;
  }
}

class FileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FileController());
  }
}
