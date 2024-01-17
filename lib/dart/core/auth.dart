import 'dart:convert';

import 'package:orginone/common/values/constants.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/main_bean.dart';
import 'package:orginone/utils/storage.dart';

/// 授权方法提供者
class AuthProvider {
  // 授权成功事件
  late Future<void> Function(XTarget user) _onAuthed;
  AuthProvider(Future<void> Function(XTarget user) authed) {
    _onAuthed = authed;

    String userjson = Storage.getString(Constants.sessionUser);

    if (userjson.isNotEmpty) {
      kernel.user = XTarget.fromJson(jsonDecode(userjson));
      _onAuthed.call(kernel.user!);
    } else {
      kernel.tokenAuth().then((success) async {
        if (success && null != kernel.user) {
          Storage.setJson(Constants.sessionUser, kernel.user!.toJson());
          await _onAuthed.call(kernel.user!);
        }
      });
    }
  }

  /// 获取动态密码
  /// @param {RegisterType} params 参数
  Future<ResultType<DynamicCodeModel>> dynamicCode(
    DynamicCodeModel params,
  ) async {
    return await kernel.auth("DynamicPwd", params, DynamicCodeModel.fromJson);
  }

  /// 登录
  /// @param {RegisterType} params 参数
  Future<ResultType<TokenResultModel>> login(
    LoginModel params,
  ) async {
    var res = await kernel.auth<TokenResultModel>(
        'Login', params, TokenResultModel.fromJson);
    if (res.success) {
      await _onAuthed(res.data!.target);
    }
    return res;
  }

  /// 注册用户
  /// @param {RegisterType} params 参数
  Future<ResultType<TokenResultModel>> register(
    RegisterModel params,
  ) async {
    var res = await kernel.auth<TokenResultModel>(
        'Register', params, TokenResultModel.fromJson);
    if (res.success) {
      await _onAuthed(res.data!.target);
    }
    return res;
  }

  /// 变更密码
  /// @param account 账号
  /// @param password 密码
  /// @param privateKey 私钥
  /// @returns
  Future<ResultType<TokenResultModel>> resetPassword(
    ResetPwdModel params,
  ) async {
    var res = await kernel.auth<TokenResultModel>(
        'ResetPwd', params, TokenResultModel.fromJson);
    if (res.success) {
      await _onAuthed(res.data!.target);
    }
    return res;
  }

  /// 重置密码
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
// Future<ResultType<TokenResultModel>> resetPasswordForDynamicCode(
//     ResetPwdModel params,
//   ) async {
//     var res = await kernel.auth<TokenResultModel>(
//         'ResetPwd', params, TokenResultModel.fromJson);
//     if (res.success) {
//       await _onAuthed(res.data!.target);
//     }
//     return res;
//   }
// }
}
