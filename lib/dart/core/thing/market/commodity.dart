import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/base/form.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/main.dart';

import 'market.dart';

abstract class ICommodity implements ISpeciesItem {
  //市场接口
  late IMarket market;

  IForm? form;

  //所有的表单
  Future<List<IForm>> loadAllForms();

  //所有的表单特性
  Future<IForm?> loadForm({bool reload = false});
}

class Commodity extends SpeciesItem implements ICommodity {
  Commodity(this.market, super.metadata, super.current, super.parent);

  @override
  late IMarket market;

  @override
  ISpeciesItem? createChildren(XSpecies metadata, ITarget current) {
    // TODO: implement createChildren
    return Commodity(market, metadata, current, this);
  }

  @override
  Future<List<IForm>> loadAllForms() async {
    List<IForm> result = [];
    await loadForm();
    if (form != null) {
      result.add(form!);
    }
    for (var item in children) {
      if (item is ICommodity) {
        result.addAll(await item.loadAllForms());
      }
    }
    return result;
  }

  @override
  Future<bool> delete() async {
    await loadForm();
    if (form != null) {
      await form!.delete();
    }
    return await super.delete();
  }

  @override
  Future<IForm?> loadForm({bool reload = false}) async{
    if (form == null || reload) {
      final res = await kernel.querySpeciesForms(GetSpeciesResourceModel( id: current.metadata.id,
        speciesId: metadata.id,
        belongId: current.space.metadata.id,
        upTeam: current.metadata.typeName == TargetType.group.label,
        upSpecies: true,
        page: PageRequest(offset: 0, limit: 9999, filter: ''),));
      if (res.success) {
        if (res.data!.result!= null && res.data!.result!.isNotEmpty) {
          form = Form(res.data!.result![0], this);
        } else {
          var createRes = await kernel.createForm(FormModel( name:metadata.name,
            id: '0',
            rule: '{}',
            code: metadata.code,
            remark: metadata.remark,
            speciesId: metadata.id,
            shareId: metadata.shareId,));
          if (createRes.success && createRes.data != null) {
            form = Form(createRes.data!, this);
          }
        }
      }
    }
    return form;
  }

  @override
  IForm? form;
}