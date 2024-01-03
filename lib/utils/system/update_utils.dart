import 'dart:io';

import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/utils/http_util.dart';
import 'package:orginone/utils/index.dart';
import 'package:orginone/utils/toast_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppUpdate {
  factory AppUpdate() => _getInstance();

  static AppUpdate get instance => _getInstance();

  static AppUpdate? _instance;
  static UpdateModel? _updateModel;
  static PackageInfo? _packageInfo;
  static String donloadUrl =
      '${Constant.host}/orginone/kernel/load/horvypjb8gtorvyezuenfyge63ime2xi3lonizxo6rwowwx52urm6xug1ddn11hcl1wgi5uenbqha3uknbxgv5dinryha2s8u3sm6vx533omwpyk3ujo1sye53bnqygc5dl';
  static String jsonUrl =
      '${Constant.host}/orginone/kernel/load/fjiclzala8torvyezuenfyge63ime2xi3lonizxo6rwowwx52urm6xug1ddn11hcl1wgi5uenbqha3uknbxgv5dinryha2s86ufoj1xs33of1whg33o';
  AppUpdate._internal() {
    //内部初始化
    _init();
  }

  static AppUpdate _getInstance() {
    _instance ??= AppUpdate._internal();
    return _instance!;
  }

  void _init() async {
    _packageInfo = await PackageInfo.fromPlatform();
    _initXUpdate();
  }

  ///初始化
  static void _initXUpdate() {
    if (Platform.isAndroid) {
      FlutterXUpdate.init(

              ///是否输出日志
              debug: true,

              ///是否使用post请求
              isPost: true,

              ///post请求是否是上传json
              isPostJson: false,

              ///请求响应超时时间
              timeout: 25000,

              ///是否开启自动模式
              isWifiOnly: false,

              ///是否开启自动模式
              isAutoMode: false,

              ///需要设置的公共参数
              supportSilentInstall: false,

              ///在下载过程中，如果点击了取消的话，是否弹出切换下载方式的重试提示弹窗
              enableRetry: false)
          .then((value) {
        // print(value);
      }).catchError((error) {
        // print(error);
        ToastUtils.showMsg(msg: error.toString());
      });

      FlutterXUpdate.setErrorHandler(
          onUpdateError: (Map<String, dynamic>? message) async {
        // print(message);
        ToastUtils.showMsg(msg: message.toString());
      });

      FlutterXUpdate.setUpdateHandler(
          onUpdateError: (Map<String, dynamic>? message) async {
        if (message?["code"] != 2004) {
          //已经是最新版本
          ToastUtils.showMsg(msg: message.toString());
        }
        //下载失败
        if (message?["code"] == 4000) {
          FlutterXUpdate.showRetryUpdateTipDialog(
              retryContent: '下载失败是否重新下载？', retryUrl: donloadUrl);
        }
      }, onUpdateParse: (String? json) async {
        //这里是自定义json解析
        return updateEntity();
      });
    } else {}
  }

  ///将自定义的json内容解析为UpdateEntity实体类
  static Future<UpdateEntity> updateEntity() async {
    // print(packageInfo.packageName); // app包名，如：com.ppw.ppw_app.dev
    // print(packageInfo.appName); // app名称，如：豪波公物仓
    // print(packageInfo.version); // 版本号，如：1.6.2-dev
    // print(packageInfo.buildNumber); // 构建号，如：1
    // String url = 'http://183.134.111.2:9090/apk/ppw/version.json';

    return UpdateEntity(
      hasUpdate: _updateModel?.update,
      isForce: _updateModel?.force,
      versionCode: int.parse(_packageInfo!.buildNumber),
      versionName: _updateModel?.version,
      updateContent: _updateModel?.content,
      downloadUrl: _updateModel!.url.isEmpty ? donloadUrl : _updateModel?.url,
      // apkSize: 19332,
      // apkMd5: "E4B79A36EFB9F17DF7E3BB161F9BCFD8"
    );
  }

  // ///默认App更新
  // static void checkUpdateDefault() {
  //   FlutterXUpdate.checkUpdate(url: jsonUrl);
  // }

  // ///默认App更新 + 支持后台更新
  // static void checkUpdateSupportBackground() {
  //   FlutterXUpdate.checkUpdate(url: jsonUrl, supportBackgroundUpdate: true);
  // }

  // ///调整宽高比
  // static void checkUpdateRatio() {
  //   FlutterXUpdate.checkUpdate(url: jsonUrl, widthRatio: 0.6);
  // }

  // ///强制更新
  // static void checkUpdateForce() {
  //   FlutterXUpdate.checkUpdate(url: jsonUrl);
  // }

  // ///自动模式, 如果需要完全无人干预，自动更新，需要root权限【静默安装需要】
  // static void checkUpdateAutoMode() {
  //   FlutterXUpdate.checkUpdate(url: jsonUrl, isAutoMode: true);
  // }

  // ///下载时点击取消允许切换下载方式
  // static void enableChangeDownLoadType() {
  //   FlutterXUpdate.checkUpdate(
  //       url: jsonUrl,
  //       overrideGlobalRetryStrategy: true,
  //       enableRetry: true,
  //       retryContent: "下载失败，是否重试？",
  //       retryUrl: donloadUrl);
  // }

  // ///显示重试提示弹窗
  // static void showRetryDialogTip() {
  //   FlutterXUpdate.showRetryUpdateTipDialog(
  //       retryContent: "下载失败，是否重试？", retryUrl: donloadUrl);
  // }

  // ///直接传入UpdateEntity进行更新提示
  // static void checkUpdateByUpdateEntity() async {
  //   FlutterXUpdate.updateByInfo(updateEntity: await customParseJson());
  // }

  // ///自定义更新弹窗样式
  // static void customPromptDialog() {
  //   FlutterXUpdate.checkUpdate(
  //       url: jsonUrl,
  //       themeColor: '#FFFFAC5D',
  //       topImageRes: 'bg_update_top',
  //       buttonTextColor: '#FFFFFFFF');
  // }
  ///使用自定义json解析
  void _customJsonParse() {
    FlutterXUpdate.checkUpdate(
      url: jsonUrl,
      isCustomParse: true,
      themeColor: "#ffff6634",
      // topImageRes: 'bg_update_top',
      buttonTextColor: '#FFFFFFFF',
    );
  }

  Future<bool> update() async {
    bool update = await checkUpdate();
    _updateModel?.update = update;
    if (update) {
      _customJsonParse();
    }
    return update;
  }

  String getLocalVersion() {
    return _packageInfo?.version ?? '1.0.0';
  }

