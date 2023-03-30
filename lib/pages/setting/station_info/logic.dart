import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class StationInfoController extends BaseController<StationInfoState> {
 final StationInfoState state = StationInfoState();


 @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    state.identitys.value =  await state.station.loadIdentitys(reload: true);
    var users =  await state.station.loadMembers(PageRequest(offset: 0, limit: 9999, filter: ''));
    state.unitMember.addAll(users.result??[]);
  }
}
