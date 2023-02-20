import 'package:orginone/dart/core/getx/base_list_controller.dart';

import '../dialog.dart';
import 'state.dart';

class CheckController extends BaseListController<CheckState> {
  final CheckState state = CheckState();
  final CheckType checkType;

  CheckController(this.checkType);

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    state.dataList.addAll(List.generate(10, (index) => index));
    refreshController.loadNoData();
  }

  void inventory(CheckType type) {
    CheckDialog.showInventoryDialog(context,title: type.name,onSubmit: (str){
      print(str);
    });
  }

  void recheck() {}
}
