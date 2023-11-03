/*
 * @Descripttion: 
 * @version: 
 * @Author: congsir
 * @Date: 2022-11-24 15:23:10
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2022-12-14 19:45:39
 */
import '../locale_keys.dart';

/// 多语言 中文
Map<String, String> localeZh = {
  // 通用
  LocaleKeys.commonSearchInput: '输入关键字',
  LocaleKeys.commonBottomSave: '保存',
  LocaleKeys.commonBottomRemove: '删除',
  LocaleKeys.commonBottomCancel: '取消',
  LocaleKeys.commonBottomConfirm: '确认',
  LocaleKeys.commonBottomApply: '应用',
  LocaleKeys.commonBottomBack: '返回',
  LocaleKeys.commonSelectTips: '请选择',
  LocaleKeys.commonMessageSuccess: '@method 成功',
  LocaleKeys.commonMessageIncorrect: '@method 不正确',

  // 样式
  LocaleKeys.stylesTitle: '样式 && 功能 && 调试',

  // welcome 欢迎
  LocaleKeys.welcomeOneTitle: '欢迎使用',
  LocaleKeys.welcomeOneDesc:
      'Contrary to popular belief, Lorem Ipsum is not simply random text',
  LocaleKeys.welcomeTwoTitle: '完成您需求',
  LocaleKeys.welcomeTwoDesc:
      'Contrary to popular belief, Lorem Ipsum is not simply random text',
  LocaleKeys.welcomeThreeTitle: '足不出户的体验',
  LocaleKeys.welcomeThreeDesc:
      'Contrary to popular belief, Lorem Ipsum is not simply random text',
  LocaleKeys.welcomeSkip: '跳过',
  LocaleKeys.welcomeNext: '下一页',
  LocaleKeys.welcomeStart: '立刻开始',

  // 登录、注册 - 通用
  LocaleKeys.loginForgotPassword: '忘记密码?',
  LocaleKeys.loginSignIn: '登 录',
  LocaleKeys.loginSignUp: '注 册',
  LocaleKeys.loginOrText: '- 或者 -',

  // 注册 - register user
  LocaleKeys.registerTitle: '欢迎',
  LocaleKeys.registerDesc: '注册新账号',
  LocaleKeys.registerFormName: '登录账号',
  LocaleKeys.registerFormEmail: '电子邮件',
  LocaleKeys.registerFormPhoneNumber: '电话号码',
  LocaleKeys.registerFormPassword: '密码',
  LocaleKeys.registerFormFirstName: '姓',
  LocaleKeys.registerFormLastName: '名',
  LocaleKeys.registerHaveAccount: '你有现成账号?',

  // 验证提示
  LocaleKeys.validatorRequired: '字段不能为空',
  LocaleKeys.validatorEmail: '请输入 email 格式',
  LocaleKeys.validatorMin: '长度不能小于 @size',
  LocaleKeys.validatorMax: '长度不能大于 @size',
  LocaleKeys.validatorPassword: '密码长度必须 大于 @min 小于 @max',

  // 注册PIN - register pin
  LocaleKeys.registerPinTitle: '验证',
  LocaleKeys.registerPinDesc: '我们将向您发送PIN码以继续您的帐户',
  LocaleKeys.registerPinFormTip: 'Pin',
  LocaleKeys.registerPinButton: '提交',

  // 登录 - back login
  LocaleKeys.loginBackTitle: '欢迎登录!',
  LocaleKeys.loginBackDesc: '登录后继续',
  LocaleKeys.loginBackFieldEmail: '账号',
  LocaleKeys.loginBackFieldPassword: '登录密码',

  LocaleKeys.loginSafeTile: '安全登录',
  LocaleKeys.loginSafeAccountHolder: '请输入账号',
  LocaleKeys.loginSafePasswordHolder: '请输入密码',

  // APP 导航
  LocaleKeys.tabBarHome: '工作台',

  LocaleKeys.tabBarSearch: '消息中心',
  LocaleKeys.tabBarProfile: '个人中心',

  // 我的
  LocaleKeys.myBtnMyOrder: '我的订单',
  LocaleKeys.myBtnEditProfile: '编辑个人资料',
  LocaleKeys.myBtnNotification: '消息',
  LocaleKeys.myBtnLanguage: '语言',
  LocaleKeys.myBtnTheme: '主题',
  LocaleKeys.myBtnWinGift: '赢取礼物',
  LocaleKeys.myBtnStyles: '样式组件',
  LocaleKeys.myBtnLogout: '注销',

  // 拍照、相册
  LocaleKeys.pickerTakeCamera: '拍照',
  LocaleKeys.pickerSelectAlbum: '从相册中选取',

  //个人中心
  LocaleKeys.currentVersion: "当前版本",
  LocaleKeys.changePassword: "密码修改",
  LocaleKeys.logout: "退出登录"
};
