import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:logging/logging.dart';

import '../../../../api/person_api.dart';
import '../../../../api_resp/target_resp.dart';

class FriendsController extends GetxController {
  Logger logger = Logger("FriendsController");

  int? limit;
  int? offset;
  String? filter;

  List<TargetResp> friends = [];

  @override
  void onInit() {
    onLoadFriends("");
    super.onInit();
  }

  Future<void> onLoadFriends(String filter) async {
    limit = 20;
    offset = 0;
    friends = await PersonApi.friends(limit!, offset!, filter);
    update();
  }

  Future<void> moreFriends(int offset, int limit, String filter) async {
    var newFriends = await PersonApi.friends(offset, limit, filter);
    friends.addAll(newFriends);
    update();
  }

  Future<void> searchingCallback(String filter) async {
    await onLoadFriends(filter);
  }
}
