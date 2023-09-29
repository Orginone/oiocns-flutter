import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/entity.dart';
import 'package:orginone/dart/core/public/collection.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/chat/session.dart';

/// 动态接口类
abstract class IActivity extends IEntity<XTarget> {
  /// 会话对象
  late ISession session;

  /// 是否允许发布
  late bool allPublish;

  /// 动态数据
  late List<ActivityType> activityList;

  /// 发布动态
  Future<bool> send(
    String content,
    List<FileItemShare> resources,
    List<String> tags,
  );

  /// 点赞
  Future<bool> like(ActivityType data);

  /// 评论
  Future<bool> comment(ActivityType data, String txt, String? replyTo);

  /// 加载动态
  Future<List<ActivityType>> load(int take, String? beforeTime);
}

/// 动态实现
class Activity extends Entity<XTarget> implements IActivity {
  @override
  late ISession session;
  @override
  late List<ActivityType> activityList;
  late XCollection<ActivityType> coll;

  Activity(XTarget metadata, ISession session) : super(metadata) {
    this.session = session;
    activityList = [];
    if (this.session.target.id == this.session.sessionId) {
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
  bool get allPublish {
    return (session.target.id == session.sessionId &&
        session.target.hasRelationAuth());
  }

  @override
  Future<List<ActivityType>> load(int take, [String? beforeTime]) async {
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
    activityList.addAll(data);
    return data;
  }

  @override
  Future<bool> like(ActivityType data) async {
    ActivityType? newData;
    if (data.likes.any((i) => i == userId)) {
      newData = await coll.update(data.id, {
        "_pull_": {"likes": userId},
      });
    } else {
      newData = await coll.update(data.id, {
        "_push_": {"likes": userId},
      });
    }
    if (newData != null) {
      return await coll.notity(newData);
    }
    return false;
  }

  @override
  Future<bool> comment(
    ActivityType data,
    String label,
    String? replyTo,
  ) async {
    var newData = await coll.update(data.id, {
      "_push_": {
        "comments": {
          "label": label,
          "userId": userId,
          "time": 'sysdate()',
          "replyTo": replyTo,
        } as CommentType,
      },
    });
    if (newData != null) {
      return await coll.notity(newData);
    }
    return false;
  }

  @override
  Future<bool> send(
    String content,
    List<FileItemShare> resources,
    List<String> tags,
  ) async {
    if (allPublish) {
      var data = await coll.insert({
        tags: tags,
        "comments": [],
        content: content,
        "resource": resources,
        "typeName": MessageType.text,
        "likes": [],
        "forward": [],
      } as ActivityType);
      if (data != null) {
        await coll.notity(data, onlineOnly: false);
      }
      return data != null;
    }
    return false;
  }

  subscribeNotify() {
    coll.subscribe(key, ({required bool update, required ActivityType data}) {
      if (update) {
        var index = activityList.indexWhere((i) => i.id == data.id);
        if (activityList.indexWhere((i) => i.id == data.id) > -1) {
          activityList[index] = data;
          changCallback();
        }
      } else {
        activityList = [data, ...activityList];
        changCallback();
      }
    });
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
