
import 'package:orginone/dart/base/model.dart';

// 异常消息常量
const unAuthorizedError = '抱歉,您没有权限操作.';
const isExistError = '抱歉,已存在请勿重复创建.';
const resultError = '抱歉,请求返回异常.';
const notFoundError = '抱歉,未找到该数据.';
const isJoinedError = '抱歉,您已加入该组织.';
const functionNotFoundError = '抱歉,未找到该方法.';

class StoreCollName {
  static const wrkTask = 'work-task';
  static const workInstance = 'work-instances';
  static const chatMessage = 'chat-message';

  static const mostUsed = 'most-used';
}

enum OrgAuth{
  // 超管权限
  superAuthId("361356410044420096"),
  // 关系管理权限
  relationAuthId("361356410623234048"),
  // 物，标准等管理权限
  thingAuthId("361356410698731520"),
  // 办事管理权限
  workAuthId("361356410774228992");

  final String label;
  const OrgAuth(this.label);
}

var ShareIdSet = <String, ShareIcon>{};