import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/target/base/belong.dart';

import '../base/target.dart';

abstract class IStrorage extends ITarget {
  //是否处于激活状态
  late bool isActivate;
  //激活存储
  Future<bool> activateStorage();
}

class Storage extends Target implements IStrorage {
  Storage(XTarget _metadata, List<String> _relations, IBelong _space)
      : super(
          [_space.key],
          _metadata,
          [..._relations, _metadata.id],
          _space,
        ) {}
}
