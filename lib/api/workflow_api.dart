import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/api_resp/task_entity.dart';
import 'package:orginone/config/constant.dart';

import '../api_resp/instance_task_entity.dart';
import '../api_resp/page_resp.dart';
import '../api_resp/record_task_entity.dart';
import '../util/http_util.dart';

class WorkflowApi {
  /// 待办
  static Future<PageResp<TaskEntity>> task(int limit,
      int offset,
      String filter,) async {
    String url = "${Constant.workflow}/query/task";
    Map<String, dynamic> data = {"offset": offset, "limit": limit};
    if (filter.isNotEmpty) {
      data["filter"] = filter;
    }

    Map<String, dynamic> pageResp = await HttpUtil().post(url, data: data);
    return PageResp.fromMap(pageResp, TaskEntity.fromJson);
  }

  /// 已办
  static Future<PageResp<RecordTaskEntity>> record(int limit,
      int offset,
      String filter,) async {
    String url = "${Constant.workflow}/query/record";
    Map<String, dynamic> data = {"offset": offset, "limit": limit};
    if (filter.isNotEmpty) {
      data["filter"] = filter;
    }

    Map<String, dynamic> pageResp = await HttpUtil().post(url, data: data);
    return PageResp.fromMap(pageResp, RecordTaskEntity.fromJson);
  }

  /// 我发起的
  static Future<PageResp<InstanceTaskEntity>> instance(int limit,
      int offset,
      String filter,) async {
    String url = "${Constant.workflow}/query/instance";
    Map<String, dynamic> data = {"offset": offset, "limit": limit};
    if (filter.isNotEmpty) {
      data["filter"] = filter;
    }

    Map<String, dynamic> pageResp = await HttpUtil().post(url, data: data);
    return PageResp.fromMap(pageResp, InstanceTaskEntity.fromJson);
  }

  /// 审核
  static Future<PageResp> approvalTask(String id,String status,String comment) async {
    String url = "${Constant.workflow}/approval/task";
    Map<String, dynamic> data = {"comment": comment, "id": id, "status": status};
    Map<String, dynamic> pageResp = await HttpUtil().post(url, data: data);
    return PageResp.fromMap(pageResp, PageResp.fromMap);
  }
}
