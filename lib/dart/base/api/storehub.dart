import 'dart:convert';

import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/utils/toast_utils.dart';
import 'package:orginone/components/widgets/loading_dialog.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:uuid/uuid.dart';

/// 存储集线器
class StoreHub {
  // 超时重试时间
  final int _timeout;
  // 是否已经启动
  bool _isStarted = false;
  // signalr 连接
  final HubConnection _connection;
  // 连接成功回调
  List<Function> _connectedCallbacks = [];
  // 连接断开回调
  List<Function(Exception?)> _disconnectedCallbacks = [];
  // 日志
  final Logger log = Logger("StoreHub");

  /// 连接ID
  String get connectionId => _connection.connectionId ?? '';

  StoreHub(
    String url, {
    protocol = 'json',
    int timeout = 8000,
    int interval = 3000,
  })  : _timeout = timeout,
        _connection = HubConnectionBuilder()
            .withUrl(url, options: HttpConnectionOptions())
            .withAutomaticReconnect(
                retryDelays: List.generate(1000, (index) => 2000))
            .build() {
    _connection.keepAliveIntervalInMilliseconds = interval;
    _connection.serverTimeoutInMilliseconds = timeout;
    _connection.onclose(({error}) {
      if (!isConnected && error != null) {
        for (final callback in _disconnectedCallbacks) {
          callback(error);
        }
        ToastUtils.showMsg(msg: "连接断开,${_timeout}ms后重试。${error.toString()}`");
        log.warning("连接断开,${_timeout}ms后重试。${error.toString()}`");
        Future.delayed(Duration(milliseconds: _timeout), () {
          _starting();
        });
      }
    });
    _connection.onreconnecting(({error}) {
      LoadingDialog.showLoading(Get.context!,
          msg: "正在重新连接服务器", dismissSeconds: -1);
    });
    _connection.onreconnected(({connectionId}) {
      // kernel.restart();
      Future.delayed(const Duration(microseconds: 500), () {
        LoadingDialog.dismiss(Get.context!);
        if (_connection.state == HubConnectionState.Connected) {
          _isStarted = true;
        }
      });
    });
  }

  /// 是否处于连接着的状态
  /// @return {boolean} 状态
  bool get isConnected {
    return _isStarted && _connection.state == HubConnectionState.Connected;
  }

  ///连接状态

  HubConnectionState? connectionState() {
    return _connection.state;
  }

  /// 销毁连接
  /// @returns {Promise<void>} 异步Promise ts内核
  /// 异步 Future
  Future<void> dispose() async {
    _isStarted = false;
    _connectedCallbacks = [];
    _disconnectedCallbacks = [];
    return await _connection.stop();
  }

  /// 启动链接
  /// @returns {void} 无返回值
  void start() {
    if (!_isStarted) {
      _isStarted = true;
      if (!isConnected) {
        _starting();
      }
    }
  }

  /// 重新建立连接
  /// @returns {void} 无返回值
  Future<void> restart() async {
    if (isConnected) {
      _isStarted = false;
      _connection.stop();
      await _connection.stop().then((_) {
        _starting();
      });
    } else if (_connection.state != HubConnectionState.Reconnecting) {
      _starting();
    }
  }

  Future<void> disconnect() async {
    _isStarted = false;
    _connection.stop();
  }

  /// 开始连接
  /// @returns {void} 无返回值
  Future<void> _starting() async {
    await _connection.start()?.then((_) {
      for (final callback in _connectedCallbacks) {
        callback();
      }
    }, onError: (err) {
      log.warning("url: ${_connection.baseUrl}");
      log.warning("连接失败,${_timeout}ms后重试。${err != null ? err.toString() : ''}");
      for (final callback in _disconnectedCallbacks) {
        callback(err);
      }
      Future.delayed(Duration(milliseconds: _timeout), () {
        restart();
      });
    });
  }

  /// 连接成功事件
  /// @param {Function} callback 回调
  /// @returns {void} 无返回值
  void onConnected(Function? callback) {
    if (callback != null) {
      _connectedCallbacks.add(callback);
    }
  }

  /// 断开连接事件
  /// @param {Function} callback 回调
  /// @returns {void} 无返回值
  void onDisconnected(Function(Exception?)? callback) {
    if (callback != null) {
      _disconnectedCallbacks.add(callback);
    }
  }

  /// 监听服务端方法
  /// @param {string} methodName 方法名
  /// @param {Function} newMethod 回调
  /// @returns {void} 无返回值
  void on(String methodName, void Function(List<dynamic>?) newMethod) {
    _connection.on(methodName, newMethod);
  }

  /// 请求服务端方法
  /// @param {string} methodName 方法名
  /// @param {any[]} args 参数
  /// @returns {Promise<ResultType>} 异步结果
  Future<ResultType> invoke<T>(String methodName,
      {List<Object>? args, bool? retry = false}) async {
    final id = const Uuid().v1();
    Object? res;
    try {
      res = await _connection.invoke(methodName, args: args);
      if (res != null && (res is Map)) {
        // if (res['code'] != 200) {
        //   ToastUtils.showMsg(msg: "后端异常${res['code']}：${res['msg']}");
        // }
        if (res['code'] == 401) {
          ToastUtils.showMsg(msg: "登录已过期,请重新登录");
          await restart();
          res = await invoke(methodName, args: args, retry: !retry!);
          // settingCtrl.exitLogin(cleanUserLoginInfo: false);
        } else if (res['code'] == 500) {
          ToastUtils.showMsg(msg: "后端异常${res['code']}：${res['msg']}");
          // ToastUtils.showMsg(msg: "后端异常：${res['msg']}");
          // ToastUtils.showMsg(msg: 'error 500 长连接已断开,正在重试');
          // Log.info('anystore断开链接,正在重试');
          // String token = kernel.accessToken;
          // kernel.setToken = '';
          // kernel.setToken(token);
        }
      }
      // log.info("========== storeHub-invoke-start =============$id");
      // log.info("=====>$id url: ${_connection.baseUrl}");
      // log.info("=====>$id methodName: $methodName");
      // log.info("=====>$id args: ${toJson(args)}");
      // log.info("=====>$id res: ${toJson(res)}");
      // log.info("==========$id storeHub-invoke-end =============");
      print(toJson(res));
      return ResultType.fromJson(res as Map<String, dynamic>);
    } catch (err) {
      log.warning("==========$id storeHub-invoke-start =============");
      log.warning("=====>$id url: ${_connection.baseUrl}");
      log.warning("=====>$id methodName: $methodName");
      log.warning("=====>$id args: ${toJson(args)}");
      log.warning("=====>$id res: ${toJson(res)}");
      log.warning("=====>$id err: $err");
      log.warning("==========$id storeHub-invoke-end =============");
      ToastUtils.dismiss();
      return ResultType<T>.fromJson(
          {"code": 400, "msg": err.toString(), "success": false, "data": null});
    }
  }

  String toJson(dynamic jsonObj) {
    String jsonStr = "";

    if (null == jsonObj) {
      return "";
    } else if (jsonObj is List) {
      jsonStr = "[";
      for (var element in jsonObj) {
        jsonStr += toJson(element);
      }
      jsonStr += "]";
    } else if (jsonObj is Map<String, dynamic> || jsonObj is Map) {
      jsonStr += jsonObj.toString();
    } else if (jsonObj is String) {
      jsonStr = jsonObj;
    } else {
      try {
        jsonStr = jsonEncode(jsonObj);
      } catch (e) {
        print('>>>>>>>>>>>err:${jsonObj.runtimeType}>$jsonObj');
        e.printError();
      }
    }
    return jsonStr;
  }
}
