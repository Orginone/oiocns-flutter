import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orginone/api/company_api.dart';
import 'package:orginone/api_resp/target_resp.dart';
//需要接收一个统一社会信用代码来做查询
class UnitDetailController extends GetxController {
  TargetResp? unit;
  ScrollController scrollController = ScrollController();
  @override
  onReady() async{
    await getUnitDetail(Get.arguments);
    super.onReady();
  }

  Future<void> getUnitDetail(String code) async {
    // 获取公司详情,用搜索接口实现
    List<dynamic> unitDetailList = await CompanyApi.searchCompanys(code);
    unit = TargetResp.fromMap(unitDetailList[0]);
    update();
  }
}
