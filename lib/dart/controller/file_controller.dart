import 'dart:convert';

import 'package:get/get.dart';
import 'package:orginone/dart/base/api/any_store.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model/api_resp.dart';
import 'package:orginone/dart/base/model/version_entity.dart';

class FileController extends GetxController {
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
    var json = jsonEncode(resp);
    if (resp.success) {
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
