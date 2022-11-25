import 'package:get/get.dart';

/// 基类实现
class BaseController<T> extends GetxController {
  final RxList<T> _data = <T>[].obs;
  final int _defaultLimit = 15;

  get defaultLimit => _defaultLimit;

  loadMore() {
    throw UnimplementedError();
  }

  search(String value) {
    throw UnimplementedError();
  }

  forEach(bool Function(T) func) {
    for (var value in _data) {
      bool isContinue = func(value);
      if (!isContinue) break;
    }
  }

  List<UI> mappingAll<UI>(UI Function(T item) func) {
    return _data.map(func).toList();
  }

  UI mapping<UI>(int index, UI Function(T item) func) {
    return func(_data[index]);
  }

  onLoad() {
    _data.clear();
    loadMore();
  }

  removeAt(int index) {
    _data.removeAt(index);
  }

  removeWhere(bool Function(T item) filter) {
    _data.removeWhere(filter);
  }

  List<T> find(bool Function(T item) filter) {
    return _data.where(filter).toList();
  }

  T findOne(bool Function(T item) filter) {
    return _data.firstWhere(filter);
  }

  add(T one) {
    _data.add(one);
  }

  addAll(List<T> more) {
    _data.addAll(more);
  }

  int getSize() {
    return _data.length;
  }

  clear() {
    _data.clear();
  }

  T get(int index) {
    return _data[index];
  }

  remove(T entity) {
    _data.remove(entity);
  }
}