/*
 * 检查更新
 * */
  static Future<bool> checkUpdate() async {
    final remoteData = await HttpUtil().post(jsonUrl);

    LogUtil.d('update');
    LogUtil.d(remoteData);
    if (remoteData['status'] != 2000) return false;
    _updateModel = UpdateModel.fromJson((remoteData['data']));

    ///remoteVersion 服务器版本号
    String remoteVersion = _updateModel?.version ?? '1.0.0';

    ///locVersion 本地版本号
    String locVersion = _packageInfo?.version ?? '1.0.0';

    if (remoteVersion.isEmpty || locVersion.isEmpty) return false;
    int newVersionInt, oldVersion;
    var newList = remoteVersion.split('.');
    var oldList = locVersion.split('.');
    if (newList.isEmpty || oldList.isEmpty) {
      return false;
    }
    for (int i = 0; i < newList.length; i++) {
      newVersionInt = int.parse(newList[i]);
      oldVersion = int.parse(oldList[i]);
      if (newVersionInt > oldVersion) {
        return true;
      } else if (newVersionInt < oldVersion) {
        return false;
      }
    }
    return false;
  }
}

class UpdateModel {
  String? title;
  String? content;
  String url;
  String version;
  bool? force;
  bool? update;

  UpdateModel({
    this.title,
    this.content,
    required this.url,
    required this.version,
    this.force,
    this.update,
  });

  factory UpdateModel.fromJson(Map<String, dynamic> json) => UpdateModel(
        title: json['title'] == null ? null : json['title'] as String,
        content: json['content'] == null ? null : json['content'] as String,
        url: json['url'] as String,
        version: json['version'] as String,
        force: json['force'] == null ? false : json['force'] as bool,
        update: json['update'] == null ? false : json['update'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'url': url,
        'version': version,
        'force': force,
        'update': update,
      };
}
