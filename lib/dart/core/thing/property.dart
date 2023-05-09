



import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/thing/iproperty.dart';

class Property extends IProperty{

  KernelApi kernel = KernelApi.getInstance();

  Property(String id){
    belongId = id;
  }

  @override
  Future<XProperty?> createProperty(PropertyModel data) async{
    data.belongId = belongId;
    var res = await kernel.createProperty(data);
    return res.data;
  }

  @override
  Future<bool> deleteProperty(String id) async{
    var res = await kernel.deleteProperty(IdReq(id: id));
    return res.data??false;
  }

  @override
  Future<XPropertyArray?> loadProperty(PageRequest page) async{
    var res = await kernel.queryPropertys(IdBelongReq(belongId: belongId, page: page));
    return res.data;
  }

  @override
  Future<XProperty?> updateProperty(PropertyModel data) async{
    data.belongId = belongId;
    var res = await kernel.updateProperty(data);
    return res.data;
  }

}