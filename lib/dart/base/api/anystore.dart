import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/base/api/storehub.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:uuid/uuid.dart';

class AnyStore {
  final Logger log = Logger("AnyStore");
  final StoreHub _storeHub;
  String accessToken;
  final Map<String, Function(dynamic)> _subscribeCallbacks = {};

  static AnyStore? _instance;

  factory AnyStore(){
    _instance ??= AnyStore._();
    return _instance!;
  }

  AnyStore._()
      : accessToken = "",
        _storeHub = StoreHub(Constant.anyStoreHub){
    _storeHub.on("updated", (args) => _updated(args![0], args[1], args[2]));
    _storeHub.onConnected(() {
      if (accessToken.isNotEmpty) {
        _storeHub.invoke("TokenAuth", args: [accessToken]).then(
            (value) => _subscribeCallbacks.forEach((fullKey, value) {
                  var key = fullKey.split("|")[0];
                  var belongId = fullKey.split("|")[1];
                  subscribed(key, belongId, value);
                }));
      }
    });
    _storeHub.start();
  }

  stop() async {
    _subscribeCallbacks.clear();
    await _storeHub.dispose();
    _instance = null;
  }

  void start() {
    _storeHub.start();
  }

  /// 是否在线
  /// @returns {boolean} 在线状态
  bool get isOnline {
    return _storeHub.isConnected;
  }


  void restart(){
    _storeHub.restart();
  }

  /// 更新token
  /// @param accessToken token
  updateToken(String accessToken) {
    if (this.accessToken != accessToken) {
      this.accessToken = accessToken;
      _storeHub.restart();
    }
  }

  /// 订阅对象变更
  /// @param {string} key 对象名称（eg: rootName.person.name）
  /// @param {string} belongId 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @param {(data:any)=>void} callback 变更回调，默认回调一次
  /// @returns {void} 无返回值
  subscribed(String key, String belongId, Function(dynamic)? callback) async {
    if (callback != null) {
      final fullKey = "$key|$belongId";
      _subscribeCallbacks[fullKey] = callback;
      if (_storeHub.isConnected) {
        var raw = await _storeHub.invoke('Subscribed', args: [belongId, key]);
        var res = ResultType.fromJson(raw);
        if (res.success && res.data != null) {
          callback(res.data);
        }
      }
    }
  }

  /// 取消订阅对象变更
  /// @param {string} key 对象名称（eg: rootName.person.name）
  /// @param {string} belongId 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {void} 无返回值
  unSubscribed(String key, String belongId) async {
    final fullKey = "$key|$belongId";
    if (_subscribeCallbacks.containsKey(fullKey) && _storeHub.isConnected) {
      await _storeHub.invoke('UnSubscribed', args: [key, belongId]);
      _subscribeCallbacks.remove(fullKey);
    }
  }

  /// 从数据集查询数据
  /// @param {string} key 对象名称（eg: rootName.person.name）
  /// @param {string} belongId 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 对象异步结果
  Future<List<XWorkTask>> pageRequest(String key, String belongId,Map<String,dynamic> options,PageRequest page) async {
    List<XWorkTask> task = [];
    var raw = await aggregate(key,options,belongId);
    if(raw.data!=null && raw.data[0]['count']>0){
      options['skip'] = page.offset;
      options['limit'] = page.limit;
      var res = await aggregate(key,options,belongId);
      if(res.data!=null){
        res.data.forEach((json){
          task.add(XWorkTask.fromJson(json));
        });
      }
      return task;
    }
    return task;
  }

  /// 查询对象
  /// @param {string} key 对象名称（eg: rootName.person.name）
  /// @param {string} belongId 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 对象异步结果
  Future<ResultType<dynamic>> get(String key, String belongId) async {
    var raw = await _storeHub.invoke('Get', args: [belongId, key]);
    return ResultType.fromJson(raw);
  }

  /// 修改对象
  /// @param {string} key 对象名称（eg: rootName.person.name）
  /// @param {any} setData 对象新的值
  /// @param {string} belongId 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 变更异步结果
  Future<ResultType<dynamic>> set(
      String key, dynamic setData, String belongId) async {
    var raw = await _storeHub.invoke('Set', args: [belongId, key, setData]);
    return ResultType.fromJson(raw);
  }

  /// 删除对象
  /// @param {string} key 对象名称（eg: rootName.person.name）
  /// @param {string} belongId 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 删除异步结果
  Future<ResultType<dynamic>> delete(String key, String belongId) async {
    var raw = await _storeHub.invoke('Delete', args: [belongId,key]);
    return ResultType.fromJson(raw);
  }

  /// 添加数据到数据集
  /// @param {string} collName 数据集名称（eg: history-message）
  /// @param {any} data 要添加的数据，对象/数组
  /// @param {string} belongId 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 添加异步结果
  Future<ResultType<dynamic>> insert(
      String collName, dynamic data, String belongId) async {
    var raw =
    await _storeHub.invoke('Insert', args: [belongId, collName, data]);
    return ResultType.fromJson(raw);
  }

