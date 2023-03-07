import 'package:orginone/dart/base/model.dart';
import 'ispecies.dart' show ISpeciesItem;
import 'species.dart' show SpeciesItem;
import 'package:orginone/dart/base/api/kernelapi.dart';
import '../../base/schema.dart';

// 加载分类树
// @param id 组织id
KernelApi kernel = KernelApi.getInstance();
Future<ISpeciesItem?> loadSpeciesTree(String id) async {
  ISpeciesItem? item;
  final res = await kernel.querySpeciesTree(id);
  if (res.success) {
    item = SpeciesItem(res.data as XSpecies, null);
  }
  return item;
}

// export type { INullSpeciesItem, ISpeciesItem } from './ispecies';