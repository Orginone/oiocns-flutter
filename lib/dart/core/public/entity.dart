import 'package:orginone/dart/base/common/emitter.dart';
import 'package:orginone/dart/base/index.dart';
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
  late String typename;
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
  OperationModel operates(String mode);
}

///实体类实现
abstract class Entity<T extends XEntity> extends Emitter implements IEntity {
  late dynamic _metadata;
  @override
  late String key;

  Entity(T metadata) {
    this.key = super.id;
    this._metadata = metadata;
    shareIdSet[metadata.id] = metadata;
  }

  String getId() {
    return this._metadata.id;
  }

  String getName() {
    return metadata().name;
  }

  String getCode() {
    return metadata().code;
  }

  String getTypeName() {
    return metadata().typeName;
  }

  String getRemark() {
    return metadata().remark ?? '';
  }

  T getMetadata() {
    if (shareIdSet.containsKey(this._metadata.id)) {
      return shareIdSet.values as T;
    }
    return this._metadata;
  }

  String getUserId() {
    return kernel.userId;
  }

  String getBelongId() {
    return this._metadata.belongId;
  }

  ShareIcon getShare() {
    return this.findShare(id);
  }

  ShareIcon getCreater() {
    return this.findShare(getMetadata().createUser!);
  }

  ShareIcon getUpdater() {
    return this.findShare(getMetadata().updateUser!);
  }

  ShareIcon getBelong() {
    return findShare(getMetadata().belongId!);
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

  U getEntity<U>(String id) {
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

  ///获取右键操作方法,暂时不实现
  // OperationModel operates(String mode) {
  //   return [entityOperates.remark, entityOperates.qrCode];
  // }
}
