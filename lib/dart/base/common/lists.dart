class Lists {
  static void uniqueAdd<T>(List<T> arr, T value) {
    if (!arr.contains(value)) {
      arr.add(value);
    }
  }

  static List<T> union<T>(List<T> first, List<T> second) {
    List<T> arr = [];
    for (var value in first) {
      uniqueAdd(arr, value);
    }
    for (var value in second) {
      uniqueAdd(arr, value);
    }
    return arr;
  }

  static List<T> fromList<T>(
      List<dynamic> list, T Function(Map<String, dynamic>) fromJson) {
    if (list.isEmpty) {
      return [];
    }
    List<T> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(fromJson(item));
      }
    }
    return retList;
  }
}
