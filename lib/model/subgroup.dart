import 'package:hive/hive.dart';
part 'subgroup.g.dart';

@HiveType(typeId: 7)
class SubGroup{
  @HiveField(0)
  String? type;
  @HiveField(1)
  List<Group>? groups;
  @HiveField(2)
  List<Group>? hidden;

  SubGroup({this.type,this.groups,this.hidden});

  SubGroup.fromJson(Map<String,dynamic> json){
    type = json['type'];
    groups = [];
    hidden = [];
    if(json['groups']!=null){
      json['groups'].forEach((json){
        groups!.add(Group.fromJson(json));
      });
    }
    if(json['hidden']!=null){
      json['hidden'].forEach((json){
        hidden!.add(Group.fromJson(json));
      });
    }
  }

  Map<String,dynamic> toJson(){
    return {
      "type":type,
      "groups":groups?.map((e) => e.toJson()).toList(),
      "hidden":hidden?.map((e) => e.toJson()).toList(),
    };
  }

}

@HiveType(typeId: 8)
class Group{
  @HiveField(0)
  String? label;
  @HiveField(1)
  String? value;

  Group({this.label,this.value});

  Group.fromJson(Map<String,dynamic> json){
    label = json['label'];
    value = json['value'];
  }

  Map<String,dynamic> toJson(){
    return {
      "label":label,
      "value":value,
    };
  }
}