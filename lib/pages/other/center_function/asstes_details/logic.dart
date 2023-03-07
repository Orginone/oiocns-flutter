import 'package:orginone/dart/base/api/kernelapi.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class AssetsDetailsController extends BaseController<AssetsDetailsState> {
  final AssetsDetailsState state = AssetsDetailsState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    KernelApi.getInstance()
        .anystore
        .aggregate(
            "card_temp",
        {
          "match": {
            "belongName":state.assets.assetType
          },
          "sort": {"UPDATE_TIME": -1},
          "skip": 0,
          "limit": 9999,
        },
            "company")
        .then((value) {
      print(value.msg);
    });
  }
}