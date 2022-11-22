import 'package:get/get.dart';

/// 基类实现
abstract class BaseController<T> extends GetxController {
  final RxList<T> _data = <T>[].obs;
  final int _defaultLimit = 15;

  get defaultLimit => _defaultLimit;

  loadMore();

  search(String value);

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
