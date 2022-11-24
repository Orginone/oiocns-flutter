import 'package:orginone/api/hub/store_server.dart';
import 'package:orginone/api_resp/api_resp.dart';
import 'package:orginone/api_resp/message_detail.dart';
import 'package:orginone/api_resp/org_chat_cache.dart';
import 'package:orginone/api_resp/page_resp.dart';
import 'package:orginone/api_resp/space_messages_resp.dart';
import 'package:orginone/api_resp/target.dart';
import 'package:orginone/enumeration/message_type.dart';
import 'package:orginone/enumeration/target_type.dart';

/// 定义连接服务的抽象，主要方法是开启，鉴权，停止
abstract class ConnServer {
  /// 启动连接
  Future<void> start();

  /// 授权
  Future<void> tokenAuth();

  /// 校验权限
  checkAuthed();

  /// 停止连接
  Future<void> stop();
}

abstract class ChatServer {
  /// 获取聊天面板
  Future<List<ChatGroup>> getChats();

  /// 发送消息
  Future<ApiResp> send({
    required String spaceId,
    required String itemId,
    required String msgBody,
    required MsgType msgType,
  });

  /// 获取用户名称
  Future<String> getName(String personId);

  /// 根据类型获取历史消息
  Future<List<MessageDetail>> getHistoryMsg({
    required TargetType typeName,
    required String spaceId,
    required String sessionId,
    required int offset,
    required int limit,
  });

  /// 撤销消息
  Future<ApiResp> recallMsg(MessageDetail msg);

  /// 获取群人员
  Future<PageResp<Target>> getPersons({
    required String cohortId,
    required int limit,
    required int offset,
  });

  /// 接受回调
  void rsvCallback(List<dynamic> params);
}

abstract class StoreServer {
  /// 获取信息
  Future<ApiResp> get(String key, String domain);

  /// 设置信息
  Future<ApiResp> set(String key, dynamic setData, String domain);

  /// 删除信息
  Future<ApiResp> delete(String key, String domain);

  /// 插入信息
  Future<ApiResp> insert(String collName, dynamic data, String domain);

  /// 更新信息
  Future<ApiResp> update(String collName, dynamic update, String domain);

  /// 删除信息
  Future<ApiResp> remove(String collName, dynamic match, String domain);

  /// 聚合信息
  Future<ApiResp> aggregate(String collName, dynamic opt, String domain);

  /// 订阅
  subscribing(SubscriptionKey key, String domain, Function callback);

  /// 取消订阅
  unsubscribing(SubscriptionKey key, String domain);

  /// 缓存一条会话信息
  Future<ApiResp> cacheMsg(String sessionId, MessageDetail detail);

  /// 获取个人空间历史消息
  Future<List<MessageDetail>> getUserSpaceHistoryMsg({
    required TargetType typeName,
    required String sessionId,
    required int offset,
    required int limit,
  });

  /// 缓存整个对象
  Future<ApiResp> cacheChats(OrgChatCache orgChatCache);

  /// 清空历史会话消息
  Future<ApiResp> clearHistoryMsg(String sessionId);

  /// 删除一条消息
  Future<ApiResp> deleteMsg(String chatId);
}
