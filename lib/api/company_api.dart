import 'package:logging/logging.dart';
import 'package:orginone/api_resp/api_resp.dart';

import '../api_resp/page_resp.dart';
import '../api_resp/target_resp.dart';
import '../api_resp/tree_node.dart';
import 'constant.dart';
import '../util/http_util.dart';

class CompanyApi {
  static final Logger log = Logger("CompanyApi");

  static Future<List<dynamic>> getJoinedCompanys(int offset, int limit) async {
    String url = "${Constant.company}/get/joined/companys";
    Map<String, dynamic> data = {"offset": offset, "limit": limit};
    Map<String, dynamic> resp = await HttpUtil().post(url, data: data);

    PageResp pageResp = PageResp.fromMap(resp);
    return pageResp.result;
  }

  static Future<List<dynamic>> searchCompanys(String code) async {
    String url = "${Constant.company}/search/companys";
    Map<String, dynamic> data = {"filter": code, "limit": 20, "offset": 0};
    Map<String, dynamic> resp = await HttpUtil().post(url, data: data);
    PageResp pageResp = PageResp.fromMap(resp);
    return pageResp.result;
  }

  static Future<void> quitCompany(String id) async {
    String url = "${Constant.company}/exit";
    Map<String, dynamic> postData = {"id": id};
    await HttpUtil().post(url, data: postData);
  }

  static Future<void> createCompany(dynamic postData) async {
    String url = "${Constant.company}/create";
    await HttpUtil().post(url, data: postData);
  }

  static Future<void> joinCompany(String id) async {
    String url = "${Constant.company}/apply/join";
    Map<String, dynamic> postData = {"id": id};
    await HttpUtil().post(url, data: postData);
  }

  static Future<TargetResp> queryInfo() async {
    String url = "${Constant.company}/query/info";
    Map<String, dynamic> resp = await HttpUtil().post(url);

    TargetResp targetResp = TargetResp.fromMap(resp);
    return targetResp;
  }

  static Future<List<TargetResp>> groups(
    int limit,
    int offset,
    String filter,
  ) async {
    String url = "${Constant.company}/get/groups";
    Map<String, dynamic> data = {"offset": offset, "limit": limit};
    if (filter.isNotEmpty) {
      data["filter"] = filter;
    }

    dynamic pageResp = await HttpUtil().post(url, data: data);
    var pageData = PageResp.fromMap(pageResp);
    return pageData.result.map((item) => TargetResp.fromMap(item)).toList();
  }

  static Future<NodeCombine> tree() async {
    String url = "${Constant.company}/get/company/tree";

    Map<String, dynamic> ans = await HttpUtil().post(url);
    Map<String, TreeNode> index = {};
    TreeNode topNode = TreeNode.fromNode(ans, index);
    return NodeCombine(topNode, index);
  }

  static Future<List<TargetResp>> getCompanyPersons(
    String id,
    int limit,
    int offset,
  ) async {
    String url = "${Constant.company}/get/persons";
    Map<String, dynamic> data = {"id": id, "offset": offset, "limit": limit};

    dynamic ans = await HttpUtil().post(url, data: data);
    PageResp pageResp = PageResp.fromMap(ans);

    return TargetResp.fromList(pageResp.result);
  }

  static Future<List<TargetResp>> getDeptPersons(
      String id,
      int limit,
      int offset,
      ) async {
    String url = "${Constant.company}/get/department/persons";
    Map<String, dynamic> data = {"id": id, "offset": offset, "limit": limit};

    dynamic ans = await HttpUtil().post(url, data: data);
    PageResp pageResp = PageResp.fromMap(ans);

    return TargetResp.fromList(pageResp.result);
  }
}
