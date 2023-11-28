import 'package:orginone/dart/base/common/emitter.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/entity.dart';
import 'package:orginone/dart/core/public/collection.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/chat/session.dart';

/// 动态消息接口
abstract class IActivityMessage extends Emitter {
  /// 消息主体
  late IActivity activity;

  /// 消息实体
  late ActivityType metadata;

  /// 更新元数据
  void update(ActivityType data);

  /// 删除消息
  void delete();

  /// 点赞
  Future<bool> like();

  /// 评论
  Future<bool> comment(String txt, {String? replyTo});
}

/// 动态消息实现
class ActivityMessage extends Emitter implements IActivityMessage {
  @override
  final IActivity activity;
  @override
  final ActivityType metadata;

  ActivityMessage(
    this.metadata,
    this.activity,
  );

  @override
  void delete() {
    changCallback();
    activity.activityList.removeWhere((i) => i.metadata.id != metadata.id);
  }

  @override
  void update(ActivityType data) {
    if (data.id == metadata.id) {
      metadata = data;
      changCallback();
    }
  }

  @override
  Future<bool> like() async {
    ActivityType? newData;
    if (metadata.likes.contains(activity.userId)) {
      newData = await activity.coll.update(metadata.id, {
        '_pull_': {'likes': activity.userId},
      });
    } else {
      newData = await activity.coll.update(metadata.id, {
        '_push_': {'likes': activity.userId},
      });
    }
    if (newData != null) {
      return await activity.coll.notity({
        'data': newData,
        'update': true,
      });
    }
    return false;
  }

  @override
  Future<bool> comment(String label, {String? replyTo}) async {
    final newData = await activity.coll.update(metadata.id, {
      '_push_': {
        'comments': {
          'label': label,
          'userId': activity.userId,
          'time': 'sysdate()',
          'replyTo': replyTo,
        },
      },
    });
    if (newData != null) {
      return await activity.coll.notity({
        'data': newData,
        'update': true,
      });
    }
    return false;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// 动态接口类
abstract class IActivity extends IEntity<XTarget> {
  /// 会话对象
  late ISession session;

  /// 是否允许发布
  late bool allPublish;

  /// 动态数据
  late List<IActivityMessage> activityList;
  late XCollection<ActivityType> coll;

  /// 发布动态
  Future<bool> send(
    String content,
    List<FileItemShare> resources,
    List<String> tags,
  );

  /// 加载动态
  Future<List<IActivityMessage>> load(int take, [String? beforeTime]);
}

/// 动态实现
class Activity extends Entity<XTarget> implements IActivity {
  Activity(this.metadata, this.session) : super(metadata, ['动态']) {
    if (session.target.id == session.sessionId) {
      coll = session.target.resource.genColl('resource-activity');
    } else {
      coll = XCollection<ActivityType>(
        metadata,
        'resource-activity',
        [metadata.id],
        [key],
      );
    }
    subscribeNotify();
  }
  @override
  final XTarget metadata;
  @override
  final ISession session;

  @override
  List<IActivityMessage> activityList = [];
  @override
  late XCollection<ActivityType> coll;

  @override
  bool get allPublish {
    return (session.target.id == session.sessionId &&
        session.target.hasRelationAuth());
  }

  @override
  Future<List<IActivityMessage>> load(int take, [String? beforeTime]) async {
    var data = await coll.load({
      take: take,
      "options": {
        "match": beforeTime != null
            ? {
                "createTime": {
                  "_lt_": beforeTime,
                },
              }
            : {},
        "sort": {
          "createTime": -1,
        },
      },
    });
    final messages = data.map((i) => ActivityMessage(i, this));
    activityList.addAll(messages);
    return activityList;
  }

  @override
  Future<bool> send(
    String content,
    List<FileItemShare> resources,
    List<String> tags,
  ) async {
    if (allPublish) {
      var data = await coll.insert(ActivityType(
        tags: tags,
        comments: [],
        content: content,
        resource: resources,
        typeName: MessageType.text.label,
        likes: [],
        forward: [],
        id: '',
      ));
      if (data != null) {
        await coll.notity(data, onlineOnly: false);
      }
      return data != null;
    }
    return false;
  }

  subscribeNotify() {
    // coll.subscribe([key], ({required bool update, required ActivityType data}) {
    //   if (update) {
    //     var index = activityList.indexWhere((i) => i.id == data.id);
    //     if (index > -1) {
    //       activityList[index].update(data);
    //     }
    //   } else {
    //     activityList = [ActivityMessage(data, this), ...activityList];
    //     changCallback();
    //   }
    // });
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
