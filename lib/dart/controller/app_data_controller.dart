import 'package:connectivity/connectivity.dart';
import 'package:orginone/dart/base/common/emitter.dart';
import 'package:orginone/main_base.dart';

///app网络状态（手机网络，内核长链接状态）
class AppDataController extends Emitter {
  ///app网络状态
  late ConnectivityResult _result;

  ///手机生命周期状态
  late String _appLifecycleState;
  AppDataController() {
    _result = ConnectivityResult.wifi;
    _appLifecycleState = "";
    subscribe((key, args) {
      relationCtrl.isConnected.value = isNetworkConnected;
    }, false);
    // kernel.onConnectedChanged((isConnected) {
    //   if (!isConnected) {
    //   } else {
    //   }
    // });
  }

  /// 设置手机网络状态
  set connectivityResult(ConnectivityResult result) {
    if (_result == ConnectivityResult.none &&
        result != ConnectivityResult.none) {
      // relationCtrl.wakeUp();
      refreshData();
    }
    _result = result;
    changCallback();
  }

  /// 设置手机生命周期状态
  /// resumed APP的状态从paused切换到resumed进入前台状态
  /// paused 应用挂起，比如退到后台
  /// inactive 界面退到后台或弹出对话框情况下
  /// suspending iOS中没有该状态，安卓里就是挂起
  set appLifecycleState(String state) {
    if (state == 'AppLifecycleState.resumed') {
      refreshData();
    }
    _appLifecycleState = state;
  }

  Future<void> refreshData() async {
    if (!isNetworkConnected) return;

    if (kernel.user == null) {
      await relationCtrl.autoLogin();
    } else if (!kernel.isOnline) {
      if (!relationCtrl.provider.inited) {
        relationCtrl.autoLogin();
      } else {
        relationCtrl.wakeUp();
      }
    } else {
      relationCtrl.wakeUp();
      relationCtrl.isConnected.value = true;
    }
  }

  // 判断网络连接
  bool get isNetworkConnected {
    return _result == ConnectivityResult.wifi ||
        _result == ConnectivityResult.mobile;
  }
}
// if (msg == 'AppLifecycleState.resumed') {
//   if (kernel.user == null) {
//     LogUtil.d('>>>>>>======resumed 1');
//     await relationCtrl.autoLogin();
//   } else if (!kernel.isOnline) {
//     if (!relationCtrl.provider.inited) {
//       LogUtil.d('>>>>>>======resumed 2');
//       relationCtrl.autoLogin();
//     } else {
//       LogUtil.d('>>>>>>======resumed 3');
//       relationCtrl.wakeUp();
//     }
//   } else {
//     LogUtil.d('>>>>>>======resumed 4');
//     relationCtrl.isConnected.value = true;
//   }
// }
