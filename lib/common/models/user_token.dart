/*
 * @Descripttion: 
 * @version: 
 * @Author: congsir
 * @Date: 2022-12-07 10:25:44
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2022-12-09 13:40:30
 */
/// 用户令牌
class UserTokenModel {
  String? token;

  UserTokenModel({
    this.token,
  });

  factory UserTokenModel.fromJson(Map<String, dynamic> json) {
    return UserTokenModel(
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'token': token,
      };
}
