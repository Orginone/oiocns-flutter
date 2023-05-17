

import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/app/appmodule.dart';
import 'package:orginone/dart/core/thing/base/form.dart';
import 'package:orginone/dart/core/thing/base/work.dart';



abstract class IWorkItem extends IWork {
  late IAppModule appModule;
}



 class WorkItem extends Work implements IWorkItem {
  WorkItem(XSpecies metadata, ITarget current,IAppModule parent):super(metadata,current,parent){
    speciesTypes = [];
    appModule = parent;
  }


  @override
  Future<List<XAttribute>> loadAttributes() async{
    return await appModule.loadAttributes();
  }

  @override
  Future<List<IForm>> loadForms() async{
    return await appModule.loadForms();
  }

  @override
  late IAppModule appModule;
}
