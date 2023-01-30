import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:logging/logging.dart';

import '../../../../api/person_api.dart';
import '../../../../api_resp/target.dart';

class FriendsController extends GetxController {
  Logger logger = Logger("FriendsController");

  int? limit;
  int? offset;
  String? filter;

  List<Target> friends = [];

  @override
  void onInit() {
    super.onInit();
    onLoadFriends("");
  }

  Future<void> onLoadFriends(String filter) async {
    limit = 20;
    offset = 0;
    var pageResp = await PersonApi.friends(limit!, offset!, filter);
    friends = pageResp.result;
    update();
  }

  Future<void> moreFriends(int offset, int limit, String filter) async {
    var pageResp = await PersonApi.friends(offset, limit, filter);
    friends.addAll(pageResp.result);
    update();
  }

  Future<void> searchingCallback(String filter) async {
    await onLoadFriends(filter);
  }
}
