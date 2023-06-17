import 'package:get/get.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/base_freqiently_usedList_controller.dart';
import 'package:orginone/pages/store/state.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class MarketController extends BaseFrequentlyUsedListController<MarketState> {
 final MarketState state = MarketState();


 @override
 void onInit() {
   // TODO: implement onInit
   super.onInit();
 }
}
