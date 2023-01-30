import 'dart:io';

import 'package:get/get.dart';
import 'package:orginone/core/base/model/model.dart';
import 'package:orginone/controller/Emitter.dart';
import 'package:orginone/core/store/file_system_impl.dart';

import '../../dart/store/i_file_system.dart';

class TaskModel {
  String? group;
  String? name;
  int size = 0;
  int finished = 0;
  DateTime? createTime;

  TaskModel(this.name, this.group, this.size, this.finished, this.createTime);
}

class DocsController extends Emitter {
  static String? _curKey;
  IFileSystemItem? _home;
  static IFileSystemItem? _root;
  List<TaskModel>? _taskList;

  DocsController._();
  static DocsController? _instance;



  // 单例模式固定格式
  static DocsController getInstance() {
      _root = rootDir;
      _curKey = _root?.key;
    _instance ??= DocsController._();
    return _instance!;
  }

  // static final DocsController _instance = DocsController._instance();
  //
  // DocsController._instance();
  //
  // factory DocsController() {
  //   _root = rootDir;
  //   _curKey = _root?.key;
  //   return _instance;
  // }

  /// 根目录
  IFileSystemItem? root() {
    return _root;
  }

  /// 主目录
  IFileSystemItem? home() {
    return _home;
  }

  void setHome(IFileSystemItem? home){
    _home = home;
  }

  /// 当前目录
  IFileSystemItem? current() {
    return refItem(_curKey ?? "");
  }

  /// 任务列表
  List<TaskModel>? _taskList1() {
    return _taskList;
  }

  /// 根据key查找节点
  /// @param key 唯一标识
  IFileSystemItem? refItem(String key) {
    return _search(_root!, key);
  }

  /// 返回上一级
  backup() {
    if (current() != null && current()!.parent != null) {
      _curKey = current()!.parent!.key;
      changCallback();
    }
  }

  /// 打开文件系统项
  /// @param key 唯一标识
  Future open(String key) async {
    var item = refItem(key);
    if (item != null) {
      if (item.target.isDirectory) {
        await item.loadChildren(false);
        _curKey = item.key;
        changCallback();
      }
    }
  }

  /// 上传文件
  /// @param key 上传的位置唯一标识
  /// @param name 文件名
  /// @param file 文件内容
  /// @returns 文件对象
  Future<IFileSystemItem?> upload(String key, String name, File file,
      Function(DocsController, List<TaskModel>) callback) async {
    var item = refItem(key);
    if (item != null) {
      var size = await file.length();
      var task = TaskModel(name, item.name, size, 0, DateTime.now());
      var name1 = await item.upload(
          name: name,
          file: file,
          onProgress: (p) {
            task.finished = p.toInt();
            callback.call(this, [task]);
            if (p == 0) {
              _taskList?.add(task);
            } else if (p == file.length()) {
              changCallback();
            }
            changCallbackPart('taskList');
          });
      return name1;
    }
    return null;
  }

  /// 树结构搜索
  /// @param item 文件系统项
  /// @param key 唯一标识
  /// @returns
  IFileSystemItem? _search(IFileSystemItem item, String key) {
    if (item.key == key) {
      return item;
    }
    for (var element in item.children) {
      var res = _search(element, key);
      if (res != null) {
        return res;
      }
    }
    return null;
  }
}

FileSystemItem rootDir = FileSystemItem(
    target: FileItemModel(
        size: 0,
        name: "根目录",
        shareLink: '',
        extension: '',
        thumbnail: '',
        key: '',
        dateCreated: DateTime.now(),
        dateModified: DateTime.now(),
        contentType: '',
        isDirectory: true));
