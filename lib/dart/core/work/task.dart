import 'dart:convert';

import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/user.dart';
import 'package:orginone/main.dart';

abstract class IWorkTask {
  late UserProvider user;

  IBelong get belong;

  late XWorkTask metadata;
  XWorkInstance? instance;
  InstanceDataModel? instanceData;

  List<XTarget> get targets;

  bool isMatch(String filter);

  Future<bool> updated(XWorkTask metadata);

  Future<bool> loadInstance({bool reload = false});

  Future<bool> recallApply();

  Future<bool> approvalTask(int status, {String? comment});
}

class WorkTask implements IWorkTask {
  WorkTask(this.metadata, this.user);

  @override
  XWorkInstance? instance;

  @override
  InstanceDataModel? instanceData;

  @override
  late XWorkTask metadata;

  @override
  late UserProvider user;

  @override
  Future<bool> approvalTask(int status, {String? comment}) async {
    if (metadata.status < TaskStatus.approvalStart.status) {
      if (status == -1) {
        return await recallApply();
      }
      if (metadata.taskType == '加用户' || await loadInstance(reload: true)) {
        final res = await kernel.approvalTask(ApprovalTaskReq(
          id: metadata.id,
          status: status,
          comment: comment,
          data:
              instanceData != null ? jsonEncode(instanceData!.toJson()) : null,
        ));
        if (res.data && status < TaskStatus.refuseStart.status) {
          if (targets.length == 2) {
            for (final item in user.targets) {
              if (item.id == targets[1].id) {
                item.pullMembers([targets[0]]);
              }
            }
          }
        }
      }
    }
    return false;
  }

  @override
  bool isMatch(String filter) {
    return jsonEncode(metadata.toJson()).contains(filter);
  }

  @override
  Future<bool> loadInstance({bool reload = false}) async {
    if (instanceData != null && !reload) return true;
    var res = await kernel.anystore.aggregate(
      StoreCollName.workInstance,
      {
        "match": {
          "id": metadata.instanceId,
        },
        "limit": 1,
        "lookup": {
          "from": StoreCollName.workTask,
          "localField": 'id',
          "foreignField": 'instanceId',
          "as": 'tasks',
        },
      },
      metadata.belongId,
    );

    if (res.data != null && res.data.length > 0) {
      try {
        instance = XWorkInstance.fromJson(res.data[0]);
        instanceData = instance != null
            ? InstanceDataModel.fromJson(jsonDecode(instance!.data ?? ""))
            : null;
        return instanceData != null;
      } catch (ex) {
        print(ex);
      }
    }
    return false;
  }

  @override
  Future<bool> recallApply() async {
    if (await loadInstance() && instance != null) {
      if (instance?.createUser == belong.userId) {
        if ((await kernel.recallWorkInstance(IdReq(id: instance!.id!))).success) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Future<bool> updated(XWorkTask metadata) async{
    if (this.metadata.id == metadata.id) {
      this.metadata = metadata;
      await loadInstance(reload: true);
      return true;
    }
    return false;
  }

  @override
  // TODO: implement belong
  IBelong get belong {
    for (final company in user.user!.companys) {
      if (company.id == metadata.belongId) {
        return company;
      }
    }
    return user.user!;
  }

  @override
  // TODO: implement targets
  List<XTarget> get targets {
    if (metadata.taskType == '加用户') {
      try {
        final parsedContent = jsonDecode(metadata.content) as List<dynamic>;
        return parsedContent.map((item) => XTarget.fromJson(item)).toList();
      } catch (ex) {
        return [];
      }
    }
    return [];
  }
}
