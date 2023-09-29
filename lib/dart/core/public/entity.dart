import 'package:orginone/dart/base/common/emitter.dart';
import 'package:orginone/dart/base/index.dart';
import 'package:orginone/dart/core/public/operates.dart';
import 'package:orginone/main.dart';

import '../../base/model.dart';
import '../../base/schema.dart';

Map<String, dynamic> shareIdSet = <String, dynamic>{};

abstract class IEntity<T> extends Emitter {
  //实体唯一键
  late String key;
  //唯一标识
  @override
  late String id;
  //实体名称
  late String name;
  //实体编号
  late String code;
  //实体类型
  late String typeName;
  //实体描述
  late String remark;
  //数据实体
  late dynamic metadata;
  //用户ID
  late String userId;
  //归属Id
  late String belongId;
  //共享信息
  late ShareIcon share;
  //创建人
  late ShareIcon creater;
  //变更人
  late ShareIcon updater;
  //归属
  late ShareIcon belong;
  //查找元数据
  //U findMetadata<U>(String id) {}
  //更新元数据
  void updateMetadata<U extends XEntity>(U data);

  ///对实体可进行操作
  ///@param mode 模式，默认为配置模式
  List<OperateModel> operates({int? mode});
}

///实体类实现
abstract class Entity<T extends XEntity> extends Emitter implements IEntity<T> {
  late dynamic _metadata;
  @override
  late String key;

  Entity(T metadata) {
    this.key = super.id;
    this._metadata = metadata;
    shareIdSet[metadata.id] = metadata;
  }

  @override
  String get id {
    return this._metadata.id;
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
  T get metadata {
    if (shareIdSet.containsKey(this._metadata.id)) {
      return shareIdSet.values as T;
    }
    return this._metadata;
  }

  @override
  String get userId {
    return kernel.userId;
  }

  @override
  String get belongId {
    return this._metadata.belongId;
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

  void setMetadata(T metadata) {
    if (metadata.id == id) {
      this.metadata = metadata;
      shareIdSet[id] = metadata;
      changCallback();
    }
  }

  T? findMetadata<T>(String id) {
    if (shareIdSet.containsKey(id)) {
      return shareIdSet.values as T;
    }
    return null;
  }

  @override
  void updateMetadata<U extends XEntity>(U data) {
    shareIdSet[data.id] = data;
  }

  void setEntity() {
    shareIdSet['$id*'] = this;
  }

  U? getEntity<U>(String id) {
    return shareIdSet['$id*'];
  }

  ShareIcon findShare(String id) {
    var metadata = this.findMetadata<XTarget>(id);
    ShareIcon shareIcon = ShareIcon(
        name: metadata?.name ?? '加载中...',
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
