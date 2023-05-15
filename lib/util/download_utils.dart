import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
String directory = '';

class DownloadModel {
  //文件名
  String name;

  //下载url
  String downloadUrl;

  //保存路径
  String? filePath;

  //文件类型
  String? type;

  DownloadModel({
    required this.name,
    this.type,
    required this.downloadUrl,
    this.filePath,
  });
}

class DownloadTaskInfo {
  final DownloadModel? downloadInfo;
  String? taskId;
  int progress;
  DownloadTaskStatus status;

  DownloadTaskInfo(
      {this.downloadInfo,
      this.taskId,
      this.progress = 0,
      this.status = DownloadTaskStatus.undefined});
}

class DownloadUtils {
  static final DownloadUtils _instance = DownloadUtils._();

  factory DownloadUtils() => _instance;

  DownloadUtils._();

  ReceivePort receivePort = ReceivePort();
  SendPort? sendPort;
  List<DownloadTaskInfo> cacheTasks = [];

  final StreamController<List<DownloadTaskInfo>> _streamController =
      StreamController.broadcast();

  Sink<List<DownloadTaskInfo>> get _sink => _streamController.sink;

  Stream<List<DownloadTaskInfo>> get _stream => _streamController.stream;

  Future<void> init() async {
    await FlutterDownloader.initialize(debug: true,ignoreSsl: true);
    await _loadAllDownloadTask();
    _bindBackgroundIsolate();
  }

  _loadAllDownloadTask() async {
    final tasks = await FlutterDownloader.loadTasks();
    if (tasks != null && tasks.isNotEmpty) {
      for (var element in tasks) {
        cacheTasks.add(
          DownloadTaskInfo(
            taskId: element.taskId,
            status: element.status,
            progress: element.progress,
            downloadInfo: DownloadModel(
              name: element.filename ?? "",
              downloadUrl: element.url,
              filePath: element.savedDir,
              type: ".${element.filename?.split('.').last}",
            ),
          ),
        );
      }
    }
  }

