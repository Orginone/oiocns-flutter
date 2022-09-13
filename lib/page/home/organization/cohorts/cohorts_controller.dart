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
    cohorts = await CohortApi.cohorts(limit!, offset!, filter);
    update();
  }

  Future<void> moreCohorts(int offset, int limit, String filter) async {
    var newCohorts = await CohortApi.cohorts(offset, limit, filter);
    cohorts.addAll(newCohorts);
    update();
  }

  Future<void> searchingCallback(String filter) async {
    await onLoadCohorts(filter);
  }
}
