import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/api/company_api.dart';
import 'package:orginone/api_resp/target.dart';

//需要接收一个统一社会信用代码来做查询
class UnitDetailController extends GetxController {
  Target? unit;
  int type = 0;
  ScrollController scrollController = ScrollController();

  @override
  onReady() async {
    type = (Get.arguments["type"]);
    await getUnitDetail(Get.arguments["code"]);
    super.onReady();
  }

  Future<void> getUnitDetail(String code) async {
    // 获取公司详情,用搜索接口实现
    var pageResp = await CompanyApi.searchCompanys(
      keyword: code,
      limit: 20,
      offset: 0,
    );
    unit = pageResp.result[0];
    update();
  }
}
