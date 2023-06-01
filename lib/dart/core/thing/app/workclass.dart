

import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/base/form.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/main.dart';

import 'application.dart';



abstract class IWorkClass extends ISpeciesItem {
   late IApplication app;
   late List<IForm> forms;

   Future<List<IForm>> loadForms({bool reload = false});

   Future<IForm?> createForm(FormModel data);
}

class WorkClass extends SpeciesItem implements IWorkClass{
  WorkClass(XSpecies metadata, this.app,[IWorkClass? parent]):super(metadata,app.current,parent){
    forms = [];
    speciesTypes = [SpeciesType.getType(metadata.typeName)!];

    for (var item in metadata.nodes??[]) {
      var subItem = createChildren(item, app.current);
      if (subItem!=null) {
        children.add(subItem);
      }
    }
  }

  @override
  late IApplication app;

  @override
  late List<IForm> forms;

  @override
  Future<IForm?> createForm(FormModel data) async{
    data.shareId = current.id;
    data.speciesId = metadata.id;
    data.typeName = SpeciesType.work.label;
    var res = await kernel.createForm(data);
    if (res.success && res.data!=null) {
      var form = Form(res.data!, this);
      forms.add(form);
      return form;
    }
    return null;
  }

  @override
  Future<List<IForm>> loadForms({bool reload = false}) {
    // TODO: implement loadForms
    throw UnimplementedError();
  }

  @override
  ISpeciesItem? createChildren(XSpecies metadata, ITarget current) {
     if(metadata.typeName == SpeciesType.work.label){
       return WorkClass(metadata, app, this);
     }
     return null;

  }

}