import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/target/base/belong.dart';

import '../base/target.dart';

abstract class IStorage extends ITarget {
  //是否处于激活状态
  final bool isActivate;

  IStorage(this.isActivate);
  //激活存储
  Future<bool> activateStorage();
}

class Storage extends Target implements IStorage {
  Storage(XTarget _metadata, List<String> _relations, IBelong _space)
      : super(
          [_space.key],
          _metadata,
          [..._relations, _metadata.id],
        );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
