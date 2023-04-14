import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/thing/idict.dart';
import 'package:orginone/pages/setting/dialog.dart';
import 'package:orginone/widget/loading_dialog.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';


SettingController get setting => Get.find();

class ClassificationInfoController extends BaseController<ClassificationInfoState> with GetTickerProviderStateMixin{
 final ClassificationInfoState state = ClassificationInfoState();
 ClassificationInfoController(){
  state.tabController = TabController(length: tabTitle.length, vsync: this);
 }
 
 @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    LoadingDialog.showLoading(context);
    await state.species.loadAttrs(setting.space.id, true, true, PageRequest(offset: 0, limit: 999, filter: ''));
    await loadDict();
    LoadingDialog.dismiss(context);
  }

  Future<void> loadDict() async{
    var array = await state.species.loadDicts(setting.space.id, true, true, PageRequest(offset: 0, limit: 999, filter: ''));
    if(array!=null){
      state.dict.clear();
      state.dict.addAll(array.result??[]);
    }
  }

  void createDict() {
    showCreateDictDialog(context,onCreate: (name,value,id,remark,{bool? public}) async{
      IDict? dict = await state.species.createDict(DictModel(name: name,code:value,public: true,belongId: id, speciesId: setting.space.id, remark: remark,));
      if(dict!=null){
        await loadDict();
      }
    });
  }
}
