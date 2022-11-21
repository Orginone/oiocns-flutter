import 'package:get/get.dart';

/// 抽象模块 Controller
abstract class AbstractController<T> extends GetxController {
  /// 映射全部数据
  List<UI> mappingAll<UI>(UI Function(T item) func);

  /// 映射单个数据
  UI mapping<UI>(int index, UI Function(T item) func);

  /// 列表搜索
  search(String value);

  /// 刷新
  onLoad();

  /// 更多数据
  loadMore();

  /// 删除其中一个
  removeAt(int index);

  /// 删除一个对象
  remove(T entity);

  /// 获取其中一个
  T get(int index);

  /// 添加一个
  add(T one);

  /// 添加多个
  addAll(List<T> more);

  /// 删除所有
  clear();

  /// 获取当前数量
  int getSize();
}

/// 基类实现
abstract class BaseController<T> extends AbstractController<T> {
  final RxList<T> _data = <T>[].obs;
  final int _defaultLimit = 20;

  get defaultLimit => _defaultLimit;

  @override
  List<UI> mappingAll<UI>(UI Function(T item) func) {
    return _data.map(func).toList();
  }

  @override
  UI mapping<UI>(int index, UI Function(T item) func) {
    return func(_data[index]);
  }

  @override
  onLoad() {
    _data.clear();
    loadMore();
  }

  @override
  removeAt(int index) {
    _data.removeAt(index);
  }

  @override
  add(T one) {
    _data.add(one);
  }

  @override
  addAll(List<T> more) {
    _data.addAll(more);
  }

  @override
  int getSize() {
    return _data.length;
  }

  @override
  clear() {
    _data.clear();
  }

  @override
  T get(int index) {
    return _data[index];
  }

  @override
  remove(T entity) {
    _data.remove(entity);
  }
}
