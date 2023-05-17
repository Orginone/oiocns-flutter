import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/main.dart';

abstract class ISpeciesItem {
//数据实体
  late XSpecies metadata;

  //当前加载分类的用户
  late ITarget current;

  //当前归属用户Id
  String get belongId;

  //支持的类别类型
  late List<SpeciesType> speciesTypes;

  //父级类别
  ISpeciesItem? parent;

  //子级类别
  late List<ISpeciesItem> children;

//共享信息
  late TargetShare share;
  //是否为继承的类别
  late bool isInherited;
//  删除
  Future<bool> delete();

//  更新
  Future<bool> update(SpeciesModel data);

//  创建子类
  Future<ISpeciesItem?> create(SpeciesModel data);
}

abstract class SpeciesItem implements ISpeciesItem {
  SpeciesItem(this.metadata, this.current, [this.parent]){
    share = TargetShare(
      name: metadata.name,
      typeName: metadata.typeName,
      avatar: FileItemShare.parseAvatar(metadata.icon),
    );
    ShareIdSet[metadata.id] = share;
    speciesTypes = [];
    children = [];
    isInherited = metadata.belongId != current.space.metadata.belongId;
  }


  @override
  Future<ISpeciesItem?> create(SpeciesModel data) async{
    data.parentId = metadata.id;
    data.shareId = metadata.shareId;
    if (speciesTypes.contains(data.typeName)) {
      var res = await kernel.createSpecies(data);
      if (res.success && res.data != null) {
        var species = createChildren(res.data!, current);
        if (species != null) {
          children.add(species);
          return species;
        }
      }
    }
  }

  ISpeciesItem? createChildren(XSpecies metadata, ITarget current) {
    return null;
  }

  @override
  Future<bool> delete() async{
    var res = await kernel.deleteSpecies(IdReq(id: metadata.id));
    if (res.success) {
      if (parent != null) {
        parent!.children = parent!.children.where((i) => i!=this).toList();
      } else {
        current.species = current.species.where((i) => i!=this).toList();
      }
    }
    return res.success;
  }

  @override
  Future<bool> update(SpeciesModel data) async{
    data.shareId = metadata.shareId;
    data.parentId = metadata.parentId;
    data.id = metadata.id;
    data.typeName = metadata.typeName;
    var res = await kernel.updateSpecies(data);
    if (res.success && res.data != null) {
      metadata = res.data!;
      share = TargetShare(
        name: metadata.name,
        typeName: metadata.typeName,
        avatar: FileItemShare.parseAvatar(metadata.icon),
      );
    }
    return res.success;
  }

  @override
 late List<ISpeciesItem> children;

  @override
  late ITarget current;

  @override
  late XSpecies metadata;

  @override
  ISpeciesItem? parent;

  @override
  late TargetShare share;

  @override
  late List<SpeciesType> speciesTypes;

  @override
  late bool isInherited;

  @override
  // TODO: implement belongId
  String get belongId => current.space.metadata.id;
}