import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/main.dart';

import 'dict.dart';

abstract class IDictClass extends ISpeciesItem {
  // 字典
  late List<IDict> dicts;

  //加载所有字典
  Future<List<IDict>> loadAllDicts();

  //加载元数据字典
  Future<List<IDict>> loadDicts({bool reload = false});

  //添加字典
  Future<IDict?> createDict(DictModel data);
}

class DictClass extends SpeciesItem implements IDictClass {
  DictClass(XSpecies metadata, ITarget current, [IDictClass? parent]) : super(metadata, current,parent) {
    dicts = [];
    if(parent!=null){
      dicts.addAll(parent.dicts);
    }
    for (var node in metadata.nodes??[]) {
      children.add(DictClass(node, this.current, this));
    }
    speciesTypes = [SpeciesType.getType(metadata.typeName)!];
  }

  @override
  late List<IDict> dicts;

  @override
  Future<IDict?> createDict(DictModel data) async{
    data.speciesId = metadata.id;
    final res = await kernel.createDict(data);
    if (res.success && res.data != null) {
      final dict = Dict(res.data!, this);
      dicts.add(dict);
      return dict;
    }
  }

  @override
  Future<List<IDict>> loadAllDicts() async{
    List<IDict> dicts = [];
    dicts.addAll(await loadDicts());
    for (final item in children) {
      final subDicts = await (item as IDictClass).loadAllDicts();
      for (final sub in subDicts) {
        final existingIndex = dicts.indexWhere((i) => i.metadata.id == sub.metadata.id);
        if (existingIndex < 0) {
          dicts.add(sub);
        }
      }
    }
    return dicts;
  }

  @override
  Future<List<IDict>> loadDicts({bool reload = false}) async{
    if (dicts.isEmpty || reload) {
      final res = await kernel.queryDicts(IdReq(id: metadata.id));
      if (res.success && res.data!=null) {
        dicts = (res.data!.result ?? []).map((item) {
          return Dict(item, this);
        }).toList();
      }
    }
    return dicts;
  }

  void propertyChanged(String type, List<IDict> props) {
    if (dicts.isNotEmpty) {
      for (final item in props) {
        switch (type) {
          case 'deleted':
            dicts.removeWhere((i) => i.metadata.id == item.metadata.id);
            break;
          case 'added':
            dicts.add(item);
            break;
          case 'updated':
            final index = dicts.indexWhere((i) => i.metadata.id == item.metadata.id);
            if (index > -1) {
              dicts[index] = item;
            }
            break;
        }
      }
      for (final item in children) {
        (item as DictClass).propertyChanged(type, props);
      }
    }
  }






}
