import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/base/form.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/dart/core/thing/base/work.dart';

import 'data.dart';
import 'workitem.dart';
import 'workthing.dart';


abstract class IApplication extends ISpeciesItem {
  late List<IWorkDefine> defines;


  Future<List<IWorkDefine>> loadWorkDefines();

//  表单
  Future<List<IForm>> loadForms();

}

class Application extends SpeciesItem implements IApplication {
  Application(super.metadata, super.current) {
    defines = [];
    speciesTypes =
    [SpeciesType.workThing, SpeciesType.workItem, SpeciesType.data];
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
  Future<List<IForm>> loadForms() async {
    var result = <IForm>[];
    for (var item in children) {
      if (item.metadata.typeName == SpeciesType.workThing) {
        var forms = await (item as IWorkThing).loadForms();
        result.addAll(forms);
      }
    }
    return result;
  }

  @override
  Future<List<IWorkDefine>> loadWorkDefines() async {
    defines.clear();
    for (var item in children) {
      if (item.metadata.typeName == SpeciesType.workItem.label) {
        defines.addAll(await (item as IWorkItem).loadAllWorkDefines());
      }
    }
    return defines;
  }

  @override
  ISpeciesItem? createChildren(XSpecies metadata, ITarget current) {
    switch (SpeciesType.getType(metadata.typeName)) {
      case SpeciesType.workThing:
        return  WorkThing(metadata, this);
      case SpeciesType.workItem:
        return WorkItem(metadata, this);
      case SpeciesType.data:
        return Data(metadata, this);
    }
  }

}