import '../../base/schema.dart';
import '../../base/api/kernelapi.dart';

class XCollection {
  late bool _loaded;
  late List _cache = [];
  late String _collName;
  late XTarget _target;
  late List<String> _relations = [];

  ///构造方法
  constructor(XTarget target, String name, List<String> relations) {
    _loaded = false;
    _cache = [];
    _collName = name;
    _target = target;
    _relations = relations;
  }
}