  void addTaskListen(void Function(List<DownloadTaskInfo> event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    _stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        receivePort.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    receivePort.listen((dynamic data) {
      String id = data[0];
      int statusIndex = data[1];
      int progress = data[2];
      if (cacheTasks.isNotEmpty) {
        final task = cacheTasks.firstWhere((task) => task.taskId == id);
        task.status = DownloadTaskStatus(statusIndex);
        task.progress = progress;
      }
      print("id===========$id");
      _sink.add(cacheTasks);
    });
    FlutterDownloader.registerCallback(_downloadCallback);
  }

  @pragma('vm:entry-point')
  static void _downloadCallback(
      String id, int status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  void unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  Future<String> _findLocalPath() async {
    String localPath = '';

    if (Platform.isAndroid) {
      localPath = "${(await getExternalStorageDirectory())!.path}/orginone";
    }
    if (Platform.isIOS) {
      localPath = "${(await getApplicationDocumentsDirectory()).path}/orginone";
    }

    final savedDir = Directory(localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      await savedDir.create();
    }

    return localPath;
  }

  Future<bool> _checkPermission() async {
    // 先对所在平台进行判断
    if (Platform.isAndroid) {
      PermissionStatus permission = await Permission.storage.status;
      if (permission != PermissionStatus.granted) {
        Map<Permission, PermissionStatus> request = await [
          Permission.storage,
          Permission.manageExternalStorage
        ].request();
        if (request[Permission.storage] == PermissionStatus.granted &&
            request[Permission.manageExternalStorage] ==
                PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  DownloadTaskInfo? findFile(String name) {
    DownloadTaskInfo? info;
    try {
      info = cacheTasks
          .firstWhere((element) => element.downloadInfo!.name == name);
      return info;
    } catch (e) {}

    return info;
  }

  Future save(DownloadModel model) async {
    bool existPermission = await _checkPermission();
    if (!existPermission) return;
    if (directory == '') {
      directory = await _findLocalPath();
    }

    DownloadTaskInfo download =
        DownloadTaskInfo(downloadInfo: model..filePath = directory);

    try {
      cacheTasks.firstWhere((element) =>
          element.downloadInfo!.name == download.downloadInfo!.name);
      ToastUtils.showMsg(msg: "文件已存在");
      return;
    } catch (e) {

    }

    download.taskId = await FlutterDownloader.enqueue(
        url: download.downloadInfo!.downloadUrl,
        fileName: download.downloadInfo!.name,
        savedDir: Platform.isAndroid
            ? download.downloadInfo!.filePath!
            : Uri.encodeFull(download.downloadInfo!.filePath!),
        saveInPublicStorage: true,
        openFileFromNotification: false);
    cacheTasks.add(download);
  }

  pauseDownload(DownloadTaskInfo info) async {
    if (info.taskId == null) return;
    FlutterDownloader.pause(taskId: info.taskId!);
    int i = cacheTasks.indexWhere((element) => element.taskId == info.taskId);
    if (i != -1) {
      cacheTasks[i] = info;
    }
  }

  pauseAllDownload(List<DownloadTaskInfo> info) async {
    for (var value in info) {
      if (value.taskId == null) return;
      await FlutterDownloader.pause(taskId: value.taskId!);
      int i =
          cacheTasks.indexWhere((element) => element.taskId == value.taskId);
      if (i != -1) {
        cacheTasks[i] = value;
      }
    }
  }

  resumeAllDownload(List<DownloadTaskInfo> info) async {
    for (var value in info) {
      if (value.taskId == null) return;
      String? id = await FlutterDownloader.resume(taskId: value.taskId!);
      int i =
          cacheTasks.indexWhere((element) => element.taskId == value.taskId);
      if (i != -1) {
        cacheTasks[i] = value..taskId = id;
      }
    }
  }

  resumeDownload(DownloadTaskInfo info) async {
    if (info.taskId == null) return;
    String? id = await FlutterDownloader.resume(taskId: info.taskId!);
    int i = cacheTasks.indexWhere((element) => element.taskId == info.taskId);
    if (i != -1) {
      cacheTasks[i] = info..taskId = id;
    }
  }

  removeDownload(DownloadTaskInfo info) {
    if (info.taskId == null) return;
    FlutterDownloader.remove(taskId: info.taskId!, shouldDeleteContent: true);
    cacheTasks.removeWhere((element) => element.taskId == info.taskId);
    _sink.add(cacheTasks);
  }

  removeAllDownload(List<DownloadTaskInfo> info) {
    for (var value in info) {
      if (value.taskId == null) return;
      FlutterDownloader.remove(
          taskId: value.taskId!, shouldDeleteContent: true);
      cacheTasks.removeWhere((element) => element.taskId == value.taskId);
    }
    _sink.add(cacheTasks);
  }

  cancelDownload(DownloadTaskInfo info) {
    if (info.taskId == null) return;
    FlutterDownloader.cancel(taskId: info.taskId!);
    cacheTasks.removeWhere((element) => element.taskId == info.taskId);
  }

  cancelAll() async {
    FlutterDownloader.cancelAll().then((value) {
      cacheTasks.clear();
    });
  }

  open(DownloadTaskInfo info) async{
    if (info.taskId == null) return;
    if (!await FlutterDownloader.open(taskId: info.taskId!)) {
      await OpenFile.open(
          "${info.downloadInfo!.filePath}/${info.downloadInfo!.name}");
    }
  }
}

String getFileSize(limit) {
  String size = "";
  //内存转换
  if (limit < 0.1 * 1024) {
    //小于0.1KB，则转化成B
    size = limit.toString();
    size = size.length > 4
        ? "${size.substring(0, size.indexOf(".") + 3)}B"
        : "${size}B";
    return size;
  } else if (limit < 0.1 * 1024 * 1024) {
    //小于0.1MB，则转化成KB
    size = (limit / 1024).toString();
    size = size.length > 4
        ? "${size.substring(0, size.indexOf(".") + 3)}KB"
        : "${size}KB";
    return size;
  } else if (limit < 0.1 * 1024 * 1024 * 1024) {
    //小于0.1GB，则转化成MB
    size = (limit / (1024 * 1024)).toString();
    size = size.length > 4
        ? "${size.substring(0, size.indexOf(".") + 3)}MB"
        : "${size}MB";
    return size;
  } else {
    //其他转化成GB
    size = (limit / (1024 * 1024 * 1024)).toString();
    size = size.length > 4
        ? "${size.substring(0, size.indexOf(".") + 3)}GB"
        : "${size}GB";
    return size;
  }
  return size;
}
