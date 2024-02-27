// import 'package:orginone/dart/base/common/emitter.dart';
// import 'package:orginone/dart/base/model.dart';
// import 'package:orginone/dart/base/schema.dart';
// import 'package:orginone/dart/core/public/enums.dart';
// import 'package:orginone/dart/core/target/base/target.dart';
// import 'package:orginone/dart/core/thing/directory.dart';
// import 'package:orginone/dart/core/thing/fileinfo.dart';
// import 'package:orginone/dart/core/thing/resource.dart';
// import 'package:orginone/dart/core/thing/standard/storeStandard.dart';
// import 'package:orginone/dart/core/thing/systemfile.dart';

// /// 可为空的进度回调
// typedef OnProgress = void Function(double p);

// /// 目录接口类
// abstract class IStandardDirectory implements IStandardFileInfo<XDirectory> {
//   /// 目录下支持的标准类
//   late List<DirectoryType> accept;

//   /// 当前加载目录的用户
//   late ITarget target;

//   /// 资源类
//   late DataResource resource;

//   /// 上级目录
//   IDirectory? parent;

//   /// 任务发射器
//   late Emitter taskEmitter;

//   /// 是否可进入下级
//   bool get canIinit;

//   /// 目录下的内容
//   @override
//   List<IFileInfo<XEntity>> content({bool store = true, bool isSidebar = true});

//   /// 目录下的文件
//   late List<ISysFileInfo> files;

//   /// 搜索文件
//   Future<IFileInfo<XEntity>?> searchFile(
//     String directoryId,
//     String applicationId,
//     String id,
//   );

//   // IStandardDirectory(this.target, this.parent, {this.canIinit = false});
// }

// /// 目录实现类
// class StandardDirectory extends Directory implements IStandardDirectory {
//   StandardDirectory(
//       StandardDirectoryType _metadata, ITarget _target, IDirectory _parent)
//       : super(
//           _metadata,
//           _target,
//           parent: _parent,
//         ) {
//     accept = _metadata.accept ??
//         (null != _metadata.name
//             ? [DirectoryType.getType(_metadata.name!)]
//             : []);
//     taskEmitter = Emitter();
//     parent = _parent;
//     _children = _metadata.children?.map((child) {
//           return StandardDirectory(child, _target, this);
//         }).toList() ??
//         [];
//     standard = StandardFiles(_target.directory);
//   }
//   @override
//   IDirectory? parent;
//   @override
//   late List<DirectoryType> accept;
//   @override
//   late Emitter taskEmitter;
//   @override
//   List<ISysFileInfo> files = [];
//   List<StandardDirectory> _children;
//   @override
//   List<IDirectory> get children => _children;

//   @override
//   late StandardFiles standard;
//   @override
//   bool get isContainer {
//     return true;
//   }

//   @override
//   String get cacheFlag {
//     return 'directorys';
//   }

//   @override
//   IFileInfo<XEntity> get superior {
//     return parent ?? target.superior.directory;
//   }

//   @override
//   List<String> get groupTags {
//     if (null != parent) {
//       return super.groupTags;
//     } else {
//       return [target.typeName];
//     }
//   }

//   @override
//   String get spaceKey {
//     return target.space?.directory.key ?? "";
//   }

//   String get directoryId {
//     if (null != metadata.sourceId && metadata.sourceId!.isNotEmpty) {
//       return metadata.sourceId ?? "";
//     }
//     return id;
//   }

//   @override
//   bool get isInherited {
//     return target.isInherited;
//   }

//   @override
//   bool get canIinit {
//     return children.isNotEmpty;
//   }

//   @override
//   String get locationKey {
//     return key;
//   }

//   @override
//   DataResource get resource {
//     return target.resource;
//   }

//   @override
//   Future<bool> loadContent({bool reload = false}) async {
//     await standard.loadStandardFiles(reload: reload, accept: accept);
//     files = [];
//     if (accept.length == 1) {
//       switch (accept[0]) {
//         case DirectoryType.App:
//           files.addAll(standard.applications);
//           break;
//         case DirectoryType.Species:
//         case DirectoryType.Dict:
//           files.addAll(standard.specieses);
//           break;
//         case DirectoryType.File:
//           await loadFiles(reload: reload);
//           break;
//         case DirectoryType.Attribute:
//           files.addAll(standard.propertys);
//           break;
//         case DirectoryType.Transfer:
//           files.addAll(standard.transfers);
//           break;
//         case DirectoryType.PageTemplate:
//           files.addAll(standard.templates);
//           break;
//         case DirectoryType.Form:
//           files.addAll(standard.forms);
//           break;
//         case DirectoryType.Report:
//           // this.files.push(...this.standard.report);
//           break;
//         default:
//           break;
//       }
//     }
//     return true;
//   }

//   @override
//   List<IFileInfo<XEntity>> content({bool store = true, bool isSidebar = true}) {
//     if (!store) {
//       return [];
//     }
//     if (isSidebar) {
//       return children;
//     } else {
//       if (accept.length == 1) {
//         return files;
//       }
//       return [];
//     }
//   }

//   @override
//   Future<List<ISysFileInfo>> loadFiles({bool? reload = false}) async {
//     if (files.isEmpty || reload!) {
//       // DataResource resource = parent?.superior.resource;
//       // //TODO:调试未完成: 如何查询单位下的 所有文件
//       // var res =
//       //     await resource.bucketOpreate<List<FileItemModel>>(BucketOpreateModel(
//       //   key: encodeKey(resource.belongId),
//       //   belongId: resource.belongId,
//       //   operate: BucketOpreates.List,
//       // ));
//       // if (res.success) {
//       //   files = res.data?.map<ISysFileInfo>((item) {
//       //         return SysFileInfo(item, this);
//       //       }).toList() ??
//       //       [];
//       // }
//     }
//     return files;
//   }

//   @override
//   Future<bool> copy(IDirectory destination) async {
//     return false;
//   }

//   @override
//   Future<bool> move(IDirectory destination) async {
//     return false;
//   }

//   @override
//   List<OperateModel> operates() {
//     List<OperateModel> operates = [];
//     operates.addAll([...getDirectoryNew(accept), directoryOperates.Refesh]);
//     if (target.hasRelationAuth()) {
//       if (target.user?.copyFiles.isNotEmpty ?? false) {
//         operates.addAll(fileOperates.Parse);
//       }
//     }
//     if (null != parent) {
//       if (target.hasRelationAuth()) {
//         operates.addAll(directoryOperates.Shortcut);
//       }
//       // operates.push(...super.operates());
//     } else {
//       operates.addAll(entityOperates.Open);
//     }
//     return operates;
//   }

//   @override
//   Future<IFileInfo<XEntity>?> searchFile(
//     String directoryId,
//     String applicationId,
//     String id,
//   ) async {
//     return null;
//   }

//   @override
//   Future<bool> notifyReloadFiles() async {
//     metadata.directoryId = id;
//     return await notify('reloadFiles', [metadata]);
//   }
// }
