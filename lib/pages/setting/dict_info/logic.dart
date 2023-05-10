import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/pages/setting/dialog.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/loading_dialog.dart';

import 'state.dart';

class DictInfoController extends BaseController<DictInfoState> {
  final DictInfoState state = DictInfoState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    LoadingDialog.showLoading(context);
   await loadDictItems();
    LoadingDialog.dismiss(context);
  }

  Future<void> loadDictItems()async{
    var data = await state.data.source.loadItems(
        state.data.source.id, PageRequest(offset: 0, limit: 1000, filter: ''));
    state.dictItems.addAll(data.result ?? []);
  }

  void onCreate() {
    showCreateDictItemDialog(context,
        onCreate: (String name, String code, String remark,
            {bool? public}) async{
        bool success =  await state.data.source.createItem(DictItemModel(name: name, public: public, value: code, dictId: state.data.source.id));
        if(success){
          ToastUtils.showMsg(msg: "创建成功");
          await loadDictItems();
        }
        });
  }

  void onOperation(operation, String key) async{
    try {
      var dictItem =
          state.dictItems.firstWhere((element) => element.name == key);

      if(operation == "edit"){
       showCreateDictItemDialog(context,
           onCreate: (String name, String code, String remark,
               {bool? public}) async{
             bool success = await state.data.source.updateItem(DictItemModel(name: name, public: public, value: code, dictId: state.data.source.id,id: dictItem.id));
             if(success){
               ToastUtils.showMsg(msg: "更新成功");
               dictItem.name = name;
               dictItem.value =code;
               state.dictItems.refresh();
             }
           },name: dictItem.name,code: dictItem.value,remark:"",isEdit:true);
      }else if(operation == 'delete'){
       bool success = await state.data.source.deleteItem(dictItem.id);
       if(success){
        state.dictItems.remove(dictItem);
        ToastUtils.showMsg(msg: "删除成功");
       }else{
        ToastUtils.showMsg(msg: "删除失败");
       }

      }

    } catch (e) {
      ToastUtils.showMsg(msg: "操作失败");
    }
  }
}
