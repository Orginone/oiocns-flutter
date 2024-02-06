import 'package:orginone/dart/base/model.dart';
import 'package:orginone/main_base.dart';

class ThingModel {
  String? id;
  String? creater;
  String? createrName;
  String? createTime;
  String? modifiedTime;
  String? status;

  bool isSelected = false;

  Map<String, dynamic> eidtInfo = {};
  Map<String, dynamic> propertys = {};
  Map<String, dynamic> species = {};
  ThingModel(
      {this.id,
      this.creater,
      this.createTime,
      this.modifiedTime,
      this.status,
      this.eidtInfo = const {}});

  ThingModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    creater = json['Creater'];

    ShareIcon shareIcon = relationCtrl.user.findShareById(creater ?? "");
    createrName = shareIcon.name;
    createTime = json['CreateTime'];
    modifiedTime = json['ModifiedTime'];
    status = json['Status'];
    species = json['Species'] ?? {};
    propertys = json['Propertys'] ?? {};
    eidtInfo = json['EDIT_INFO'] ?? {};
    for (var element in json.keys) {
      if (element.length > 15) {
        eidtInfo[element] = json[element];
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Creater'] = creater;
    data['CreateTime'] = createTime;
    data['ModifiedTime'] = modifiedTime;
    data['Status'] = status;
    data['EDIT_INFO'] = eidtInfo;
    data['Propertys'] = propertys;
    data['Species'] = species;
    return data;
  }
}
