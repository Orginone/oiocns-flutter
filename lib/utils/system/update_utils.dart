import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/widgets/common/image/image_widget.dart';
import 'package:orginone/config/index.dart';
import 'package:orginone/dart/base/model.dart' hide Column;
import 'package:orginone/env.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/utils/http_util.dart';
import 'package:orginone/utils/log/log_util.dart';
import 'package:orginone/utils/string_util.dart';
import 'package:orginone/utils/toast_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/*
* version.json   默认为官方网站包asset.orginone.cn
* version_ios.json    苹果Appstore版本包
* version_huawei.json   华为应用商城版本包
* version_rongyao.json   华为应用商城版本包
* version_xiaomi.json   小米应用商城版本包
* version_oppo.json   oppo应用商城版本包
* version_vivo.json   vivo应用商城版本包
 * */
class AppUpdate {
  factory AppUpdate() => _getInstance();

  static AppUpdate get instance => _getInstance();

  static AppUpdate? _instance;
  static UpdateModel? _updateModel;
  static PackageInfo? _packageInfo;
  static String donloadUrl =
      '${Constant.host}/orginone/kernel/load/horvypjb8gtorvyezuenfyge63ime2xi3lonizxo6rwowwx52urm6xug1ddn11hcl1wgi5uenbqha3uknbxgv5dinryha2s8u3sm6vx533omwpyk3ujo1sye53bnqygc5dl';
  static String jsonUrl = '';
  //l3hkk8rgkhtorvyezuenfyge63imv1xi33pmj5gonjrowyx5mlum6vue6lpnw1hvl1wgmzuimr1gi1donjrga1din1vgi2s86ufoj1xs33of1whg33o
  static String universal =
      '${Constant.host}/orginone/kernel/load/6jl526wkhitorvyezuenfyge63imv1xi33pmj5gonjrowyx5mlum6vue6lpnw1hvl1wgmzuimr1gi1donjrga1din1vgi2s86ufoj1xs33of1whg33o';
  static String huawei =
      '${Constant.host}/orginone/kernel/load/gcxzkruejltorvyezuenfyge63imv1xi33pmj5gonjrowyx5mlum6vue6lpnw1hvl1wgmzuimr1gi1donjrga1din1vgi2s86ufoj1xs33ol6vhkzlymwvs52uun6ya';
  static String rongyao =
      '${Constant.host}/orginone/kernel/load/onm3zp6cg6torvyezuenfyge63imv1xi33pmj5gonjrowyx5mlum6vue6lpnw1hvl1wgmzuimr1gi1donjrga1din1vgi2s86ufoj1xs33ol61g83uhpfqx8lukonyxo';
  static String xiaomi =
      '${Constant.host}/orginone/kernel/load/cuunhjnxf8torvyezuenfyge63imv1xi33pmj5gonjrowyx5mlum6vue6lpnw1hvl1wgmzuimr1gi1donjrga1din1vgi2s86ufoj1xs33ol65gszlpnwvs52uun6ya';
  static String oppo =
      '${Constant.host}/orginone/kernel/load/36a2qxbr5gtorvyezuenfyge63imv1xi33pmj5gonjrowyx5mlum6vue6lpnw1hvl1wgmzuimr1gi1donjrga1din1vgi2s86ufoj1xs33ol6yya5dpf1whg33o';
  static String vivo =
      '${Constant.host}/orginone/kernel/load/5jp2yenq6ktorvyezuenfyge63imv1xi33pmj5gonjrowyx5mlum6vue6lpnw1hvl1wgmzuimr1gi1donjrga1din1vgi2s86ufoj1xs33ol63gs6upf1whg33o';
  static String ios =
      '${Constant.host}/orginone/kernel/load/chrofcou6etorvyezuenfyge63imv1xi33pmj5gonjrowyx5mlum6vue6lpnw1hvl1wgmzuimr1gi1donjrga1din1vgi2s86ufoj1xs33ol6vx851onj1x83c';
  // static String jsonUrl = '${Constant.host}/530452429356011521';
  //https://asset.orginone.cn/orginone/kernel/load/w658umk2sgtorvyezuenfyge63imv1xi33pmj5gonjrowyx5mlum6vue6lpnw1hvl1wgmzuimr1gi1donjrga1din1vgi2s86ufoj1xs33of1whg33o

  static String marketUrl = '';
  AppUpdate._internal() {
    //内部初始化
    _init();
  }

