import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/base/species.dart';

abstract class IResource extends ISpeciesItem {}

class Resource extends SpeciesItem implements IResource {
  Resource(super.metadata, super.current, [super.parent]) {
    speciesTypes = [];

    for (var item in metadata.nodes ?? []) {
      children.add(Resource(item, current, this));
    }
    var type = SpeciesType.getType(metadata.typeName);
    if (type != null) {
      speciesTypes.add(type);
    }
  }

  @override
  ISpeciesItem? createChildren(XSpecies metadata, ITarget current) {
    // TODO: implement createChildren
    return  Resource(metadata, current, this);
  }
}
