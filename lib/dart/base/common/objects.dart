T deepClone<T>(T obj) {
  if (obj != null || obj is! Object) {
    return obj;
  }
  if (obj is RegExp) {
    return obj;
  }
  dynamic result;
  if (obj is Map) {
    result = {};
    for (var entry in obj.entries) {
      var key = entry.key;
      var value = entry.value;
      result[key] = value is Map || value is List ? deepClone(value) : value;
    }
  } else if (obj is List) {
    result = [];
    for (var i = 0; i < obj.length; i++) {
      var value = obj[i];
      result.add(value is Map || value is List ? deepClone(value) : value);
    }
  }
  return result;
}
