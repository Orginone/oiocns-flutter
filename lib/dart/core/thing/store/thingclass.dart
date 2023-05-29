import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/base/form.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/main.dart';

import '../app/application.dart';

abstract class IThingClass extends ISpeciesItem {
  late List<IForm> forms;

  Future<List<IForm>> loadForms({bool reload = false});

  Future<IForm?> createForm(FormModel data);

}

class ThingClass extends SpeciesItem implements IThingClass {
  ThingClass(XSpecies metadata, ITarget current, [IThingClass? parent])
      : super(metadata, current, parent) {
    for (var item in metadata.nodes ?? []) {
      var child = createChildren(item, current);
      if(child!=null){
        children.add(child);
      }
    }
    speciesTypes = [];
    forms = [];
    var type = SpeciesType.getType(metadata.typeName);
    if (type != null) {
      speciesTypes.add(type);
    }
  }

  @override
  late List<IForm> forms;

  @override
  Future<IForm?> createForm(FormModel data) async {
    data.shareId = current.metadata.id;
    data.speciesId = metadata.id;
    var res = await kernel.createForm(data);
    if (res.success && res.data != null) {
      var form = Form(res.data!, this);
      forms.add(form);
      return form;
    }
    return null;
  }

  @override
  Future<List<IForm>> loadForms({bool reload = false}) async{
    if (forms.isEmpty || reload) {
      final res = await kernel.querySpeciesForms(GetSpeciesResourceModel( id: current.metadata.id,
        speciesId: metadata.id,
        belongId: current.space.metadata.id,
        upTeam: current.metadata.typeName == TargetType.group.label,
        upSpecies: true,
        page: PageRequest(offset: 0, limit: 9999, filter: ''),
      ));
      if (res.success && res.data != null) {
        forms =
            (res.data!.result ?? []).map<IForm>((i) => Form(i, this)).toList();
      }
    }
    return forms;
  }



  @override
  ISpeciesItem? createChildren(XSpecies metadata, ITarget current) {
    // TODO: implement createChildren
    if(metadata.typeName == SpeciesType.thing.label){
      return ThingClass(metadata, this.current, this);
    }
    return null;
  }
}
