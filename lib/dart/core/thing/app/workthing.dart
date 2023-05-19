import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/base/form.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/main.dart';

import 'application.dart';

abstract class IWorkThing extends ISpeciesItem {
  late List<IForm> forms;

  late IApplication app;

  Future<List<IForm>> loadForms({bool reload = false});

  Future<IForm?> createForm(FormModel data);

  Future<List<IForm>> loadAllForms({bool reload = false});
}

class WorkThing extends SpeciesItem implements IWorkThing {
  WorkThing(XSpecies metadata, this.app, [IWorkThing? parent])
      : super(metadata, app.current, parent) {
    for (var item in metadata.nodes ?? []) {
      children.add(WorkThing(item, app, this));
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
  late IApplication app;

  @override
  Future<List<IForm>> loadAllForms({bool reload = false}) async{
    List<IForm> result = await loadForms();
    for (var item in children) {
    result.addAll(await (item as IWorkThing).loadAllForms());
    }
    return result;
  }

  @override
  ISpeciesItem? createChildren(XSpecies metadata, ITarget current) {
    // TODO: implement createChildren
    return WorkThing(metadata, app, this);
  }
}
