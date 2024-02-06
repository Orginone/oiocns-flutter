import 'package:orginone/dart/base/common/emitter.dart';
import 'package:orginone/dart/base/index.dart';
import 'package:orginone/dart/core/public/operates.dart';
import 'package:orginone/main_base.dart';
import 'package:uuid/uuid.dart';

import '../../base/model.dart';
import '../../base/schema.dart';

// ignore: non_constant_identifier_names
Map<String, dynamic> ShareIdSet = <String, dynamic>{};

abstract class IEntity<T> extends Emitter {
  //实体唯一键
  late String key;
  //唯一标识
  String get id;
  //实体名称
  String get name;
  //实体编号
  String get code;
  //实体类型
  String get typeName;
  //实体描述
  String get remark;
  // 最后变更时间
  String get updateTime;
  //数据实体
  T get metadata;
  //用户ID
  String get userId;
  //归属Id
  String get belongId;
  //共享信息
  ShareIcon get share;
  //创建人
  ShareIcon get creater;
  //变更人
  ShareIcon get updater;
  //归属
  ShareIcon get belong;
  // 分组标签
  List<String> get groupTags;

  //查找元数据
  T? findMetadata<T>(String id);
  //更新元数据
  void updateMetadata<T extends XEntity>(T data);

  ///对实体可进行操作
  ///@param mode 模式，默认为配置模式
  List<OperateModel> operates({int? mode});
}

///实体类实现
abstract class Entity<T extends XEntity> extends Emitter implements IEntity<T> {
  @override
  late String key;
  late List<String> _gtags;

  Entity(T metadata, List<String> gtags) : super() {
    this.key = const Uuid().v1();
    _metadata = metadata;
    _gtags = gtags;
    ShareIdSet[_metadata.id] = _metadata;
  }
  late T _metadata;
  @override
  String get id {
    return _metadata.id;
  }

  @override
  String get name {
    return metadata.name ?? '';
  }

  @override
  String get code {
    return metadata.code ?? '';
  }

  @override
  String get typeName {
    return metadata.typeName ?? '';
  }

  @override
  String get remark {
    return metadata.remark ?? '';
  }

  @override
  String get updateTime {
    return metadata.updateTime ?? '';
  }

  @override
  T get metadata {
    if (ShareIdSet.containsKey(_metadata.id)) {
      return ShareIdSet[_metadata.id];
    }
    return _metadata;
  }

  @override
  String get userId {
    return kernel.user?.id ?? '';
  }

  @override
  String get belongId {
    return _metadata.belongId!;
  }

  @override
  ShareIcon get share {
    return this.findShare(id);
  }

  @override
  ShareIcon get creater {
    return this.findShare(metadata.createUser ?? '');
  }

  @override
  ShareIcon get updater {
    return this.findShare(metadata.updateUser ?? '');
  }

  @override
  ShareIcon get belong {
    return findShare(metadata.belongId!);
  }

  @override
  List<String> get groupTags {
    // null!=_metadata["isDeleted"];
    // if (
    //   (_metadata.hasProperty('isDeleted') && _metadata.isDeleted === true) ||
    //   ('isDeleted' in this.metadata && this.metadata.isDeleted === true)
    // ) {
    //   return ['已删除'];
    // }
    if ((_metadata is XStandard && (_metadata as XStandard).isDeleted) ||
        (metadata is XStandard && (metadata as XStandard).isDeleted)) {
      return ['已删除'];
    }
    return this._gtags;
  }

  void setMetadata(T metadata) {
    if (metadata.id == id) {
      _metadata = metadata;
      ShareIdSet[id] = metadata;
      changCallback();
    }
  }

  @override
  U? findMetadata<U>(String id) {
    if (ShareIdSet.containsKey(id)) {
      return ShareIdSet[id] as U;
    }
    return null;
  }

  @override
  void updateMetadata<U extends XEntity>(U data) {
    ShareIdSet[data.id] = data;
  }

  void setEntity() {
    ShareIdSet['$id*'] = this;
  }

  U? getEntity<U>(String id) {
    return ShareIdSet['$id*'];
  }

  ShareIcon findShare(String id) {
    var metadata = this.findMetadata<XEntity>(id);
    ShareIcon shareIcon = ShareIcon(
        name: metadata?.name ?? '',
        typeName: metadata?.typeName ?? '未知',
        avatar: parseAvatar(metadata?.icon));
    return shareIcon;
  }

  //获取右键操作方法,暂时不实现

  @override
  List<OperateModel> operates({int? mode}) {
    return [
      OperateModel.fromJson(EntityOperates.remark.toJson()),
      OperateModel.fromJson(EntityOperates.qrcode.toJson()),
    ];
  }
}