  static AppUpdate _getInstance() {
    _instance ??= AppUpdate._internal();
    return _instance!;
  }

  void _init() async {
    _initUpdate();
    _packageInfo = await PackageInfo.fromPlatform();
  }

  _initUpdate() {
    switch (EnvConfig.platform) {
      case ReleasePlatform.huawei:
        jsonUrl = huawei;
        marketUrl = "appmarket://details?id=asset.orginone.cn";
        // marketUrl = "appmarket://details?id=com.huawei.browser";
        break;
      case ReleasePlatform.rongyao:
        jsonUrl = rongyao;
        marketUrl = "appmarket://details?id=asset.orginone.cn";
        break;
      case ReleasePlatform.xiaomi:
        jsonUrl = xiaomi;
        marketUrl = "mimarket://details?id=asset.orginone.cn";
        break;
      case ReleasePlatform.oppo:
        jsonUrl = oppo;
        marketUrl = "oppomarket://details?packagename=asset.orginone.cn";
        break;
      case ReleasePlatform.vivo:
        jsonUrl = vivo;
        marketUrl = "vivomarket://details?id=asset.orginone.cn"; //vivoMarket
        break;
      case ReleasePlatform.ios:
        jsonUrl = ios;
        marketUrl = "itms-apps://itunes.apple.com/app/id6476134853";
        break;
      default:
        jsonUrl = universal;
        _initXUpdate(); //平台下载的安卓通用版本  使用应用内更新
    }
  }

  static _initXUpdate() {
    FlutterXUpdate.init(

            ///是否输出日志
            debug: true,

            ///是否使用post请求
            isPost: true,

            ///post请求是否是上传json
            isPostJson: false, //是否使用json false 使用其他方式

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
      // LogUtil.d(value);
    }).catchError((error) {
      // LogUtil.d(error);
      ToastUtils.showMsg(msg: error.toString());
    });
    FlutterXUpdate.setErrorHandler(
        onUpdateError: (Map<String, dynamic>? message) async {
      // LogUtil.d(message);
      ToastUtils.showMsg(msg: message.toString());
    });

