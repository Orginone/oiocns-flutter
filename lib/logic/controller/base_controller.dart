abstract class BaseListController<T> {
  /// 列表搜索
  search(String value) {
    throw Exception("未实现的方法!");
  }

  /// 更多数据
  loadMore() {
    throw Exception("未实现的方法!");
  }

  /// 刷新
  refresh() {
    throw Exception("未实现的方法!");
  }

  /// 删除其中一个
  removeAt(int index) {
    throw Exception("未实现的方法!");
  }

  /// 添加一个
  add(T one) {
    throw Exception("未实现的方法!");
  }
}
