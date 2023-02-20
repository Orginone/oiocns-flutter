


import 'package:orginone/dart/core/getx/base_get_list_state.dart';

class CheckState extends BaseGetListState{

}

enum CheckType{
  notStarted,
  saved,
  loss
}

extension EcheckType on CheckType{
  String get name{
    switch(this){

      case CheckType.notStarted:
        return "未盘点";
      case CheckType.saved:
        return "盘存";
      case CheckType.loss:
        return "盘亏";
    }
  }
}
