import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/widget/bottom_sheet_dialog.dart';

import 'state.dart';



class ApprovalListController extends BaseListController<ApprovalListState> {
 final ApprovalListState state = ApprovalListState();



 @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
 @override
 Future onRefresh() async{
    // TODO: implement onRefresh
    await Future.delayed(const Duration(seconds: 1),(){
      state.dataList.addAll(List<int>.generate(10, (index) => index));
      state.dataList.refresh();
      refreshController.refreshCompleted();
    });
  }

  @override
  Future onLoadMore() async{
    // TODO: implement onLoadMore
    await  Future.delayed(const Duration(seconds: 1),(){
      state.dataList.addAll(List<int>.generate(10, (index) => index));
      state.dataList.refresh();
      refreshController.loadComplete();
    });
  }

 void search(String str) {}

 void changeSearchContent() {
  PickerUtils.showListStringPicker(context, titles: SearchContent,
      callback: (str) {
        state.searchContentIndex.value = SearchContent.indexOf(str);
      });
 }

 void changeBillType() {
  PickerUtils.showListStringPicker(context, titles: BillType,
      callback: (str) {
       state.billTypeIndex.value = BillType.indexOf(str);
      });
 }

 void changeApprovalStatus() {
  PickerUtils.showListStringPicker(context, titles: ApprovalStatus,
      callback: (str) {
       state.approvalStatusIndex.value = ApprovalStatus.indexOf(str);
      });
 }
}
