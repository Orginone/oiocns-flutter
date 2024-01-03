/*
 * @Descripttion: 
 * @version: 
 * @Author: congsir
 * @Date: 2022-12-14 21:01:30
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2022-12-15 18:49:57
 */

class RequestConfig {
  static const statusField = 'status';
  static const messageField = 'message';
  static const dataField = 'data';
  static const statusSuccess = 2000;
  static const statusInvalid = 1003;

  /// 根据环境，获取不同的基础地址

  static const baseHost = ''; //EnvConfig.baseHost;
  static const urlPrefix =
      ''; //EnvConfig.env == Env.DEV ? '' : '/api/archive/v1';

  static const baseUrlWithClientPrefix = '$baseHost$urlPrefix';

  static const baseUrl = baseUrlWithClientPrefix;
}
