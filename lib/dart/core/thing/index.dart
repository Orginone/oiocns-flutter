import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/app/application.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/dart/core/thing/resource/resource.dart';
import 'package:orginone/dart/core/thing/store/thingclass.dart';
import '../../base/schema.dart';
import 'dict/dictclass.dart';
import 'market/market.dart';
import 'store/propclass.dart';


ISpeciesItem? createSpeciesForType(XSpecies metadata,ITarget current){
  switch(SpeciesType.getType(metadata.typeName)){
    case SpeciesType.dict:
      return DictClass(metadata,current);
    case SpeciesType.store:
      return PropClass(metadata,current);
    case SpeciesType.application:
      return Application(metadata,current);
    case SpeciesType.market:
      return Market(metadata, current);
    case SpeciesType.thing:
      return ThingClass(metadata, current);
    default:
      return null;
  }
}
