
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/base/species.dart';

import 'filesystem.dart';

class TaskModel {
  String? group;
  String? name;
  int? size;
  int? finished;
  DateTime? createTime;

  TaskModel({
    this.group,
    this.name,
    this.size,
    this.finished,
    this.createTime,
  });
}


typedef TaskChangeNotify = Function(List<TaskModel> taskList);

/// 文件系统接口
abstract class IFileSystem{

  late IBelong belong;

  /// 主目录
  IFileSystemItem? home;

  /// 上传任务列表
  late List<TaskModel> taskList;

  /// 任务变更通知
  void onTaskChange(void Function(List<TaskModel>) callback);

  /// 禁用通知
  void unTaskChange();

  /// 任务变更
  void taskChanged(String id, TaskModel task);
}

class FileSystem  implements IFileSystem{
  FileSystem(this.belong){
    taskList = [];
    home = FileSystemItem(this, FileItemModel(
      size: 0,
      key: '',
      name: '根目录',
      isDirectory: true,
      dateCreated: DateTime.now(),
      dateModified: DateTime.now(),
      hasSubDirectories: true, contentType: '',
    ));
  }

  Map<String, TaskModel> _taskIdSet = {};

  TaskChangeNotify? taskChangeNotify;
  @override
  IFileSystemItem? home;

  @override
  late List<TaskModel> taskList;

  @override
  void onTaskChange(TaskChangeNotify callback) {
    taskChangeNotify = callback;
    callback(taskList);
  }

  @override
  void taskChanged(String id, TaskModel task) {
    _taskIdSet[id] = task;
    taskChangeNotify?.call(taskList);
  }

  @override
  void unTaskChange() {
    taskChangeNotify = null;
  }


  @override
  late IBelong belong;
}
