import 'package:orginone/dart/base/common/commands.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/fileinfo.dart';

import 'species.dart';

abstract class IPageTemplate extends IStandardFileInfo<XPageTemplate> {
  late Command command;
  List<ISpecies> species = [];
  late String relations;
  Future<List<ISpecies>> loadSpecies(List<String> speciesIds);
}

class PageTemplate extends StandardFileInfo<XPageTemplate>
    implements IPageTemplate {
  PageTemplate(XPageTemplate metadata, IDirectory directory)
      : super(metadata, directory, directory.resource.templateColl) {
    command = Command();
  }
  @override
  bool canDesign = true;
  @override
  late Command command;
  @override
  List<ISpecies> species = [];

  @override
  String get cacheFlag => 'pages';

  @override
  String get relations =>
      '$belongId:${directory.target.spaceId}-${directory.target.id}';

  @override
  Future<bool> copy(IDirectory destination) async {
    if (allowCopy(destination)) {
      return await super
          .copyTo(destination.id, coll: destination.resource.templateColl);
    }
    return false;
  }

  @override
  Future<bool> move(IDirectory destination) async {
    if (allowMove(destination)) {
      return await super
          .moveTo(destination.id, coll: destination.resource.templateColl);
    }
    return false;
  }

  @override
  bool receive(String operate, dynamic data) {
    var d = data as XStandard;
    coll.removeCache((i) => i.id != d.id);
    // super.receive(operate, data);
    coll.cache.add(metadata);
    return true;
  }

  @override
  Future<List<ISpecies>> loadSpecies(List<String> speciesIds) async {
    final already = species.map((item) => item.id).toList();
    final filter =
        speciesIds.where((speciesId) => !already.contains(speciesId)).toList();
    if (filter.isNotEmpty) {
      final species = await directory.resource.speciesColl.find(ids: filter);
      for (final item in species) {
        final meta = Species(item, directory);
        await meta.loadContent();
        this.species.add(meta);
      }
    }
    final result = <ISpecies>[];
    for (final speciesId in speciesIds) {
      final item = species.firstWhere((one) => one.id == speciesId);
      result.add(item);
    }
    return result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
