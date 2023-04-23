import 'package:orginone/dart/base/model.dart';
import 'ispecies.dart' show ISpeciesItem;
import 'species.dart' show SpeciesItem;
import 'package:orginone/dart/base/api/kernelapi.dart';
import '../../base/schema.dart';

// 加载分类树
// @param id 组织id
Future<List<SpeciesItem>> loadSpeciesTree(String id,String spaceId,[bool upTeam = false]) async {
  List<SpeciesItem> item;
  final res = await KernelApi.getInstance().querySpeciesTree(GetSpeciesModel(id: id, upTeam: upTeam));
  if (res.success && res.data!=null) {
    item = [];
    for (var element in res.data!.result!) {
      item.add(SpeciesItem(element, null,spaceId));
    }
    return item;
  }
  return [];
}

// export type { INullSpeciesItem, ISpeciesItem } from './ispecies';