  /// 更新数据到数据集
  /// @param {string} collName 数据集名称（eg: history-message）
  /// @param {any} update 更新操作（match匹配，update变更,options参数）
  /// @param {string} belongId 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 更新异步结果
  Future<ResultType<dynamic>> update(
      String collName, dynamic update, String belongId) async {
    var raw =
    await _storeHub.invoke('Update', args: [belongId, collName, update]);
    return ResultType.fromJson(raw);
  }

  /// 从数据集移除数据
  /// @param {string} collName 数据集名称（eg: history-message）
  /// @param {any} match 匹配信息
  /// @param {string} belongId 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 移除异步结果
  Future<ResultType<dynamic>> remove(
      String collName, dynamic match, String belongId) async {
    var raw =
    await _storeHub.invoke('Remove', args: [belongId, collName, match]);
    return ResultType.fromJson(raw);
  }

  /// 从数据集查询数据
  /// @param {string} collName 数据集名称（eg: history-message）
  /// @param {any} options 聚合管道(eg: {match:{a:1},skip:10,limit:10})
  /// @param {string} belongId 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 移除异步结果
  Future<ResultType<dynamic>> aggregate(
      String collName, dynamic options, String belongId) async {
    var raw = await _storeHub
        .invoke('Aggregate', args: [belongId, collName, options]);
    return ResultType.fromJson(raw);
  }

  /// 桶操作
  /// @param data 操作携带的数据
  /// @returns {ResultType<T>} 移除异步结果
  Future<ResultType<T>> bucketOpreate<T>(String belongId,BucketOpreateModel data) async {
    var raw = await _storeHub.invoke('BucketOpreate', args: [belongId,data.toJson()]);
    return ResultType<T>.fromJson(raw);
  }


  Future<FileItemModel?> fileUpdate(String belongId, File file, String key,
      {void Function(double)? progress}) async {
    final uuid = const Uuid().v1();
    final data = BucketOpreateModel(
      key: base64.encode(utf8.encode(key)),
      operate: BucketOpreates.upload,
    );
    progress?.call(0);
    int index = 0;
    int chunkSize = 1024 * 1024;
    int fileLength = file.lengthSync();
    while (index * chunkSize < fileLength.floorToDouble()) {
      var start = index * chunkSize;
      var end = start + chunkSize;
      if (end > fileLength.floorToDouble()) {
        end = fileLength;
      }
      List<int> bytes = file.readAsBytesSync();
      bytes = bytes.sublist(start, end);
      String url = base64.encode(bytes);
      data.fileItem = FileChunkData(
        index: index,
        uploadId: uuid,
        size: fileLength,
        data: [],
        dataUrl: url,
      );
      var res = await bucketOpreate(belongId, data);
      if (!res.success) {
        data.operate = BucketOpreates.abortUpload;
        await bucketOpreate(belongId, data);
        progress?.call(-1);
        return null;
      }
      index++;
      progress?.call(end / fileLength);
      if (end == fileLength && res.data != null) {
        var node = FileItemModel.fromJson(res.data);
        return node;
      }
    }
    return null;
  }

  /// 加载物
  /// @param  过滤参数
  /// @returns {ResultType<T>} 移除异步结果
  Future<ResultType<dynamic>> loadThing<T>(
      dynamic options, String belongId) async {
    var raw = await _storeHub.invoke('Load', args: [belongId, options]);
    return ResultType.fromJson(raw);
  }

  ///
  /// 加载物的归档信息
  /// @param  过滤参数
  /// * @returns {ResultType<T>} 移除异步结果
  Future<ResultType<dynamic>> loadThingArchives<T>(
    Map<String, dynamic> options,
    String belongId,
  ) async {
    var raw =
    await _storeHub.invoke('LoadArchives', args: [belongId, options]);
    return ResultType.fromJson(raw);
  }

  /// 创建物
  /// @param  创建数量
  /// @returns {ResultType<T>} 移除异步结果
  Future<ResultType<T>> createThing<T>(
    int number,
    String belongId,
  ) async {
    var raw = await _storeHub.invoke('Create', args: [belongId, number]);
    return ResultType.fromJson(raw);
  }

  /// 对象变更通知
  /// @param belongId 归属
  /// @param key 主键
  /// @param data 数据
  /// @returns {void} 无返回值
  _updated(String belongId, String key, dynamic data) {
    final fullKey = "$key|$belongId";
    if (_subscribeCallbacks.containsKey(fullKey)) {
      final Function(dynamic)? callback = _subscribeCallbacks[fullKey];
      if (callback != null) {
        callback(data);
      }
    }
  }


}
