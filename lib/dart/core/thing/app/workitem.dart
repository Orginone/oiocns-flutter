

import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/base/form.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/dart/core/thing/base/work.dart';

import 'application.dart';



abstract class IWorkItem extends IWork {
  // 加载所有的办事
  Future<List<IWorkDefine>> loadAllWorkDefines({bool reload = false});
}


 class WorkItem extends Work implements IWorkItem {
  WorkItem(XSpecies metadata, IApplication app,[IWorkItem? parent]):super(metadata,app.current,app,parent){
    speciesTypes = [];

    for (var item in metadata.nodes??[]) {
      var workItem = createChildren(item,app.current);
      if(workItem!=null){
        children.add(workItem);
      }
    }
    var type = SpeciesType.getType(metadata.typeName);
    if (type != null) {
      speciesTypes.add(type);
    }
  }

  @override
  Future<List<IWorkDefine>> loadAllWorkDefines({bool reload = false}) async{
    List<IWorkDefine> works = [];
    works.addAll(await loadWorkDefines(reload: reload));
    for (var item in children) {
      works.addAll(await (item as IWorkItem).loadWorkDefines(reload: reload));
    }
    return works;
  }

  @override
  ISpeciesItem? createChildren(XSpecies metadata, ITarget current) {
     if(metadata.typeName == SpeciesType.work.label){
       return WorkItem(metadata, app, this);
     }
     return null;
  }
}
