/*
 * @Descripttion: 
 * @version: 
 * @Author: congsir
 * @Date: 2022-11-26 11:39:00
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2022-12-12 16:11:04
 */
class ErrorMessageModel {
  int? statusCode;
  String? error;
  String? message;

  ErrorMessageModel({this.statusCode, this.error, this.message});

  factory ErrorMessageModel.fromJson(Map<String, dynamic> json) =>
      ErrorMessageModel(
        statusCode: json['statusCode'] == null
            ? json["status"]
            : json['statusCode'] as int?,
        error: json['error'] as String?,
        message: json['message'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'error': error,
        'message': message,
      };
}
