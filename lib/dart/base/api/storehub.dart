import 'dart:convert';

import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/main.dart';
import 'package:orginone/utils/http_util.dart';
import 'package:orginone/utils/index.dart';
import 'package:orginone/utils/toast_utils.dart';
import 'package:orginone/components/widgets/loading_dialog.dart';
import 'package:signalr_netcore/signalr_client.dart';

/// 存储集线器
class StoreHub {
  // 超时重试时间
  final int _timeout;
  // 是否已经启动
  bool _isStarted = false;
  // http 请求客户端
  // axios实例
  final _http = HttpUtil();
  // signalr 连接
  final HubConnection _connection;
  // 连接成功回调
  List<Function> _connectedCallbacks = [];
  // 连接断开回调
  List<Function(Exception?)> _disconnectedCallbacks = [];
  // 日志
  final Logger log = Logger("StoreHub");

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
      _refreshIsStartedState();
      if (!isConnected && error != null) {
        for (final callback in _disconnectedCallbacks) {
          callback(error);
        }
        ToastUtils.showMsg(msg: "连接断开,${_timeout}ms后重试。${error.toString()}`");
        LogUtil.e("连接断开,${_timeout}ms后重试。${error.toString()}`");
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
      Future.delayed(const Duration(microseconds: 50), () {
        LoadingDialog.dismiss(Get.context!);
        _refreshIsStartedState();
      });
    });
  }

  /// 连接ID
  String get connectionId => _connection.connectionId ?? '';

  /// 是否处于连接着的状态
  /// @return {boolean} 状态
  bool get isConnected {
    return _isStarted && _connection.state == HubConnectionState.Connected;
  }

  void _refreshIsStartedState() {
    if (_connection.state == HubConnectionState.Connected) {
      _isStarted = true;
    } else {
      _isStarted = false;
    }
  }

// 获取accessToken
  String get accessToken {
    LogUtil.d('accessToken');
    LogUtil.d(Storage());
    return Storage.getString('accessToken');
  }

  // 设置accessToken
  set accessToken(String val) {
    Storage.setString('accessToken', val);
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
      await _connection.stop().then((_) {
        start();
      });
    } else if (_connection.state != HubConnectionState.Reconnecting) {
      start();
    }
  }

  /// 开始连接
  /// @returns {void} 无返回值
  Future<void> _starting() async {
    await _connection.start()?.then((_) {
      for (final callback in _connectedCallbacks) {
        callback();
      }
    }, onError: (err) {
      LogUtil.e("url: ${_connection.baseUrl}");
      _refreshIsStartedState();
      if (_connection.state == HubConnectionState.Connected) {
        LogUtil.e("连接失败,连接状态为$_isStarted。长链接状态:${_connection.state}");
      } else {
        LogUtil.e("连接失败,${_timeout}ms后重试。${err != null ? err.toString() : ''}");
        for (final callback in _disconnectedCallbacks) {
          callback(err);
        }
        Future.delayed(Duration(milliseconds: _timeout), () {
          restart();
        });
      }
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
    Object? resObj;
    try {
      if (isConnected) {
        resObj = await _connection.invoke(methodName, args: args);
      } else {
        resObj = await _restRequest(
          'post',
          '${Constant.rest}/${methodName.toLowerCase()}',
          args!.isNotEmpty ? args[0] : {},
        );
      }
      if (null != resObj) {
        ResultType res = ResultType.fromJson(resObj as Map<String, dynamic>);
        LogUtil.d('接口：${Constant.rest}/${methodName.toLowerCase()}');
        LogUtil.d('参数：${jsonEncode(args![0])}');

        if (res.success) {
          LogUtil.d(
              'StoreHub返回值=================Start============================');
          LogUtil.d(resObj);
          LogUtil.d(
              'StoreHub返回值=================End============================');
          return _success(res);
        } else {
          return _error(resObj);
        }
      }
      return _error(resObj);
    } catch (e, s) {
      try {
        LogUtil.d('接口：${Constant.rest}/${methodName.toLowerCase()}');
        LogUtil.d('StoreHub参数：${jsonEncode(args![0])}');
        LogUtil.e("invoke Error${e.toString()}${s.toString()}");
      } catch (e) {}
      return _error(resObj, e, s);
    }
  }

  /// Http请求服务端方法
  /// @param {string} methodName 方法名
  /// @param {any[]} args 参数
  /// @returns {Promise<ResultType>} 异步结果
  Future<dynamic> _restRequest(
    String method,
    String url,
    dynamic args,
  ) async {
    final res = await _http.post(
      url,
      data: args is String || args is Map ? args : args.toJson(),
    );

    // if (res != null && res['code'] == 200) {
    return res;
    // }
    // return badRequest; //badRequest;
  }

  ResultType<dynamic> _success(ResultType<dynamic> res) {
    return res;
  }

  ResultType<dynamic> _error([dynamic resObj, dynamic err, dynamic s]) {
    var msg = '请求异常';
    ResultType res = badRequest;
    try {
      if (null != resObj && resObj is Map) {
        res = ResultType.fromJson(resObj as Map<String, dynamic>);
        if (res.code == 401) {
          LogUtil.e('==========================================登录已过期处理');
          // 登录已过期处理
          _errorNoAuthLogout();
        } else if (res.msg != '' && !res.msg.contains('不在线')) {
          LogUtil.e('Http:操作失败,${res.msg}');
          // TODO 再实际业务端做提醒，不然刚进入app 有可能会出现很多异常弹框，体验很不好
          // ToastUtils.showMsg(msg: res.msg);
        }
      } else {
        LogUtil.e('Http:===========================err');
        LogUtil.e('Http:$res');
        LogUtil.e('Http:$s');
        msg += err ?? ',$res';
        LogUtil.e('Http:$msg');
        res.msg = msg;
      }
    } catch (e, s) {
      LogUtil.e('Http:$s');
    }
    ToastUtils.dismiss();
    return res;
  }

  Future<void> disconnect() async {
    _isStarted = false;
    _connection.stop();
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
        LogUtil.d('Http:err:${jsonObj.runtimeType}>$jsonObj');
        e.printError();
      }
    }
    return jsonStr;
  } // 退出并重新登录

  Future<void> _errorNoAuthLogout() async {
    settingCtrl.autoLogin();
  }
}
