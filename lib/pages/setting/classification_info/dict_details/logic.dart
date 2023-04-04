import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/pages/setting/classification_info/logic.dart';
import 'package:orginone/pages/setting/dialog.dart';

import '../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class DictDetailsController extends BaseController<DictDetailsState> {
  final DictDetailsState state = DictDetailsState();


  ClassificationInfoController  get infoController => Get.find<ClassificationInfoController>();
  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    await init();
  }

  Future<void> init() async{
    XDictItemArray res =
        await state.dict.loadItems(
          state.setting.space.id ?? "",
           PageRequest(
            offset: 0,
            limit: 99999,
            filter: '',
          ),
    );
    state.dictItem.clear();
    state.dictItem.addAll(res.result??[]);
  }

  void createDictItem() {
    showCreateDictItemDialog(context,onCreate: (name,value,id,remark,{bool? public}) async{
      bool success = await state.dict.createItem(DictItemModel(name: name,value: value,public: true,belongId: id,));
      if(success){
        await init();
      }
    });
  }

  void operation(String key,String data) async{
    try{
      var item = state.dictItem.firstWhere((element) => element.name == data);
      if(key == 'delete'){
        bool success = await state.dict.deleteItem(item.id);
        if(success){
          state.dictItem.remove(item);
        }
      }else if(key == 'edit'){
        showCreateDictItemDialog(context,code: item.value,name: item.name,targetId: item.belongId,remark: item.dictId,onCreate: (name,value,id,remark,{bool? public}) async{
          bool success = await state.dict.updateItem(DictItemModel(id: item.id,belongId: id,public: true,name: name,value: value,dictId: remark));
          if(success){
            await init();
          }
        });
      }
    }catch(e){

    }
  }

}
