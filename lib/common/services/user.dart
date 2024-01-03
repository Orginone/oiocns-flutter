// ignore_for_file: deprecated_member_use

/*
 * @Descripttion: 
 * @version: 
 * @Author: congsir
 * @Date: 2022-11-26 15:31:17
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2022-12-15 21:33:56
 */
import 'dart:convert';
import 'package:get/get.dart';
import 'package:orginone/utils/index.dart';

import '../index.dart';

/// 用户服务
class UserService extends GetxService {
  static UserService get to => Get.find();

  /// 是否登录
  bool get isLogin => _isLogin.value;
  final _isLogin = false.obs;

  /// 是否有令牌 token
  bool get hasToken => token.isNotEmpty;
  String token = '';
  Map<String, dynamic> userNamePassword = {};

  /// 用户 profile
  // UserModel get userInfo => _userInfo.value;
  // final _userInfo = UserModel().obs;

  /// 仓库

  @override
  void onInit() {
    super.onInit();
    // 读 token
    token = Storage.getString(Constants.appTokenKey);
    if (token.isNotEmpty) {
      _isLogin(true); //每次app重启的时候 记录登录状态
    }
    // 读 profile
    getUserInfo();
    getUserNamePassword();
  }

  /// 设置令牌  +++++++++++++++++++++++++++++++++++++++++
  Future<void> setToken(String value) async {
    await Storage.setString(Constants.appTokenKey, value);
    token = value;
  }

  /// 设置令牌  +++++++++++++++++++++++++++++++++++++++++
  Future<void> setUserNamePassword(Map<String, dynamic> info) async {
    await Storage.setJson(Constants.userNamePassword, info);
    userNamePassword = info;
  }

  Future<Map<String, dynamic>> getUserNamePassword() async {
    String userInfo = Storage.getString(Constants.userNamePassword);
    if (userInfo.isEmpty) {
      return {'username': "", 'password': ''};
    }
    userNamePassword = jsonDecode(userInfo);

    return userNamePassword;
  }

  // /// 储存用户信息 +++++++++++++++++++++++++++++++++++++++++
  // Future<void> setUserInfo(UserModel userModel) async {
  //   if (token.isEmpty) return;
  //   _isLogin.value = true;
  //   _userInfo(userModel);
  //   Storage().setString(Constants.userInfoKey, jsonEncode(userModel));
  // }

  /// 获取用户信息
  Future<void> getUserInfo() async {
    if (token.isEmpty) return;
    var userInfoOffline = Storage.getString(Constants.userInfoKey);
    if (userInfoOffline.isNotEmpty) {
      // _userInfo(UserModel.fromJson(jsonDecode(userInfoOffline)));
    }
    _isLogin.value = true;
  }

  /// 注销+++++++++++++++++++++++++++++++++++++++++
  Future<void> logout() async {
    // if (_isLogin.value) await UserAPIs.logout();
    await Storage.remove(Constants.appTokenKey);
    await Storage.remove(Constants.sessionUser);
    // _userInfo(UserModel());
    _isLogin.value = false;
    token = '';
  }

  /// 检查是否登录+++++++++++++++++++++++++++++++++++++++++
  Future<bool> checkIsLogin() async {
    if (_isLogin.value == false) {
      // await Get.toNamed(RouteNames.systemLoginSafe);
      return false;
    }
    return true;
  }
}
