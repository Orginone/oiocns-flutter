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
  late T metadata;
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
  T metadata;
  @override
  late String key;

  Entity(this.metadata) : super() {
    this.key = super.id;

    shareIdSet[metadata.id] = metadata;
  }

  @override
  String get id {
    return _metadata.id;
  }

  @override
  String get name {
    return _metadata.name ?? '';
  }

  @override
  String get code {
    return _metadata.code ?? '';
  }

  @override
  String get typeName {
    return _metadata.typeName ?? '';
  }

  @override
  String get remark {
    return _metadata.remark ?? '';
  }

  T get _metadata {
    if (shareIdSet.containsKey(metadata.id)) {
      return shareIdSet.values as T;
    }
    return this.metadata;
  }

  void setMetadata(T metadata) {
    if (metadata.id == id) {
      metadata = metadata;
      shareIdSet[id] = metadata;
      changCallback();
    }
  }

  @override
  String get userId {
    return kernel.userId;
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
    return this.findShare(_metadata.createUser ?? '');
  }

  @override
  ShareIcon get updater {
    return this.findShare(_metadata.updateUser ?? '');
  }

  @override
  ShareIcon get belong {
    return findShare(_metadata.belongId!);
  }

  @override
  T? findMetadata<T>(String id) {
    if (shareIdSet.containsKey(id)) {
      return shareIdSet.values as T;
    }
    return null;
  }

  @override
  void updateMetadata<T extends XEntity>(T data) {
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
