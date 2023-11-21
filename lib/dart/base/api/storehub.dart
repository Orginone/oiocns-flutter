import 'dart:convert';

import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/base/model.dart';
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
        if (_connection.state == HubConnectionState.Connected) {
          _isStarted = true;
        }
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

// 获取accessToken
  String get accessToken {
    return Storage().getString('accessToken');
  }

  // 设置accessToken
  set accessToken(String val) {
    Storage().setString('accessToken', val);
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

  /// 开始连接
  /// @returns {void} 无返回值
  Future<void> _starting() async {
    await _connection.start()?.then((_) {
      for (final callback in _connectedCallbacks) {
        callback();
      }
    }, onError: (err) {
      LogUtil.e("url: ${_connection.baseUrl}");
      if (_connection.state == HubConnectionState.Connected) {
        LogUtil.e("连接失败,连接状态为$_isStarted。长链接状态:${_connection.state}");
        _isStarted = true;
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
      ResultType res = ResultType.fromJson(resObj as Map<String, dynamic>);
      LogUtil.d('接口：${Constant.rest}/${methodName.toLowerCase()}');
      LogUtil.d('参数：${jsonEncode(args![0])}');
      return _success(res);
    } catch (e, s) {
      LogUtil.d('接口：${Constant.rest}/${methodName.toLowerCase()}');
      LogUtil.d('参数：${jsonEncode(args![0])}');
      LogUtil.e("invoke Error${e.toString()}${s.toString()}");
      return _error(e, s);
    }
    // final id = const Uuid().v1();
    // Object? res;
    // try {
    //   res = await _connection.invoke(methodName, args: args);
    //   if (res != null && (res is Map)) {
    //     // if (res['code'] != 200) {
    //     //   ToastUtils.showMsg(msg: "后端异常${res['code']}：${res['msg']}");
    //     // }
    //     if (res['code'] == 400 || res['code'] == 401) {
    //       LogUtil.e('连接被断开,请重新连接$res');
    //       await restart();
    //       res = await invoke(methodName, args: args, retry: !retry!);
    //     } else if (res['code'] == 401) {
    //       // ToastUtils.showMsg(msg: "登录已过期,请重新登录");
    //       LogUtil.e('登录已过期,请重新登录');
    //       await restart();
    //       res = await invoke(methodName, args: args, retry: !retry!);
    //       // settingCtrl.exitLogin(cleanUserLoginInfo: false);
    //     } else if (res['code'] == 500) {
    //       // ToastUtils.showMsg(msg: "后端异常${res['code']}：${res['msg']}");
    //       LogUtil.e("后端异常${res['code']}：${res['msg']}");
    //       // ToastUtils.showMsg(msg: "后端异常：${res['msg']}");
    //       // ToastUtils.showMsg(msg: 'error 500 长连接已断开,正在重试');
    //       // Log.info('anystore断开链接,正在重试');
    //       // String token = kernel.accessToken;
    //       // kernel.setToken = '';
    //       // kernel.setToken(token);
    //     }
    //   }
    //   // log.info("========== storeHub-invoke-start =============$id");
    //   // log.info("=====>$id url: ${_connection.baseUrl}");
    //   // log.info("=====>$id methodName: $methodName");
    //   // log.info("=====>$id args: ${toJson(args)}");
    //   // log.info("=====>$id res: ${toJson(res)}");
    //   // log.info("==========$id storeHub-invoke-end =============");
    //   return ResultType.fromJson(res as Map<String, dynamic>);
    // } catch (err) {
    //   LogUtil.e("==========$id storeHub-invoke-start =============");
    //   LogUtil.e("=====>$id url: ${_connection.baseUrl}");
    //   LogUtil.e("=====>$id methodName: $methodName");
    //   LogUtil.e("=====>$id args: ${toJson(args)}");
    //   LogUtil.e("=====>$id res: ${toJson(res)}");
    //   LogUtil.e("=====>$id err: $err");
    //   LogUtil.e("==========$id storeHub-invoke-end =============");
    //   ToastUtils.dismiss();
    //   return ResultType<T>.fromJson(
    //       {"code": 400, "msg": err.toString(), "success": false, "data": null});
    // }
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
      data: args.toJson(),
    );

    // if (res != null && res['code'] == 200) {
    return res;
    // }
    // return badRequest; //badRequest;
  }

  ResultType<dynamic> _success(ResultType<dynamic> res) {
    if (!res.success) {
      if (res.code == 401) {
        // 登录已过期处理
      } else if (res.msg != '' && !res.msg.contains('不在线')) {
        LogUtil.e('Http:操作失败,${res.msg}');
        ToastUtils.showMsg(msg: res.msg);
      }
    }
    return res;
  }

  ResultType<dynamic> _error(dynamic res, dynamic s) {
    var msg = '请求异常';
    if (null != res) {
      LogUtil.e('Http:===========================err');
      LogUtil.e('Http:$res');
      LogUtil.e('Http:$s');
      msg += ',$res';
      LogUtil.e('Http:$msg');
      return res;
    } else {
      return badRequest;
    }
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
  }
}
