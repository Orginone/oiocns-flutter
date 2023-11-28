/*
 * @Descripttion: 
 * @version: 
 * @Author: congsir
 * @Date: 2022-11-24 15:23:10
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2022-12-13 19:31:25
 */

/// 常量
class Constants {
// wp 服务器

  // 本地存储key language_code
  static const storageLanguageCode = 'language_code';
  //主题
  static const storageThemeCode = 'theme_code';

  static const storageisFirstOpen = 'first_open'; // 首次打开

  // AES
  // static const aesKey = 'aH5aH5bG0dC6aA3oN0cK4aU5jU6aK2lN'; //加密 key 32 位
  // static const aesIV = 'hK6eB4aE1aF3gH5q'; // 加密向量 16 位
  static const aesKey = ''; // EnvConfig.pwdEncryptKey; //加密 key 32 位
  static const aesIV = 'hK6eB4aE1aF3gH5q'; // 加密向量 16 位

  static const baseUrlKey = 'app-base-url'; // 基础路径字段名
  static const sessionUser = 'sessionUser'; // 用户会话
  static const appTokenKey =
      'X-Auth-Token'; //X-Auth-Token Authorization appToken字段名(本地存储，以及dio请求头均使用到此字段名称，不能随意改动)
  static const userInfoKey = 'app-user-info'; // 用户基础信息字段名
  static const userNamePassword = 'app-user-name-password'; // 用户名密码
  static const userResKey = 'app-user-res'; // 用户权限资源表字段名
  static const warehouse = 'app-user-warehouse'; // 当前使用仓库
  static const carNumber = 'app-car-number'; // 最后一次使用的车牌号
}
