
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/thing/base/form.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/main.dart';

abstract class IWorkForm extends ISpeciesItem {
  late List<IForm> forms;

  Future<List<IForm>> loadForms({bool reload = false});

  Future<IForm?> createForm(FormModel data);
}


 class WorkForm extends SpeciesItem implements IWorkForm {
  WorkForm(super.metadata, super.current, super.parent){
    speciesTypes = [];
    forms = [];
  }

  @override
  late List<IForm> forms;

  @override
  Future<IForm?> createForm(FormModel data) async{
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
        page: PageRequest(offset: 0, limit: 9999, filter: ''),));
      if (res.success && res.data!=null) {
        forms = (res.data!.result ?? []).map<IForm>((i) => Form(i, this)).toList();
      }
    }
    return forms;
  }


}
