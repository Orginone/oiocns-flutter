import 'dart:io';

import 'package:orginone/dart/base/model.dart';

/// 可为空的文件系统
typedef IObjectItem = IFileSystemItem;

/// 可为空的进度回调
typedef OnProgressType = Function(double progress); //function signature

/// 任务模型
abstract class TaskModel {
  String? group;
  String? name;
  double? size;
  double? finished;
  DateTime? createTime;

  //构造方法
  TaskModel({
    this.group,
    this.name,
    this.size,
    this.finished,
    this.createTime,
  });
}

/// 文件系统项接口
abstract class IFileSystemItem {
  /// 主键,唯一
  String? key;

  /// 名称
  String? name;

  /// 是否为根路径
  bool? isRoot;

  /// 文件系统项对应的目标
  FileItemModel? target;

  /// 上级文件系统项
  IObjectItem? parent;

  /// 下级文件系统项数组
  List<IFileSystemItem>? children;

  /// 下级文件系统数据
  List<FileItemModel>? childrenData;

  /// 上传任务列表
  List<TaskModel>? taskList;

  /// 分享信息
  FileItemShare shareInfo();

  /// 创建文件系统项（目录）
  /// @param name 文件系统项名称
  Future<IObjectItem> create(String name);

  /// 删除文件系统项（目录）
  Future<bool> delete();

  /// 重命名
  /// @param name 新名称
  Future<bool> rename(String name);

  /// 拷贝文件系统项（目录）
  /// @param {IFileSystemItem} destination 目标文件系统
  Future<bool> copy(IFileSystemItem destination);

  /// 移动文件系统项（目录）
  /// @param {IFileSystemItem} destination 目标文件系统
  Future<bool> move(IFileSystemItem destination);

  /// 加载下级文件系统项数组
  /// @param {boolean} reload 重新加载,默认false
  Future<bool> loadChildren({bool? reload});

  /// 上传文件
  /// @param name 文件名
  /// @param id 唯一id
  /// @param file 文件内容
  /// @param {OnProgressType} onProgress 进度回调
  Future<IObjectItem> upload(String name, File file, OnProgressType onProgress);

  /// 下载文件
  /// @param path 下载保存路径
  /// @param onProgress 进度回调
  Future<void> download(String path, OnProgressType onProgress);
}
