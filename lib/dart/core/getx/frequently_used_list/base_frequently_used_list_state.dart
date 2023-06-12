import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_list_state.dart';

class BaseFrequentlyUsedListState<T extends Recent, S> extends BaseGetListState<S> {
  var mostUsedList = <T>[].obs;
}


class Recent{
  String? id;
  String? name;
  dynamic avatar;

  Recent({this.id, this.name, this.avatar});
}