    FlutterXUpdate.setUpdateHandler(
        onUpdateError: (Map<String, dynamic>? message) async {
      //下载失败
      if (message?["code"] == 4000) {
        FlutterXUpdate.showRetryUpdateTipDialog(
            retryContent: '下载失败是否重新下载？', retryUrl: donloadUrl);
      }

      ///取消下载
      if (message?["code"] == 4002) {
        ToastUtils.showMsg(msg: '取消下载');
      }
      if (message?["code"] != 2004) {
        //已经是最新版本
        ToastUtils.showMsg(msg: message.toString());
      }
    }, onUpdateParse: (String? json) async {
      //这里是自定义json解析
      return updateEntity();
    });
  }

  ///将自定义的json内容解析为UpdateEntity实体类
  static Future<UpdateEntity> updateEntity() async {
    // LogUtil.d(packageInfo.packageName); // app包名，如：com.ppw.ppw_app.dev
    // LogUtil.d(packageInfo.appName); // app名称，如：豪波公物仓
    // LogUtil.d(packageInfo.version); // 版本号，如：1.6.2-dev
    // LogUtil.d(packageInfo.buildNumber); // 构建号，如：1
    // String url = 'http://183.134.111.2:9090/apk/ppw/version.json';

    return UpdateEntity(
      hasUpdate: _updateModel?.update,
      // isForce: true,
      isForce: _updateModel?.force,
      versionCode: int.parse(_packageInfo!.buildNumber),
      versionName: _updateModel?.version,
      updateContent: _updateModel?.content,
      downloadUrl: _updateModel!.url.isEmpty ? donloadUrl : _updateModel?.url,
      // apkSize: 120217 //_updateModel!.fileItemShare!.size! ~/ 1024,
      // apkMd5: "E4B79A36EFB9F17DF7E3BB161F9BCFD8"
    );
    //form 表单方式
    // return UpdateEntity(
    //   hasUpdate: _updateModel?.update,
    //   isForce: _updateModel?.force,
    //   versionCode: int.parse(_packageInfo!.buildNumber),
    //   versionName: _updateModel?.version,
    //   updateContent: _updateModel?.content,
    //   downloadUrl: _updateModel!.url.isEmpty ? donloadUrl : _updateModel?.url,
    //   apkSize: _updateModel!.fileItemShare!.size! ~/ 1024,
    //   // apkMd5: "E4B79A36EFB9F17DF7E3BB161F9BCFD8"
    // );
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
      themeColor: '#FF056DE3',
      topImageRes: 'bg_update_top',
      buttonTextColor: '#FFFFFFFF',
      // widthRatio: 0.9,
      // heightRatio: 0.6,
    );
  }

  void _updateByInfo() {
    FlutterXUpdate.updateByInfo(
      updateEntity: UpdateEntity(
        hasUpdate: _updateModel?.update,
        isForce: _updateModel?.force,
        versionCode: int.parse(_packageInfo!.buildNumber),
        versionName: _updateModel?.version,
        updateContent: _updateModel?.content,
        downloadUrl: _updateModel!.url.isEmpty ? donloadUrl : _updateModel?.url,
        apkSize: _updateModel!.fileItemShare!.size! ~/ 1024,
        // apkMd5: "E4B79A36EFB9F17DF7E3BB161F9BCFD8"
      ),
    );
  }

  Future<bool> update() async {
    bool update = await checkUpdate();
    _updateModel?.update = update;
    if (update) {
      _doUpdate();
    }
    return update;
  }

  _doUpdate() {
    switch (EnvConfig.platform) {
      case ReleasePlatform.huawei:
        jsonUrl = huawei;
        _updateModel!.force = true;
        // _updateModel!.content =
        //     '1、底层框架进行了深度优化改版底层框架进行了深度优化改版；\r\n2、门户、数据、关系等用户页面进行了改版；\r\n3、底层框架进行了深度优化改版；\r\n4、门户、数据、关系等用户页面进行了改版；\r\n5、底层框架进行了深度优化改版；\r\n6、门户、数据、关系等用户页面进行了改版；\r\n7、底层框架进行了深度优化改版；\r\n8、门户、数据、关系等用户页面进行了改版；门户、数据、关系等用户页面进行了改版\r\n1、底层框架进行了深度优化改版底层框架进行了深度优化改版；\r\n2、门户、数据、关系等用户页面进行了改版；\r\n3、底层框架进行了深度优化改版；\r\n4、门户、数据、关系等用户页面进行了改版；\r\n5、底层框架进行了深度优化改版；\r\n6、门户、数据、关系等用户页面进行了改版；\r\n7、底层框架进行了深度优化改版；\r\n8、门户、数据、关系等用户页面进行了改版；门户、数据、关系等用户页面进行了改版\r\n';
        // // _updateModel!.content = '1、底层框架进行了深度优化改；';

        _showMarketUpdate();
        break;
      case ReleasePlatform.rongyao:
        jsonUrl = rongyao;
        _showMarketUpdate();
        break;
      case ReleasePlatform.xiaomi:
        jsonUrl = xiaomi;
        _showMarketUpdate();
        break;
      case ReleasePlatform.oppo:
        jsonUrl = oppo;
        _showMarketUpdate();
        break;
      case ReleasePlatform.vivo:
        jsonUrl = vivo;
        _showMarketUpdate();
        break;
      case ReleasePlatform.ios:
        jsonUrl = ios;
        _showMarketUpdate();
        break;
      default:
        jsonUrl = universal;
        //通过form表单加载
        // _updateByInfo();
        //通过json文件加载
        _customJsonParse(); //平台下载的安卓通用版本  使用应用内更新
    }
  }

  _showMarketUpdate() {
    // EnvConfig.platform
    showDialog(
      context: Get.context!,
      barrierDismissible: false, //设置为false，点击空白处弹窗不关闭
      builder: (_) => WillPopScope(
        onWillPop: () async => false, //关键代码
        child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            child: UpgradeDialog(
              updateModel: _updateModel!,
              confirmCallBack: () async {
                //跳转应用市场详情页market
                //https://blog.csdn.net/fumeidonga/article/details/134607924
                Navigator.of(Get.context!).pop();
                await _openMarket();
              },
            )),
      ),
    );
  }

  static _openMarket() async {
    if (await canLaunchUrl(Uri.parse(marketUrl))) {
      await launchUrl(Uri.parse(marketUrl)).then((value) {
        LogUtil.d('_openMarket');
        LogUtil.d(value);
      });
    }
  }

  String getLocalVersion() {
    return _packageInfo?.version ?? '1.0.0';
  }

