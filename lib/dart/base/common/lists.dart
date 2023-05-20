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


}
