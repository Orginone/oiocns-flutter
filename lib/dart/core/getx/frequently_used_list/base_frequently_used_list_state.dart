import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_list_state.dart';

class BaseFrequentlyUsedListState<T extends Recent, S> extends BaseGetListState<S> {
  var frequentlyUsedList = <S>[].obs;
}


class Recent{
  final String id;
  final String name;
  final String url;

  Recent(this.id, this.name, this.url);
}