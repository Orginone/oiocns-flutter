


import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/dart/core/thing/base/work.dart';

import 'commodity.dart';

abstract class IMarket extends IWork{

}

class Market extends Work implements IMarket{
  Market(super.metadata, super.current);


  @override
  ISpeciesItem? createChildren(XSpecies metadata, ITarget current) {
    // TODO: implement createChildren
    return Commodity(this,metadata, current, this);
  }
  @override
  Future<List<XAttribute>> loadAttributes() async{
    List<XAttribute> result = [];
    for (var item in children) {
      if (item is ICommodity) {
        result.addAll(await item.loadAllAttributes());
  }
  }
    return result;
  }

  @override
  Future<List<XForm>> loadForms() async{
    List<XForm> result = [];
    for (var item in children) {
      if (item is ICommodity) {
        result.addAll(await item.loadAllForms());
  }
  }
    return result;
  }

}