import '../../base/model.dart';
import '../../base/schema.dart';

var ShareIdSet = <String, ShareIcon>{};

abstract class IEntity<T> {
  //实体唯一键
  late String key;
  //唯一标识
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
  //U findMetadata<U>(String id) {}
  //更新元数据
  void updateMetadata<U extends XEntity>(U data);

  ///对实体可进行操作
  ///@param mode 模式，默认为配置模式
  OperationModel operates(String mode);
}

class Entity implements IEntity {}
