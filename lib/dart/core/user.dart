import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/common/commands.dart';
import 'package:orginone/dart/base/common/emitter.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/auth.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/main.dart';
import 'package:orginone/utils/logger.dart';
import 'thing/standard/application.dart';
import 'work/provider.dart';

class UserProvider {
  ///当前用户
  final Rxn<IPerson> _user = Rxn();
  // late IPerson? _user;
  ///办事提供层
  final Rxn<IWorkProvider> _work = Rxn();
  late AuthProvider _auth;

  ///暂存提供层
  // final Rxn<IBoxProvider> _box = Rxn();

  bool _inited = false;
  late Emitter _emiter;
  var myApps = <Map<IApplication, ITarget>>[].obs;

  UserProvider(Emitter emiter) {
    _emiter = emiter;
    _auth = AuthProvider((data) async {
      await _loadUser(data);
    });
    // final userJson = Storage.getString(Constants.sessionUser);
    // if (userJson.isNotEmpty) {
    //   _loadUser(XTarget.fromJson(jsonDecode(userJson)));
    // }
  }

  /// 授权方法
  AuthProvider get auth {
    return _auth;
  }

  /// 当前用户
  IPerson get user {
    return _user.value!;
  }

  IWorkProvider? get work {
    return _work.value;
  }

  /// 是否完成初始化
  bool get inited {
    return _inited;
  }

  List<ITarget> get targets {
    final List<ITarget> targets = [];
    if (null != _user.value) {
      targets.addAll(_user.value!.targets);
      for (final company in _user.value!.companys) {
        targets.addAll(company.targets);
      }
    }
    return targets;
  }

  /// 登录
  /// @param account 账户
  /// @param password 密码
  Future<dynamic> login(String account, String password) async {
    var res = await kernel.login(account, password);
    if (res.success) {
      await _loadUser(XTarget.fromJson(res.data["target"]));
    }
    return res;
  }

  /// @param phoneNumber 手机号
  /// @param verifyCode 验证码
  /// @param dynamicId 动态码
  Future<dynamic> verifyCodeLogin(
      String account, String password, String dynamicId) async {
    var res = await kernel.verifyCodeLogin(account, password, dynamicId);
    if (res.success) {
      await _loadUser(XTarget.fromJson(res.data["target"]));
    }
    return res;
  }

  /// 二维码认证登录
  /// @param connectionId 二维码认证内容
  Future<ResultType> qrAuth(String connectionId) async {
    var res = await kernel.qrAuth(connectionId);
    return res;
  }

  /// 注册用户
  /// @param {RegisterType} params 参数
  register(RegisterType params) async {
    var res = await kernel.register(params);
    if (res.success) {
      await _loadUser(res.data.target);
    }
    return res;
  }

  /// 私钥变更密码
  /// @param account 账号
  /// @param password 密码
  /// @param privateKey 私钥
  /// @returns
  // Future<ResultType> resetPasswordForPrivateKey(
  //   String account,
  //   String password,
  //   String privateKey,
  // ) async {
  //   return await kernel.resetPasswordForPrivateKey(
  //       account, password, privateKey);
  // }

  /// 私钥变更密码
  /// @param account 账号
  /// @param password 密码
  /// @param privateKey 私钥
  /// @returns
  Future<ResultType> resetPasswordForDynamicCode(
    String account,
    String dynamicId,
    String dynamicCode,
    String password,
  ) async {
    return await kernel.resetPasswordForDynamicCode(
        account, dynamicId, dynamicCode, password);
  }

  /// 加载用户
  _loadUser(XTarget person) async {
    try {
      errInfo +=
          "开始创建人员数据${DateUtil.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss.SSS")}。。。\r\n";
      _user.value = Person(person);
      logger.info(_user);
      errInfo +=
          "开始创建办事提供器${DateUtil.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss.SSS")}。。。\r\n";
      _work.value = WorkProvider(this);
      refresh();
    } catch (e, s) {
      var t = DateUtil.formatDate(DateTime.now(),
          format: "yyyy-MM-dd HH:mm:ss.SSS");
      errInfo += '$t $e ==== $s';
      // ToastUtils.showMsg(msg: errInfo);
      // SystemUtils.copyToClipboard(errInfo);
      print('>>>====$s');
    }
  }

  /// 重载数据
  Future<void> refresh() async {
    _inited = false;
    try {
      await _user.value!.deepLoad(reload: true);
      await work?.loadTodos(reload: true);
      _inited = true;
      _emiter.changCallback();
      command.emitterFlag();
    } catch (e, s) {
      var t = DateUtil.formatDate(DateTime.now(),
          format: "yyyy-MM-dd HH:mm:ss.SSS");
      errInfo += '$t $e ==== $s';
      // ToastUtils.showMsg(msg: errInfo);
      // SystemUtils.copyToClipboard(errInfo);
    }
  }

  late String errInfo = "";
}
