import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/main.dart';

///对象工具类
class XObject<T extends Xbase> {
  late bool _loaded;
  dynamic _cache;
  late String _objName;
  late XTarget _target;
  late List<String> _relations;
  late Map<String,Function(List<dynamic>)> _method;
  XObject(XTarget target, String name, List<String> relations,List<String> keys) {
    _loaded = false;
    _target = target;
    _relations = relations;
    _objName = name;
    _method = [];
    kernel.subscribed(this.subMethodName, keys, (res) => _objectCallback(res));
  }

  dynamic get cache() {
    return this._cache;
  }

  String get objNmae() {
    return this._objName;
  }

  String get subMethodName(){
    return '${this._target.belongId}-${this._target.id}-${this._objName}';
  }
  

  String fullPath(String path) {
    if (path != '') {
      path = '.$path';
    } else {
      path = '';
    }
    return this._objName + path;
  }

  Future<dynamic> all() async {
    var kernel = KernelApi();
    if (!this._loaded) {
      var res = await kernel.objectGet(
        this._target.belongId!,
        this._relations,
        this._objName,
      );
      if (res.success) {
        this._cache = res.data;
        this._loaded = true;
      }
    }
    return this._cache;
  }

  Future<T> get<T>(String path) async {
    if (!this._loaded) {
      await this.all();
    }
    return this.getValue<T>(path); //翻译getValue后再处理
  }

  Future<bool> set(String path, dynamic data) async {
    var kernel = KernelApi();
    var res = await kernel.objectSet(
      this._target.belongId!,
      this._relations,
      this.fullPath(path),
      data,
    );
    if (res.success) {
      if (this._cache == null) {
        this._cache = await this.get<T>('');
      }
      this.setValue(path, data);
    }
    return res.success;
  }

  Future<bool> delete(String path) async {
    var kernel = KernelApi();
    var res = await kernel.objectDelete(
      this._target.belongId!,
      this._relations,
      this._objName,
    );
    return res.success;
  }

  Future<bool> notity(
      dynamic data, bool ignoreSelf, String targetId, bool onlyTarget,
      [bool onlineOnly = true]) async {
    var kernel = KernelApi();
    DataNotityType req = DataNotityType(
        data: data,
        targetId: targetId,
        ignoreSelf: ignoreSelf,
        flag: this._objName,
        relations: this._relations,
        belongId: this._target.belongId!,
        onlyTarget: onlyTarget,
        onlineOnly: onlineOnly);
    var res = await kernel.dataNotify(req);
    return res.success;
  }

  void subscribe(dynamic data, {required String id}) {
    var kernel = KernelApi();
    kernel.on(
      '${this._target.belongId}-${id != null || this._target.id != null}-${this._objName}',
      Function.apply(this.callback, [], null),
    );
  }

  void setValue(String path, dynamic data) {
    if (this._cache != null) {
      if (path == '') {
        return this.cache();
      }
      var paths = path.split('.');
      var prop = paths[0];
      paths.removeAt(0);
      var value = this.cache();
      while (value != null && (prop != '' && (prop != ''))) {
        value = value[prop];
        if (paths.isEmpty) {
          value[prop] = data;
        }
      }
    }
  }

  dynamic getValue<T>(String path) {
    if (path == '') return cache();
    var paths = path.split('.');
    paths.add("");
    var prop = paths[0];
    paths.removeAt(0);
    var value = this.cache();
    while (prop != '' && value != null) {
      value = value[prop];
      if (paths != []) {
        var first = paths[0];
        paths.removeAt(0);
        prop = first;
      } else {
        prop = '';
      }
    }
    return value;
  }

  dynamic callback(dynamic data) {
    return data;
  }

  _objectCallback(String flag,dynamic data,Map<String,dynamic> res){
    res = {
      'flag':flag,
      'data':data,
    }; 
    var methods = _method[res['flag']];
    List<dynamic> resdata = [];
    resdata.addAll(_method[res['data']]);
    if(methods != {}){
      try{
        methods.forEach((m)=>Function.apply(null,));
      } catch(e) {
        printError();
      }
    }
  }
}
