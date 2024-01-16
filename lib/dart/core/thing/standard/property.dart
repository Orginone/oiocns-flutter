import 'package:orginone/dart/base/schema.dart';

import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/fileinfo.dart';

abstract class IProperty extends IStandardFileInfo<XProperty> {
  late List<XAttribute> attributes;

  // 删除表单
  @override
  Future<bool> delete({bool? notity});
}

class Property extends StandardFileInfo<XProperty> implements IProperty {
  @override
  final XProperty metadata;
  @override
  final IDirectory directory;

  @override
  final List<XAttribute> attributes = [];
  @override
  String get cacheFlag => 'propertys';
  @override
  List<String> get groupTags {
    if (metadata.valueType == null) {
      return [...super.groupTags];
    }
    return [metadata.valueType!, ...super.groupTags];
  }

  ///构造函数
  Property(this.metadata, this.directory)
      : super(metadata, directory, directory.resource.propertyColl) {
    metadata.typeName = '属性';
  }

  @override
  Future<bool> copy(IDirectory destination) async {
    if (allowCopy(destination)) {
      return await super
          .copyTo(destination.id, coll: destination.resource.propertyColl);
    }
    return false;
  }

  @override
  Future<bool> move(IDirectory destination) async {
    if (allowMove(destination)) {
      return await super
          .moveTo(destination.id, coll: destination.resource.propertyColl);
    }
    return false;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
