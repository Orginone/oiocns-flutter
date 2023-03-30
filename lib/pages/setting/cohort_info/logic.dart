import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class CohortInfoController extends BaseController<CohortInfoState> {
 final CohortInfoState state = CohortInfoState();


 @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    var users = await state.cohort.loadMembers(PageRequest(offset: 0, limit: 9999, filter: ''));
    state.unitMember.addAll(users.result??[]);
  }
}
