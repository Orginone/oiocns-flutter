

import 'package:orginone/dart/base/model.dart' hide ThingModel;
import 'package:orginone/dart/core/getx/frequently_used_list/base_frequently_used_list_state.dart';
import 'package:orginone/model/thing_model.dart';

class StoreState extends BaseFrequentlyUsedListState<StoreRecent,dynamic>{

}

class StoreRecent extends Recent{

  FileItemModel? fileItemShare;

  ThingModel? thing;

  StoreEnum storeEnum;
  StoreRecent({super.avatar,super.name,super.id,this.fileItemShare,this.thing,required this.storeEnum});
}

enum StoreEnum{
  file("file"),
  thing("thing");

  final String label;
  const StoreEnum(this.label);
}