import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/config/index.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/work/task.dart';
import 'package:orginone/pages/work/network.dart';
import 'package:orginone/utils/index.dart';

// ignore: must_be_immutable
class ApproveWidget extends StatelessWidget {
  const ApproveWidget({super.key, required this.todo, required this.comment});
  final IWorkTask? todo;

  final TextEditingController? comment;
  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  _buildMainView() {
    return <Widget>[
      // _opinion(),
      _approval()
    ].toColumn();
  }

  ///审批
  Widget _approval() {
    if (todo?.metadata.status != 1) {
      return Container();
    }
    return Container(
      width: double.infinity,
      height: 80.h,
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(top: BorderSide(color: Colors.grey.shade300, width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _button(
              text: '驳回',
              textColor: Colors.white,
              color: Colors.red,
              onTap: () {
                LogUtil.d('驳回');
                approval(TaskStatus.refuseStart.status, comment: comment?.text);
              }),
          _button(
              text: '通过',
              textColor: Colors.white,
              color: XColors.themeColor,
              onTap: () {
                LogUtil.d('通过');
                approval(TaskStatus.approvalStart.status,
                    comment: comment?.text);
              }).paddingHorizontal(AppSpace.page),
        ],
      ),
    );
  }

  Widget _opinion() {
    if (todo?.metadata.status != 1) {
      return Container();
    }
    return CommonWidget.commonTextTile(
      "备注",
      "",
      showLine: true,
      controller: comment,
      hint: "请填写备注信息",
      maxLine: 4,
    ).paddingTop(AppSpace.listItem);
  }

  Widget _button(
      {VoidCallback? onTap,
      required String text,
      Color? textColor,
      Color? color,
      BoxBorder? border}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 45.h,
        width: 140.w,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4.w),
          border: border,
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 24.sp),
        ),
      ),
    );
  }

  //网络请求
  void approval(int status, {String? comment}) async {
    // if (comment == null || comment.isEmpty) {
    //   return ToastUtils.showMsg(msg: '请输入审批意见');
    // }

    await WorkNetWork.approvalTask(
        status: status,
        comment: comment,
        todo: todo!,
        onSuccess: () {
          Get.back();
        });
  }
}
