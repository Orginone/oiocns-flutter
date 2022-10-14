import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:orginone/api/company_api.dart';
import 'package:orginone/api_resp/target_resp.dart';

class MineUnitController extends GetxController {
  List<TargetResp> units = [];
  int offset = 0;
  int limit = 10;
  ScrollController scrollController = ScrollController();

  @override
  onInit() async {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        loadSpaces(isMore: true);
      }
    });
    await loadSpaces();
    super.onInit();
  }

  Future<void> loadSpaces({isMore = false}) async {
    if (!isMore) {
      offset = 0;
      limit = 10;
      units = [];
    }
    // 获取加入的空间
    var pageResp = await CompanyApi.getJoinedCompanys(offset, limit);
    units.addAll(pageResp.result);
    offset += 10;
    limit += 10;
    update();
  }
}
