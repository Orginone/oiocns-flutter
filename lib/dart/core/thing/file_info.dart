import 'dart:convert';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/base/common/entity.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/images.dart';
import 'package:orginone/main.dart';

abstract class IFileInfo<T extends XEntity> {
  String get belongId;

  //是否为继承的类别
  bool get isInherited;

  late IDirectory directory;

  late T metadata;

  String get id;

  List<PopupMenuItem> get popupMenuItem;

  Future<bool> delete();

  //重命名
  Future<bool> rename(String name);

  //拷贝文件系统项（目录）
  Future<bool> copy(IDirectory destination);

  //移动文件系统项（目录）
  Future<bool> move(IDirectory destination);

  //加载文件内容
  Future<bool> loadContent({bool reload = false});
}

abstract class FileInfo<T extends XEntity> extends Entity
    implements IFileInfo<T> {
  @override
  late T metadata;

  @override
  late IDirectory directory;

  FileInfo(this.metadata, [IDirectory? directory]) {
    if (directory != null) {
      this.directory = directory;
    } else {
      this.directory = this as IDirectory;
    }
  }

  @override
  // TODO: implement isInherited
  bool get isInherited => metadata.belongId != this.directory.belongId;

  @override
  // TODO: implement belongId
  String get belongId => directory.metadata.belongId!;

  @override
  // TODO: implement id
  String get id => metadata.id!.replaceAll('_', '');

  @override
  Future<bool> loadContent({bool reload = false}) async {
    return await Future.delayed(Duration(milliseconds: reload ? 100 : 0));
  }
}

abstract class ISysFileInfo extends IFileInfo<XEntity> {
  late FileItemModel filedata;

  FileItemShare shareInfo();
}

XEntity fileToEntity(
  FileItemModel data,
  String belongId,
  XTarget? belong,
) {
  return XEntity(
    id: 'orginone/anydata/bucket/load/${data.shareLink}',
    name: data.name ?? "",
    code: data.key,
    icon: data.toJson().toString(),
    belongId: belongId,
    typeName: data.contentType ?? "",
    createTime: data.dateCreated?.toString() ?? "",
    updateTime: data.dateModified?.toString() ?? "",
    belong: belong,
    status: 0,
    createUser: '',
    updateUser: '',
    version: '',
    remark: '',
  );
}

class SysFileInfo extends FileInfo<XEntity> implements ISysFileInfo {
  SysFileInfo(this.filedata, IDirectory directory)
      : super(
            fileToEntity(filedata, directory.metadata.belongId!,
                directory.metadata.belong),
            directory) {}

  @override
  late FileItemModel filedata;

  @override
  Future<bool> copy(IDirectory destination) async {
    if (destination.id != directory.id) {
      final res = await kernel.anystore.bucketOpreate(
          belongId,
          BucketOpreateModel(
            key: formatKey(filedata.name ?? ""),
            destination: destination.id,
            operate: BucketOpreates.copy,
          ));
      if (res.success) {
        destination.files.add(this);
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> delete() async {
    final res = await kernel.anystore.bucketOpreate(
        belongId,
        BucketOpreateModel(
          key: formatKey(filedata.key),
          operate: BucketOpreates.delete,
        ));
    if (res.success) {
      directory.files.removeWhere((element) => element.id == id);
      return true;
    }
    return false;
  }

  @override
  Future<bool> move(IDirectory destination) async {
    if (destination.id != directory.id) {
      final res = await kernel.anystore.bucketOpreate(
          belongId,
          BucketOpreateModel(
            key: formatKey(filedata.key),
            destination: destination.id,
            operate: BucketOpreates.move,
          ));
      if (res.success) {
        directory.files.removeWhere((i) => i.id == id);
        directory = destination;
        destination.files.add(this);
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> rename(String name) async {
    if (metadata.name != name) {
      final res = await kernel.anystore.bucketOpreate(
          belongId,
          BucketOpreateModel(
            name: name,
            key: formatKey(filedata.key),
            operate: BucketOpreates.rename,
          ));
      if (res.success && res.data != null) {
        FileItemModel model = FileItemModel.fromJson(res.data!);
        filedata = model;
        return true;
      }
    }
    return false;
  }

  @override
  FileItemShare shareInfo() {
    return FileItemShare(
      size: filedata.size,
      name: filedata.name,
      extension: filedata.extension,
      shareLink:
          '${Constant.host}/orginone/anydata/bucket/load/${filedata.shareLink}',
      thumbnail: getThumbnail(),
    );
  }


  String getThumbnail(){
    String img = Images.otherIcon;
    String ext = filedata.extension?.toLowerCase()??"";
    if (ext == '.jpg' || ext == '.jpeg' || ext == '.png' || ext == '.webp') {
      return '${Constant.host}/orginone/anydata/bucket/load/${filedata.shareLink}';
    } else {
      switch (ext) {
        case "xlsx":
        case "xls":
        case "excel":
          img = Images.excelIcon;
          break;
        case "pdf":
          img = Images.pdfIcon;
          break;
        case "ppt":
          img = Images.pptIcon;
          break;
        case "docx":
        case "doc":
          img = Images.wordIcon;
          break;
        default:
          img = Images.otherIcon;
          break;
      }
    }
    return img;
  }

  String formatKey(String key) {
    return base64.encode(utf8.encode(key));
  }

  @override
  // TODO: implement popupMenuItem
  List<PopupMenuItem> get popupMenuItem {
    List<PopupMenuKey> key = [PopupMenuKey.rename, PopupMenuKey.delete];

    return key
        .map((e) => PopupMenuItem(
              value: e,
              child: Text(e.label),
            ))
        .toList();
  }
}
