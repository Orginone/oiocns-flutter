import 'package:get/get.dart';
import 'package:orginone/common/models/index.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class SearchCoinState extends BaseGetState {
  late Rx<Wallet> wallet;

  SearchCoinState() {
    wallet = Get.arguments['wallet'];
  }
}
