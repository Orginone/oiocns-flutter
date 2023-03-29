import '../../../../../dart/core/getx/base_controller.dart';
import 'network.dart';
import 'state.dart';

class AssetsDetailsController extends BaseController<AssetsDetailsState> {
  final AssetsDetailsState state = AssetsDetailsState();

   @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    state.config.value = await AssetsDetailsNetWork.getConfig(
        belongName: state.assets.assetType);
  }
}