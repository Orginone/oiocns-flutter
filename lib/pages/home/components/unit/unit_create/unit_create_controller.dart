import 'package:flutter/material.dart';
import 'package:get/get.dart';

//需要接收一个统一社会信用代码来做查询
class UnitCreateController extends GetxController {
  var nameController = TextEditingController();
  var codeController = TextEditingController();
  var nickNameController = TextEditingController();
  var teamCodeController = TextEditingController();
  var remarkController = TextEditingController();

// Future<void> getUnitDetail(String code) async {
//   // 获取公司详情,用搜索接口实现
//   List<dynamic> unitDetailList = await CompanyApi.searchCompanys(code);
//   unit = TargetResp.fromMap(unitDetailList[0]);
//   update();
// }
}
