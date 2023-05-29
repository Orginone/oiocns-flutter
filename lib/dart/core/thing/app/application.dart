import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/base/form.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/dart/core/thing/base/work.dart';
import 'package:orginone/dart/core/thing/store/thingclass.dart';

import 'data.dart';
import 'workitem.dart';


abstract class IApplication extends ISpeciesItem {
  late List<IWorkDefine> defines;

  Future<List<IWorkDefine>> loadWorkDefines();

}

class Application extends SpeciesItem implements IApplication {
  Application(super.metadata, super.current) {
    defines = [];
    speciesTypes =
    [SpeciesType.thing, SpeciesType.work, SpeciesType.data];
    for (var item in metadata.nodes ?? []) {
      var subItem = createChildren(item, current);
      if (subItem != null) {
        children.add(subItem);
      }
    }
  }

  @override
  late List<IWorkDefine> defines;

  @override
  Future<List<IWorkDefine>> loadWorkDefines() async {
    defines.clear();
    for (var item in children) {
      if (item.metadata.typeName == SpeciesType.work.label) {
        defines.addAll(await (item as IWorkItem).loadAllWorkDefines());
      }
    }
    return defines;
  }

  @override
  ISpeciesItem? createChildren(XSpecies metadata, ITarget current) {
    switch (SpeciesType.getType(metadata.typeName)) {
      case SpeciesType.thing:
        return  ThingClass(metadata, current);
      case SpeciesType.work:
        return WorkItem(metadata, this);
      case SpeciesType.data:
        return Data(metadata, this);
    }
    return null;
  }

}