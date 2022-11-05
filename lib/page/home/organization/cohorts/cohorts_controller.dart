import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:logging/logging.dart';

import '../../../../api/cohort_api.dart';
import '../../../../api_resp/target_resp.dart';

class CohortsController extends GetxController {
  Logger logger = Logger("CohortsController");

  int? limit;
  int? offset;
  String? filter;

  List<TargetResp> cohorts = [];

  @override
  void onInit() {
    onLoad();
    super.onInit();
  }

  Future<void> onLoad() async {
    await onLoadCohorts("");
  }

  Future<void> onLoadCohorts(String filter) async {
    limit = 20;
    offset = 0;
    var pageResp = await CohortApi.cohorts(limit!, offset!, filter);
    cohorts = pageResp.result;
    update();
  }

  Future<void> moreCohorts(int offset, int limit, String filter) async {
    var pageResp = await CohortApi.cohorts(offset, limit, filter);
    cohorts.addAll(pageResp.result);
    update();
  }

  Future<void> searchingCallback(String filter) async {
    await onLoadCohorts(filter);
  }

  Future<dynamic> createCohort(Map<String, dynamic> value) async {
    await CohortApi.createCohort(
      code: value["code"],
      name: value["name"],
      teamRemark: value["remark"],
    );
    await onLoad();
    Fluttertoast.showToast(msg: "创建成功！");
  }
}