/*
 * 检查更新
 * */
  static Future<bool> checkUpdate() async {
    // List<dynamic> versionInfo = await UpdateRequest.loadVersionForm();
    // // LogUtil.d('versionInfo');
    // // LogUtil.d(versionInfo);
    // List<PropertyModel> properties = await UpdateRequest.loadFormProperty();
    // //把表单的行列表的最新一条数据 和属性列表的属性进行组装 生成更新版本模型
    // if (versionInfo.isEmpty) return false;
    // // return false;
    // Map<String, dynamic>? map = assembleData(versionInfo.last, properties);
    // if (map == null) {
    //   return false;
    // }
    // _updateModel = UpdateModel.fromJson(map);
    final remoteData = await HttpUtil().post(jsonUrl);

    LogUtil.d('update');
    LogUtil.d(remoteData);
    if (remoteData == null || remoteData['status'] != 2000) return false;
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

  //组装数据

  static Map<String, dynamic>? assembleData(
      Map<String, dynamic> formCellInfo, List<PropertyModel> propertys) {
    if (formCellInfo == null) {
      return null;
    }
    Map<String, dynamic> map = {};
    for (var property in propertys) {
      if (formCellInfo.containsKey('T${property.id}')) {
        map[property.code ?? ''] = formCellInfo['T${property.id}'];
      }
    }

    if (map['url'] != null) {
      if (StringUtil.isJson(map['url'])) {
        if (jsonDecode(map['url']) is List &&
            jsonDecode(map['url']).length > 0) {
          map['fileItemShare'] = jsonDecode(map['url'])[0];
        } else {
          map['fileItemShare'] = jsonDecode(map['url']);
        }
        map['url'] = Constant.host + map['fileItemShare']['shareLink'];
      }
    }
    map['updateTime'] = formCellInfo['updateTime'];

    return map;
  }
}

class UpdateRequest {
  static Future<List<UpdateRecordModel>> loadHistoryVersionInfoByJson() async {
    final remoteData = await HttpUtil().post(AppUpdate.jsonUrl);

    // LogUtil.d('update');
    // LogUtil.d(remoteData);
    if (remoteData != null && remoteData['status'] != 2000) return [];
    UpdateModel updateModel = UpdateModel.fromJson((remoteData['data']));

    return updateModel.records ?? [];
  }

  //List<UpdateModel> loadHistoryVersionInfo =await UpdateRequest.loadHistoryVersionInfo();
  static Future<List<UpdateModel>> loadHistoryVersionInfo() async {
    List<dynamic> versionInfo = await UpdateRequest.loadVersionForm();
    List<PropertyModel> propertys = await UpdateRequest.loadFormProperty();
    //把表单的行列表的最新一条数据 和属性列表的属性进行组装 生成更新版本模型
    // return false;
    if (versionInfo.isNotEmpty) {
      return versionInfo
          .map((e) => AppUpdate.assembleData(e, propertys))
          .toList()
          .map((json) => UpdateModel.fromJson(json ?? {}))
          .toList();
    }

    return [];
  }

  static Future<List<dynamic>> loadVersionForm() async {
    String belongId = '445967867377225728';
    String relation = '445967867377225728';
    List<dynamic> things = [];
    ResultType result = await kernel.loadThing(
      belongId,
      [relation],
      {
        "requireTotalCount": false,
        "searchOperation": "contains",
        "searchValue": null,
        "skip": 0,
        "take": 20,
        "userData": ["F531430631884861441"],
        "sort": null,
        "group": null,
        "belongId": belongId
      },
    );

    if (result.success) {
      things = result.data['data'];
    }

    return things;
  }

  ///加载 表单下面的属性
  static Future<List<PropertyModel>> loadFormProperty() async {
    //奥集能移动端版本发布群 - 版本更新 - 版本信息属性
    String belongId = '445967867377225728';
    String relation = '445967867377225728';
    String collName = 'standard-property';
    var options = {};
    options['userData'] = [];
    options['collName'] = collName;
    options['options'] = {
      "match": {
        "directoryId": "530454983716507649",
        "shareId": "531435684393787392"
      }
    };

    var res = await kernel.collectionLoad(
      belongId,
      [relation],
      collName,
      options,
    );

    if (res.success && res.data != null && res.data['data'] != null) {
      List properties = res.data['data'];
      return properties.map((e) => PropertyModel.fromJson(e)).toList();
    }
    return [];
  }
}

