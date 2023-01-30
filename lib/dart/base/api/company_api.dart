import 'package:logging/logging.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/core/base/model/page_resp.dart';
import 'package:orginone/core/base/model/target.dart';
import 'package:orginone/core/base/model/tree_node.dart';
import 'package:orginone/util/http_util.dart';


class CompanyApi {
  static final Logger log = Logger("CompanyApi");

  static Future<PageResp<Target>> getJoinedCompanys(
    int offset,
    int limit,
  ) async {
    String url = "${Constant.company}/get/joined/companys";
    Map<String, dynamic> data = {"offset": offset, "limit": limit};
    Map<String, dynamic> resp = await HttpUtil().post(url, data: data);
    return PageResp.fromMap(resp, Target.fromMap);
  }

  static Future<PageResp<Target>> searchCompanys({
    required String keyword,
    required int limit,
    required int offset,
  }) async {
    String url = "${Constant.company}/search/companys";
    Map<String, dynamic> data = {
      "filter": keyword,
      "limit": limit,
      "offset": offset
    };
    Map<String, dynamic> resp = await HttpUtil().post(url, data: data);
    return PageResp.fromMap(resp, Target.fromMap);
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

  static Future<Target> queryInfo() async {
    String url = "${Constant.company}/query/info";
    Map<String, dynamic> resp = await HttpUtil().post(url);

    Target targetResp = Target.fromMap(resp);
    return targetResp;
  }

  static Future<PageResp<Target>> groups(
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
    return PageResp.fromMap(pageResp, Target.fromMap);
  }

  static Future<NodeCombine> tree() async {
    String url = "${Constant.company}/get/company/tree";

    Map<String, dynamic> ans = await HttpUtil().post(url);
    Map<String, TreeNode> index = {};
    TreeNode topNode = TreeNode.fromNode(ans, index);
    return NodeCombine(topNode, index);
  }

  static Future<PageResp<Target>> getCompanyPersons(
    String id,
    int limit,
    int offset,
  ) async {
    String url = "${Constant.company}/get/persons";
    Map<String, dynamic> data = {"id": id, "offset": offset, "limit": limit};

    dynamic ans = await HttpUtil().post(url, data: data);
    return PageResp.fromMap(ans, Target.fromMap);
  }

  static Future<PageResp<Target>> getDeptPersons(
    String id,
    int limit,
    int offset,
  ) async {
    String url = "${Constant.company}/get/department/persons";
    Map<String, dynamic> data = {"id": id, "offset": offset, "limit": limit};

    dynamic ans = await HttpUtil().post(url, data: data);
    return PageResp.fromMap(ans, Target.fromMap);
  }
}
