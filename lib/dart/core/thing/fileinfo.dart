import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/base/common/entity.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/collection.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/images.dart';
import 'package:orginone/main.dart';

abstract class IFileInfo<T extends XEntity> {
  String get belongId;

  late bool isLoaded;

  //是否为继承的类别
  bool get isInherited;

  late IDirectory directory;

  late T metadata;

  String get id;

  String get locationKey;

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

  List<IFileInfo<XEntity>> content(int mode);
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
  String get id => metadata.id.replaceAll('_', '');

  @override
  Future<bool> loadContent({bool reload = false}) async {
    return reload;
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
    typeName: "文件",
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
            directory);

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

  String getThumbnail() {
    String img = Images.otherIcon;
    String ext = filedata.extension?.toLowerCase() ?? "";
    if (ext == '.jpg' || ext == '.jpeg' || ext == '.png' || ext == '.webp') {
      return '${Constant.host}/orginone/anydata/bucket/load/${filedata.shareLink}';
    } else {
      switch (ext) {
        case ".xlsx":
        case ".xls":
        case ".excel":
          img = Images.excelIcon;
          break;
        case ".pdf":
          img = Images.pdfIcon;
          break;
        case ".ppt":
          img = Images.pptIcon;
          break;
        case ".docx":
        case ".doc":
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

  @override
  bool isLoaded = false;

  @override
  List<IFileInfo<XEntity>> content(int mode) {
    return [];
  }

  @override
  // TODO: implement locationKey
  String get locationKey => directory.key;

  @override
  Future<bool> loadApplication({bool reload = false}) {
    // TODO: implement loadApplication
    throw UnimplementedError();
  }
}

abstract class IStandardFileInfo<T extends XStandard> extends IFileInfo<T> {
  /// 变更通知
  Future<bool> notify(String operate, List<XEntity> data);

  /// 更新
  Future<bool> update(T data);
}

class StandardFileInfo<T extends XStandard> extends FileInfo<T>
    implements IStandardFileInfo<T> {
  XCollection<T> coll;
  @override
  late bool isLoaded;

  StandardFileInfo(
    T _metadata,
    IDirectory _directory,
    XCollection<T> _coll,
  )   : coll = _coll,
        super(_metadata, _directory);
  @override
  Future<bool> copy(IDirectory destination) {
    // TODO: implement copy
    throw UnimplementedError();
  }

  @override
  Future<bool> move(IDirectory destination) {
    // TODO: implement move
    throw UnimplementedError();
  }

  @override
  T get metadata {
    throw UnimplementedError();
// return  _metadata;
  }

  bool allowCopy(IDirectory destination) {
    return directory.target.belongId != destination.target.belongId;
  }

  bool allowMove(IDirectory destination) {
    return (destination.id != directory.id &&
        destination.target.belongId == directory.target.belongId);
  }

  @override
  Future<bool> update(T data) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  List<IFileInfo<XEntity>> content(int mode) {
    // TODO: implement content
    throw UnimplementedError();
  }

  @override
  Future<bool> delete() {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<bool> rename(String name) {
    // TODO: implement rename
    throw UnimplementedError();
  }

  Future<bool> copyTo(String directoryId, {XCollection<T>? coll}) async {
    coll = coll ?? this.coll;
    // const data = await coll.replace({
    //   ...metadata,
    //   directoryId: directoryId,
    // });
    // if (data) {
    //   return await coll.notity({
    //     data: [data],
    //     operate: 'insert',
    //   });
    // }
    return false;
  }

  //  async moveTo(directoryId = string, coll = XCollection<T> = coll): Promise<boolean> {
  //   // const data = await coll.replace({
  //   //   ...metadata,
  //   //   directoryId: directoryId,
  //   // });
  //   // if (data) {
  //   //   await this.notify('delete', [this.metadata]);
  //   //   return await coll.notity({
  //   //     data: [data],
  //   //     operate: 'insert',
  //   //   });
  //   // }
  //   return false;
  // }
  @override
  // TODO: implement locationKey
  String get locationKey => throw UnimplementedError();

  @override
  Future<bool> notify(String operate, List<XEntity> data) async {
    return await coll.notity(data, targetId: operate);
  }

  @override
  // TODO: implement popupMenuItem
  List<PopupMenuItem> get popupMenuItem => throw UnimplementedError();
}
