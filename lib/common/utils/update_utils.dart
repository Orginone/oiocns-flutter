import 'dart:io';

import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/common/models/update_model.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UpdateUtils {
  factory UpdateUtils() => _getInstance();

  static UpdateUtils get instance => _getInstance();

  static UpdateUtils? _instance;

  UpdateUtils._internal() {
    //内部初始化
    _init();
  }

  static UpdateUtils _getInstance() {
    _instance ??= UpdateUtils._internal();
    return _instance!;
  }

  void _init() {
    _initXUpdate();
  }

  ///初始化
  static void _initXUpdate() {
    if (Platform.isAndroid) {
      FlutterXUpdate.init(

              ///是否输出日志
              debug: true,

              ///是否使用post请求
              isPost: false,

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
      });

      FlutterXUpdate.setErrorHandler(
          onUpdateError: (Map<String, dynamic>? message) async {
        Loading.error(message.toString());
      });

      FlutterXUpdate.setUpdateHandler(
          onUpdateError: (Map<String, dynamic>? message) async {
        if (message?["code"] != 2004) {
          //已经是最新版本
          Loading.toast(message.toString());
        }

        //下载失败
        if (message?["code"] == 4000) {
          FlutterXUpdate.showRetryUpdateTipDialog(
              retryContent: '下载失败是否重新下载？', retryUrl: donloadUrl);
        }
      }, onUpdateParse: (String? json) async {
        //这里是自定义json解析
        return customParseJson();
      });
    } else {}
  }

  static String donloadUrl =
      ''; //= '${EnvConfig.baseHost}/apks/archive/archive.apk';
  static String jsonUrl =
      ''; // = '${EnvConfig.baseHost}${API.update_ota_json}';

  ///将自定义的json内容解析为UpdateEntity实体类
  static Future<UpdateEntity> customParseJson() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // print(packageInfo.packageName); // app包名，如：com.ppw.ppw_app.dev
    // print(packageInfo.appName); // app名称，如：豪波公物仓
    // print(packageInfo.version); // 版本号，如：1.6.2-dev
    // print(packageInfo.buildNumber); // 构建号，如：1
    // String url = 'http://183.134.111.2:9090/apk/ppw/version.json';

    UpdateModel updateModel = UpdateModel(
      force: true,
      version: '',
    ); //= await UserApi.update();
    String locVersion = packageInfo.version;

    int remote = int.tryParse(
        updateModel.version.replaceAll('.', '').replaceAll('V', ''))!;
    int loc = int.tryParse(locVersion.replaceAll('.', ''))!;

    return UpdateEntity(
      hasUpdate: remote > loc,
      isForce: updateModel.force,
      versionCode: int.parse(packageInfo.buildNumber),
      versionName: updateModel.version,
      updateContent: updateModel.content,
      downloadUrl: donloadUrl,
      apkSize: 24822,
      // apkMd5: "E4B79A36EFB9F17DF7E3BB161F9BCFD8"
    );
  }

  ///默认App更新
  static void checkUpdateDefault() {
    FlutterXUpdate.checkUpdate(url: jsonUrl);
  }

  ///默认App更新 + 支持后台更新
  static void checkUpdateSupportBackground() {
    FlutterXUpdate.checkUpdate(url: jsonUrl, supportBackgroundUpdate: true);
  }

  ///调整宽高比
  static void checkUpdateRatio() {
    FlutterXUpdate.checkUpdate(url: jsonUrl, widthRatio: 0.6);
  }

  ///强制更新
  static void checkUpdateForce() {
    FlutterXUpdate.checkUpdate(url: jsonUrl);
  }

  ///自动模式, 如果需要完全无人干预，自动更新，需要root权限【静默安装需要】
  static void checkUpdateAutoMode() {
    FlutterXUpdate.checkUpdate(url: jsonUrl, isAutoMode: true);
  }

  ///下载时点击取消允许切换下载方式
  static void enableChangeDownLoadType() {
    FlutterXUpdate.checkUpdate(
        url: jsonUrl,
        overrideGlobalRetryStrategy: true,
        enableRetry: true,
        retryContent: "下载失败，是否重试？",
        retryUrl: donloadUrl);
  }

  ///显示重试提示弹窗
  static void showRetryDialogTip() {
    FlutterXUpdate.showRetryUpdateTipDialog(
        retryContent: "下载失败，是否重试？", retryUrl: donloadUrl);
  }

  ///使用自定义json解析
  void customJsonParse() {
    FlutterXUpdate.checkUpdate(
      url: jsonUrl,
      isCustomParse: true,
      // themeColor: "#ff29a9ee",
      // topImageRes: 'bg_update_top',
      buttonTextColor: '#ffffff',
      widthRatio: 0.8,
    );
  }

  ///直接传入UpdateEntity进行更新提示
  static void checkUpdateByUpdateEntity() async {
    FlutterXUpdate.updateByInfo(updateEntity: await customParseJson());
  }

  ///自定义更新弹窗样式
  static void customPromptDialog() {
    FlutterXUpdate.checkUpdate(
        url: jsonUrl,
        themeColor: '#FFFFAC5D',
        topImageRes: 'bg_update_top',
        buttonTextColor: '#FFFFFFFF');
  }
}
