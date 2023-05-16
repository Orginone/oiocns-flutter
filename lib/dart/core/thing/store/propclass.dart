



import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/main.dart';

abstract class IPropClass implements ISpeciesItem {
  /// 类别属性
  late List<XProperty> propertys;

  /// 加载所有属性
  Future<List<XProperty>> loadAllProperty();

  /// 加载属性
  Future<List<XProperty>> loadPropertys({bool reload = false});

  /// 新建表单特性
  Future<XProperty?> createProperty(PropertyModel data);

  /// 更新表单特性
  Future<bool> updateProperty(PropertyModel data);

  /// 删除表单特性
  Future<bool> deleteProperty(XProperty data);

  Future<List<XAttribute>> loadPropAttributes(XProperty data);
}

class PropClass extends SpeciesItem implements IPropClass{
  PropClass(super.metadata, super.current,[super.parent]){
    propertys = [];
    for (var item in metadata.nodes ?? []) {
      children.add(PropClass(item, current, this));
    }
    speciesTypes = [];
    var speciesType = SpeciesType.getType(metadata.typeName);
    if(speciesType!=null){
      speciesTypes.add(speciesType);
    }
  }

  @override
  late List<XProperty> propertys;

  @override
  Future<XProperty?> createProperty(PropertyModel data) async{
    data.speciesId = metadata.id;
    var res = await kernel.createProperty(data);
    if (res.success && res.data?.id != null) {
      propertys.add(res.data!);
      return res.data!;
    }
  }

  @override
  ISpeciesItem? createChildren(XSpecies metadata, ITarget current) {
    // TODO: implement createChildren
    return PropClass(metadata, current, this);
  }

  @override
  Future<bool> deleteProperty(XProperty data) async{
    var index = propertys.indexWhere((i) => i.id == data.id);
    if (index > -1) {
      var res = await kernel.deleteProperty(IdReq(id: data.id!));
      if (res.success) {
        propertys.removeAt(index);
      }
      return res.success;
    }
    return false;
  }

  @override
  Future<List<XProperty>> loadAllProperty() async{
    var result = <XProperty>[];
    await loadPropertys();
    result.addAll(propertys);
    for (var item in children) {
      result.addAll(await (item as IPropClass).loadAllProperty());
    }
    return result;

  }

  @override
  Future<List<XProperty>> loadPropertys({bool reload = false}) async{
    if (propertys.isEmpty || reload) {
      var res = await kernel.queryPropertys(IdReq(id: metadata.id));
      if (res.success) {
        propertys = res.data?.result ?? [];
      }
    }
    return propertys;
  }

  @override
  Future<bool> updateProperty(PropertyModel data) async{
    var index = propertys.indexWhere((i) => i.id == data.id);
    if (index > -1) {
      data.speciesId = metadata.id;
      var res = await kernel.updateProperty(data);
      if (res.success && res.data?.id != null) {
        propertys[index] = res.data!;
      }
      return res.success;
    }
    return false;
  }

  @override
  Future<List<XAttribute>> loadPropAttributes(XProperty data) async{
    int index = propertys.indexOf(data);
    if (index > -1) {
      var res = await kernel.queryPropAttributes(IdReq(id: data.id!));
      if (res.success) {
        return res.data?.result ?? [];
      }
    }
    return [];
  }

}