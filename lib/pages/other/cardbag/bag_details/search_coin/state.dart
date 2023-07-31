


import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/model/wallet_model.dart';

class SearchCoinState extends BaseGetState{
  late Rx<Wallet> wallet;

  SearchCoinState(){
    wallet = Get.arguments['wallet'];
  }
}