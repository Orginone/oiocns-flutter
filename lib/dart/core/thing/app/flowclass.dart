



import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/base/flow.dart';
import 'package:orginone/dart/core/thing/base/species.dart';

import 'application.dart';

abstract class IFlowClass extends IFlow{

  Future<List<IWorkDefine>> loadAllWorkDefines({bool reload = false});
}

class  FlowClass extends Flow implements IFlowClass {
  FlowClass(XSpecies metadata, IApplication app,[IFlowClass? parent]):super(metadata,app.current,app,parent){
    speciesTypes = [SpeciesType.getType(metadata.typeName)!];

    for (var item in metadata.nodes??[]) {
      var subItem = createChildren(item, app.current);
      if (subItem!=null) {
        children.add(subItem);
      }
    }
  }

  @override
  Future<List<IWorkDefine>> loadAllWorkDefines({bool reload = false}) async{
    List<IWorkDefine> works = [];
    works.addAll(await loadWorkDefines(reload: reload));
    for (var item in children) {
    works.addAll(await (item as IFlowClass).loadWorkDefines(reload: reload));
    }
    return works;
  }


  @override
  ISpeciesItem? createChildren(XSpecies metadata, ITarget current) {
     if(metadata.typeName == SpeciesType.flow.label){
       return FlowClass(metadata,app,this);
     }
     return null;
  }
}