import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/app/application.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/dart/core/thing/base/work.dart';
import 'package:orginone/dart/core/thing/store/thingclass.dart';


abstract class IMarket extends IWork{

}

class Market extends Work implements IMarket,IApplication{
  Market(super.metadata, super.current){
    speciesTypes = [SpeciesType.thing];

    for (var item in metadata.nodes ?? []) {
      var subItem = createChildren(item, current);
      if (subItem!=null) {
        children.add(subItem);
      }
    }
  }

  @override
  ISpeciesItem? createChildren(XSpecies metadata, ITarget current) {
    if(metadata.typeName == SpeciesType.thing.label){
      return ThingClass(metadata, this.current);
    }
    return null;
  }
}