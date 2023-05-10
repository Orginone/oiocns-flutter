
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




/// 文件系统接口
abstract class IFileSystem extends ISpeciesItem {
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

class FileSystem extends SpeciesItem implements IFileSystem{
  FileSystem(super.metadata, super.current){
    taskList = [];
  }

  @override
  IFileSystemItem? home;

  @override
  late List<TaskModel> taskList;

  @override
  void onTaskChange(void Function(List<TaskModel> p1) callback) {
    // TODO: implement onTaskChange
  }

  @override
  void taskChanged(String id, TaskModel task) {
    // TODO: implement taskChanged
  }

  @override
  void unTaskChange() {
    // TODO: implement unTaskChange
  }

}
