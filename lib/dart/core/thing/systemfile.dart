import 'dart:io';

import 'package:orginone/common/values/images.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/base/common/format.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/thing/directory.dart';

import 'package:orginone/dart/core/thing/fileinfo.dart';
import 'package:orginone/main.dart';
import 'package:orginone/utils/index.dart';

/// 系统文件接口
abstract class ISysFileInfo extends IFileInfo<XEntity> {
  /// 文件系统项对应的目标
  late FileItemModel filedata;

  /// 分享信息
  FileItemShare shareInfo();
}

/// 文件转实体
XEntity fileToEntity(
  FileItemModel data,
  String belongId,
  XTarget? belong,
) {
  return XEntity(
    id: data.shareLink!.substring(1),
    name: data.name,
    code: data.key,
    icon: data.toJson().toString(),
    belongId: belongId,
    typeName: data.contentType,
    createTime: data.dateCreated,
    updateTime: data.dateModified,
    belong: belong,
  );
}

/// 文件类实现
class SysFileInfo extends FileInfo<XEntity> implements ISysFileInfo {
  SysFileInfo(FileItemModel metadata, IDirectory directory)
      : filedata = metadata,
        super(
          fileToEntity(metadata, directory.metadata.belongId!,
              directory.metadata.belong),
          directory,
        );

  @override
  String get cacheFlag => 'files';

  @override
  FileItemModel filedata;
  @override
  List<String> get groupTags {
    List<String> gtags = [];
    if (typeName.startsWith('image')) {
      gtags.add('图片');
    } else if (typeName.startsWith('video')) {
      gtags.add('视频');
    } else if (typeName.startsWith('text')) {
      gtags.add('文本');
    } else if (typeName.contains('pdf')) {
      gtags.add('PDF');
    } else if (typeName.contains('office')) {
      gtags.add('Office');
    }
    return [...gtags, '文件'];
  }

  @override
  FileItemShare shareInfo() {
    return FileItemShare(
      size: filedata.size,
      name: filedata.name,
      extension: filedata.extension,
      contentType: filedata.contentType,
      shareLink: filedata.shareLink,
      poster: filedata.poster,
      // thumbnail: filedata.thumbnail,
      // shareLink: '${Constant.host}${filedata.shareLink}',
      thumbnail: getThumbnail(),
    );
  }

  deialImage() {
    dynamic link = filedata.shareLink ?? '';
    dynamic thumbnail = filedata.thumbnailUint8List;
    // TODO 待处理小的预览图
    if (thumbnail != null) {
      link = thumbnail;
    } else if (!link.startsWith('/orginone/kernel/load/')) {
      link = File(link);
    } else {
      link = '${Constant.host}$link';
    }

    Map<String, String> headers = {
      "Authorization": kernel.accessToken,
    };
    // LogUtil.d('ImageDetail');
    // LogUtil.d(link);
    // Widget child = ImageWidget(link, httpHeaders: headers);
  }

  String getThumbnail() {
    String img = AssetsImages.otherIcon;
    String ext = filedata.extension?.toLowerCase() ?? "";
    if (FileUtils.isImage(ext)) {
      return filedata.thumbnail ?? '${Constant.host}${filedata.shareLink}';
    } else {
      switch (ext) {
        case ".xlsx":
        case ".xls":
        case ".excel":
          img = AssetsImages.excelIcon;
          break;
        case ".pdf":
          img = AssetsImages.pdfIcon;
          break;
        case ".ppt":
          img = AssetsImages.pptIcon;
          break;
        case ".docx":
        case ".doc":
          img = AssetsImages.wordIcon;
          break;
        default:
          img = AssetsImages.otherIcon;
          break;
      }
    }
    return img;
  }

  @override
  Future<bool> rename(String name) async {
    if (filedata.name != name) {
      final res = await directory.resource
          .bucketOpreate<FileItemModel>(BucketOpreateModel(
        name: name,
        key: encodeKey(filedata.key),
        operate: BucketOpreates.rename,
      ));
      if (res.success && res.data != null) {
        filedata = res.data!;
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> delete({bool? notity}) async {
    final res = await directory.resource.bucketOpreate<List<FileItemModel>>(
      BucketOpreateModel(
        key: encodeKey(filedata.key),
        operate: BucketOpreates.delete,
      ),
    );
    if (res.success) {
      directory.notifyReloadFiles();
      directory.files.removeWhere((i) => i.key != key);
    }
    return res.success;
  }

  @override
  Future<bool> hardDelete({bool? notity}) async {
    return await delete();
  }

  @override
  Future<bool> copy(IDirectory destination) async {
    if (destination.id != directory.id) {
      final res = await directory.resource.bucketOpreate<List<FileItemModel>>(
        BucketOpreateModel(
          key: encodeKey(filedata.key),
          destination: destination.id,
          operate: BucketOpreates.copy,
        ),
      );
      if (res.success) {
        destination.files.add(this);
      }
      return res.success;
    }
    return false;
  }

  @override
  Future<bool> move(IDirectory destination) async {
    if (destination.id != directory.id) {
      final res = await directory.resource.bucketOpreate<List<FileItemModel>>(
        BucketOpreateModel(
          key: encodeKey(filedata.key),
          destination: destination.id,
          operate: BucketOpreates.move,
        ),
      );
      if (res.success) {
        directory.files.removeWhere((i) => i.key == key);
        directory = destination;
        destination.files.add(this);
      }
      return res.success;
    }
    return false;
  }

  @override
  List<OperateModel> operates({int? mode}) {
    final operates = super.operates();
    return operates.where((i) => i.cmd != 'update').toList();
  }

  @override
  List<IFile> content({bool? args}) {
    return [];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
