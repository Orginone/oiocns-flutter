/*
 * @Descripttion: 
 * @version: 
 * @Author: congsir
 * @Date: 2022-11-24 15:23:10
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2022-12-14 20:26:32
 */
import 'dart:ui';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 配置服务
class ConfigService extends GetxService {
  // 这是一个单例写法
  static ConfigService get to => Get.find();
  Locale locale = PlatformDispatcher.instance.locale;
  PackageInfo? _platform;
  //版本号
  String get version => _platform?.version ?? '-';
  RxString? _currentEnv;
  //版本号
  String get currentEnv => _currentEnv?.value ?? '-';
  // 主题
  final RxBool _isDarkModel = Get.isDarkMode.obs;
  bool get isDarkModel => _isDarkModel.value;

  // 初始化
  Future<ConfigService> init() async {
    await getPlatform();
    return this;
  }

  Future<void> getPlatform() async {
    _platform = await PackageInfo.fromPlatform();
  }

  @override
  void onReady() {
    super.onReady();

    initLocale();
    initTheme();
  }

/*
语言模块 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 */
// 初始语言
  void initLocale() {
    var langCode = Storage().getString(Constants.storageLanguageCode);
    if (langCode.isEmpty) return;
    var index = Translation.supportedLocales.indexWhere((element) {
      return element.languageCode == langCode;
    });
    if (index < 0) return;
    locale = Translation.supportedLocales[index];
  }

  // 更改语言
  void onLocaleUpdate(Locale value) {
    locale = value;
    Get.updateLocale(value);
    Storage().setString(Constants.storageLanguageCode, value.languageCode);
  }

  /*
  主题模块 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   */
  // 初始 theme
  void initTheme() {
    var themeCode = Storage().getString(Constants.storageThemeCode);
    _isDarkModel.value = themeCode == "dark" ? true : false;
    Get.changeTheme(
      themeCode == "dark" ? AppTheme.dark : AppTheme.light,
    );
  }

  // 切换 theme
  Future<void> switchThemeModel() async {
    _isDarkModel.value = !_isDarkModel.value;
    Get.changeTheme(
      _isDarkModel.value == true ? AppTheme.dark : AppTheme.light,
    );
    await Storage().setString(Constants.storageThemeCode,
        _isDarkModel.value == true ? "dark" : "light");
  }

  // 是否首次打开App
  bool get opened => Storage().getBool(Constants.storageisFirstOpen);

// 标记已打开app
  void setAlreadyOpen() {
    Storage().setBool(Constants.storageisFirstOpen, true);
  }
}
