import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:signalr_netcore/utils.dart';

class XObject<T extends Xbase> {
  late bool _loaded;
  T? _cache;
  late String _objName;
  late XTarget _target;
  late List<String> _relations;
  XObject(XTarget target, String name, List<String> relations) {
    _loaded = false;
    _target = target;
    _relations = relations;
    _objName = name;
  }

  T? cache() {
    return this._cache;
  }

  String objNmae() {
    return this._objName;
  }

  String fullPath(String path) {
    if (path != '') {
      path = '.$path';
    } else {
      path = '';
    }
    return this._objName + path;
  }

  Future<T> all() async {
    var kernel = KernelApi();
    if (!this._loaded) {
      //根据KernalApi获取对象数据的方法修改
      const res = await kernel.ObjectGet<T>();
      if (res.success) {
        this._cache = res.data;
        this._loaded = true;
      }
    }
    return this._cache;
  }

  Future<T> get<R>(String path) async {
    if (!this._loaded) {
      await this.all();
    }
    return this.getValue<R>(path); //翻译getValue后再处理
  }

  Future<bool> set(String path, T data) async {
    var kernel = KernelApi();
    const res = await KernalApi.objectSet();
    if (res.success) {
      if (this._cache == null) {
        this._cache = await this.get<T>('');
      }
      this.setValue(path, data); //翻译完setValue后再同步
    }
    return res.success;
  }

  Future<bool> delete(String path) async {
    var kernel = KernelApi();
    const res = await kernel.objectDelete();
    return res.success;
  }

  Future<bool> notity(T data, bool ignoreSelf, String targetId, bool onlyTarget,
      [bool onlineOnly = true]) async {
    var kernel = KernelApi();
    const res = await kernel.dataNotify();
    return res.success;
  }

  void subscribe(void callback(T data), String id) {
    var kernel = KernelApi();
    kernel.on(
      '${this._target.belongId}-${id != null || this._target.id != null}-${this._objName}',
      (data) => {
        callback.apply(this, [data])
      },
    ); //不知道怎么翻译
  }

  void setValue(String path, T data) {
    if (this._cache != null) {
      if (path == '') {
        return cache();
      }
      var paths = path.split('.');
      var prop;
      var value;
      List<T> nullList = [];
      while (value = cache() && (prop = shift(paths) && prop)) {
        value = value[path] || nullList != null;
        if (paths.length == 0) {
          value[path] = data;
        }
      }
    }
  }

  void getValue<R>(String path) {
    if (path == '') return cache();
    var paths = path.split('.');
    var prop = shift(paths), value = this.cache;
    while (prop != 0 && value != null) {
      value = value[prop];
      prop = shift(paths);
    }
    return value;
  }

  shift(var a) {
    var b = a[0];
    a.removeAt(0);
    return b;
  }
}
