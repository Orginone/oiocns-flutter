import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/market/model.dart';

class ApplicationDetailsState extends BaseGetState {
  late IProduct product;

  ApplicationDetailsState() {
    product = Get.arguments['product'];
  }
}
