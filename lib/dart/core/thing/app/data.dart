import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/base/species.dart';

import 'application.dart';

abstract class IData extends ISpeciesItem {
  //对应的应用
  late IApplication app;
}

class Data extends SpeciesItem implements IData {
  @override
  late IApplication app;

  Data(XSpecies metadata, this.app,[IData? parent]) : super(metadata, app.current,parent){
    for (var item in metadata.nodes??[]) {
      children.add(Data(item, app, this));
    }
    speciesTypes = [];
    var type = SpeciesType.getType(metadata.typeName);
    if (type != null) {
      speciesTypes.add(type);
    }
  }

  @override
  ISpeciesItem? createChildren(XSpecies metadata, ITarget current) {
    return Data(metadata, app, this);
  }
}
