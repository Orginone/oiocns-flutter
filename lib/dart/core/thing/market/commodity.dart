import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/base/form.dart';
import 'package:orginone/dart/core/thing/base/species.dart';

import 'market.dart';

abstract class ICommodity implements IForm {
  //市场接口
  late IMarket market;

  //所有的表单
  Future<List<XForm>> loadAllForms();

  //所有的表单特性
  Future<List<XAttribute>> loadAllAttributes();
}

class Commodity extends Form implements ICommodity{
  Commodity(this.market,super.metadata, super.current, super.parent);

  @override
  late IMarket market;

  @override
  ISpeciesItem? createChildren(XSpecies metadata, ITarget current) {
    // TODO: implement createChildren
    return Commodity(market,metadata, current, this);
  }

  @override
  Future<List<XAttribute>> loadAllAttributes() async{
    List<XAttribute> result = [];
    await loadAttributes();
    result.addAll(attributes);
    for (var item in children) {
      if (item is ICommodity) {
        result.addAll(await item.loadAllAttributes());
  }
  }
    return result;
  }

  @override
  Future<List<XForm>> loadAllForms() async{
    List<XForm> result = [];
    await loadForms();
    result.addAll(forms);
    for (var item in children) {
      if (item is ICommodity) {
        result.addAll(await item.loadAllForms());
  }
  }
    return result;
  }

}