


import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/app/application.dart';
import 'package:orginone/dart/core/thing/app/workthing.dart';
import 'package:orginone/dart/core/thing/base/form.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/dart/core/thing/base/work.dart';


abstract class IMarket extends IWork{

}

class Market extends Work implements IMarket,IApplication{
  Market(super.metadata, super.current){
    speciesTypes = [SpeciesType.workThing];

    for (var item in metadata.nodes ?? []) {
      var subItem = createChildren(item, current);
      if (subItem!=null) {
        children.add(subItem);
      }
    }
  }

  @override
  ISpeciesItem? createChildren(XSpecies metadata, ITarget current) {
    // TODO: implement createChildren
    return WorkThing(metadata, this);
  }

  @override
  Future<List<IForm>> loadForms() async {
    List<IForm> result = [];
    for (var item in children) {
      if (item is IWorkThing) {
        result.addAll(await item.loadAllForms());
      }
    }
    return result;
  }

}