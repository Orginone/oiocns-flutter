import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/config/constant.dart';

import '../api_resp/page_resp.dart';
import '../util/http_util.dart';

class WorkflowApi {

  /// 查询待审批任务
  static Future<PageResp<TargetResp>> task(
      int limit,
      int offset,
      String filter,
      ) async {
    String url = "${Constant.workflow}/query/task";
    Map<String, dynamic> data = {"offset": offset, "limit": limit};
    if (filter.isNotEmpty) {
      data["filter"] = filter;
    }

    Map<String, dynamic> pageResp = await HttpUtil().post(url, data: data);
    return PageResp.fromMap(pageResp, TargetResp.fromMap);
  }
}
