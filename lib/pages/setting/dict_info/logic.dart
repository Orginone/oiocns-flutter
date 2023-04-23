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
    var data = await state.data.space.dict.loadDictItems(
        state.data.source.id, PageRequest(offset: 0, limit: 1000, filter: ''));
    state.dictItems.addAll(data.result ?? []);
    LoadingDialog.dismiss(context);
  }

  void onCreate() {
    showCreateDictItemDialog(context,
        onCreate: (String name, String code, String remark,
            {bool? public}) async{
         await state.data.space.dict.createDict(DictModel(name: name, public: public, code: code, speciesId: '', remark: remark));
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
            dictItem.name = name;
            dictItem.value =code;
            state.dictItems.refresh();
           },name: dictItem.name,code: dictItem.value,remark:"",isEdit:true);
      }else if(operation == 'delete'){
       bool success = await state.data.space.dict.deleteDictItem(state.data.source.id);
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
