import 'package:get/get.dart';

import '../../../dart/core/getx/base_controller.dart';
import '../ware_house/state.dart';
import 'state.dart';

class ShopController extends BaseController<ShopState> {
 final ShopState state = ShopState();


 @override
 void onInit() {
   // TODO: implement onInit
   super.onInit();
   state.recentlyList.add(
       Recent("0000", "资产监管", "http://orginone.cn:888/img/logo/logo3.jpg"));
   state.recentlyList.add(
       Recent("0001", "资产处置", "http://orginone.cn:888/img/logo/logo3.jpg"));
   state.recentlyList.add(
       Recent("0001", "通用表格", "http://orginone.cn:888/img/logo/logo3.jpg"));
   state.recentlyList.add(
       Recent("0001", "公物仓", "http://orginone.cn:888/img/logo/logo3.jpg"));
   state.recentlyList.add(
       Recent("0001", "公益仓", "http://orginone.cn:888/img/logo/logo3.jpg"));
 }
}