class UpdateModel {
  String? title;
  String? content;
  String? updateTime;
  String url;
  String version;
  bool? force;
  bool? update;
  List<UpdateRecordModel>? records;
  FileItemShare? fileItemShare;

  UpdateModel({
    this.title,
    this.content,
    this.updateTime,
    this.records,
    required this.url,
    required this.version,
    this.force,
    this.update,
    this.fileItemShare,
  });

  factory UpdateModel.fromJson(Map<String, dynamic> json) => UpdateModel(
        title: json['title'] == null ? null : json['title'] as String,
        content: json['content'] == null ? null : json['content'] as String,
        updateTime:
            json['updateTime'] == null ? null : json['updateTime'] as String,
        url: json['url'] ?? '',
        version: json['version'] ?? '1.0.0',
        force: json['force'] == null
            ? false
            : json['force'] == 1
                ? true
                : false,
        update: json['update'] == null ? false : json['update'] as bool,
        records: json['records'] == null
            ? []
            : (json['records'] as List)
                .map((e) => UpdateRecordModel.fromJson(e))
                .toList(),
        fileItemShare: json['fileItemShare'] == null
            ? null
            : FileItemShare.fromJson(json['fileItemShare']),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'updateTime': updateTime,
        'url': url,
        'version': version,
        'force': force,
        'update': update,
        'records': records?.map((e) => e.toJson()).toList(),
        'fileItemShare': fileItemShare?.toJson(),
      };
}

class UpdateRecordModel {
  String? title;
  String? content;
  String? updateTime;
  String url;
  String version;
  bool? force;
  bool? update;
  FileItemShare? fileItemShare;

  UpdateRecordModel({
    this.title,
    this.content,
    this.updateTime,
    required this.url,
    required this.version,
    this.force,
    this.update,
    this.fileItemShare,
  });

  factory UpdateRecordModel.fromJson(Map<String, dynamic> json) =>
      UpdateRecordModel(
        title: json['title'] == null ? null : json['title'] as String,
        content: json['content'] == null ? null : json['content'] as String,
        updateTime:
            json['updateTime'] == null ? null : json['updateTime'] as String,
        url: json['url'] ?? '',
        version: json['version'] ?? '1.0.0',
        force: json['force'] == null
            ? false
            : json['force'] == 1
                ? true
                : false,
        update: json['update'] == null ? false : json['update'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'updateTime': updateTime,
        'url': url,
        'version': version,
        'force': force,
        'update': update,
      };
}

class UpgradeDialog extends Dialog {
  final UpdateModel updateModel;
  final void Function()? cancelCallBack;
  final void Function()? confirmCallBack;

  const UpgradeDialog(
      {super.key,
      required this.updateModel,
      this.confirmCallBack,
      this.cancelCallBack});

  @override
  Widget build(BuildContext context) {
    return upgradeDialog(context);
  }

  _content() {
    return Container(
      color: Colors.white,
      width: Get.width * 0.75,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget.title3(
            '是否升级到${updateModel.version}版本?',
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: Get.width * 0.75 - 15 * 2,
            constraints: const BoxConstraints(maxHeight: 110),
            child: SingleChildScrollView(
              child: TextWidget.body1(
                '${updateModel.content}',
                color: AppColors.gray_66,
                softWrap: true,
                maxLines: 20,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 40,
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ButtonWidget.text(
                  '升级',
                  backgroundColor: AppColors.primary,
                  height: AppSpace.buttonHeight,
                  width: Get.width * 0.75 - 15 * 2,
                  onTap: () {
                    //跳转应用市场详情页market
                    //https://blog.csdn.net/fumeidonga/article/details/134607924
                    // Navigator.of(Get.context!).pop();
                    confirmCallBack!();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _closeButton() {
    var closeButton = Column(
      children: [
        Container(
          height: 60,
          width: 1.5,
          color: AppColors.white,
        ),
        Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white)),
            child: ButtonWidget(
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 25,
              ),
              onTap: () {
                Navigator.of(Get.context!).pop();
                cancelCallBack!();
              },
            )),
      ],
    );
    return closeButton;
  }

  //自定义升级弹窗
  Widget upgradeDialog(BuildContext context) {
    var imageWidget = ImageWidget(
      'assets/images/bg_update_top.png',
      fit: BoxFit.fitWidth,
      width: Get.width * 0.75,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        imageWidget,
        _content(),
        updateModel.force! ? const SizedBox() : _closeButton(),
      ],
    );
  }
}
