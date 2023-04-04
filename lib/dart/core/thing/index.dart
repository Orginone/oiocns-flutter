import 'package:orginone/dart/base/model.dart';
import 'ispecies.dart' show ISpeciesItem;
import 'species.dart' show SpeciesItem;
import 'package:orginone/dart/base/api/kernelapi.dart';
import '../../base/schema.dart';

// 加载分类树
// @param id 组织id
Future<SpeciesItem?> loadSpeciesTree(String id) async {
  SpeciesItem? item;
  final res = await KernelApi.getInstance().querySpeciesTree(id as IDBelongReq);
  if (res.success) {
    item = SpeciesItem(res.data as XSpecies, null);
  }
  return item;
}

// export type { INullSpeciesItem, ISpeciesItem } from './ispecies';