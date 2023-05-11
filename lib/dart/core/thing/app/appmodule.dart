

import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/base/form.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/dart/core/thing/base/work.dart';

import 'work/reportbi.dart';
import 'work/workform.dart';
import 'work/workitem.dart';

abstract class  IAppModule extends ISpeciesItem {

  late List<IWorkDefine> defines;


  Future<List<IWorkDefine>> loadWorkDefines();

//  表单
  Future<List<XForm>> loadForms();

//表单特性
  Future<List<XAttribute>> loadAttributes();

}
class AppModule extends SpeciesItem implements IAppModule {
  AppModule(super.metadata, super.current,[super.parent]){
    defines =[];
    speciesTypes = [
      SpeciesType.appModule,
      SpeciesType.workForm,
      SpeciesType.workItem,
      SpeciesType.reportBI,
    ];
    for (var item in metadata.nodes ?? []) {
      var subItem = createChildren(item, current);
      if (subItem!=null) {
        children.add(subItem);
      }
    }
  }

  @override
  Future<List<XAttribute>> loadAttributes() async{
    var result = <XAttribute>[];
    for (var item in children) {
      switch (SpeciesType.getType(item.metadata.typeName)) {
        case SpeciesType.workForm:
          await (item as IForm).loadAttributes();
          result.addAll((item as IForm).attributes);
          break;
        case SpeciesType.appModule:
          result.addAll(await (item as IAppModule).loadAttributes());
          break;
      }
    }
    return result;
  }

  @override
  Future<List<XForm>> loadForms() async{
    var result = <XForm>[];
    for (var item in children) {
      switch (SpeciesType.getType(item.metadata.typeName)) {
        case SpeciesType.workForm:
          await (item as IForm).loadForms();
          result.addAll(item.forms);
          break;
        case SpeciesType.appModule:
          result.addAll(await (item as IAppModule).loadForms());
          break;
      }
    }
    return result;
  }

  @override
  ISpeciesItem? createChildren(XSpecies metadata, ITarget current) {
    switch (SpeciesType.getType(metadata.typeName)) {
      case SpeciesType.workForm:
        return WorkForm(metadata, current, this);
      case SpeciesType.workItem:
        return WorkItem(metadata, current, this);
      case SpeciesType.reportBI:
        return ReportBI(metadata, current, this);
      case SpeciesType.appModule:
        return AppModule(metadata, current, this);
      default:
        return null;
    }
  }

  @override
  late List<IWorkDefine> defines;

  @override
  Future<List<IWorkDefine>> loadWorkDefines() async{
    defines = [];
    for (final item in children) {
      switch (SpeciesType.getType(item.metadata.typeName)) {
        case SpeciesType.workItem:
          defines.addAll(await (item as IWork).loadWorkDefines());
          break;
        case SpeciesType.appModule:
          defines.addAll(await (item as IAppModule).loadWorkDefines());
          break;
      }
    }
    return defines;
  }

}