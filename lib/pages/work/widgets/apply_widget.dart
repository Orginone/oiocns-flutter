import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/widgets/common/others/common_widget.dart';
import 'package:orginone/config/index.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/work/task.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/pages/work/widgets/approve_widget.dart';
import 'package:orginone/utils/load_image.dart';

//申请加入办事组件
class ApplyWidget extends StatelessWidget {
  ApplyWidget({
    super.key,
    required this.todo,
  });

  final IWorkTask? todo;
  TextEditingController comment = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  _buildMainView() {
    return <Widget>[
      Expanded(
          child: SingleChildScrollView(
        child: <Widget>[
          _buildApplyHeaderView(),
          _buildDateView('申请时间：${todo?.taskdata.createTime}'),
          _buildApplyResultView(),
          _opinion(),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
      )),
      _buildApproveView(),
    ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .paddingHorizontal(AppSpace.page);
  }

  _buildApplyHeaderView() {
    return <Widget>[
      <Widget>[
        const TextWidget.body1('申  请  者：'),
        // _imageWidget(target: todo!.targets.first),
        XImage.entityIcon(todo!.targets.first, height: 28),
        TextWidget.body1(
          '${todo?.targets.first.name}' ?? '',
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          color: AppColors.blue,
        ).paddingLeft(AppSpace.listItem).constrained(width: Get.width * 0.65),
      ].toRow().paddingBottom(AppSpace.listItem),
      <Widget>[
        const TextWidget.body1('申请加入：'),
        // _imageWidget(target: todo!.targets.last),
        XImage.entityIcon(todo!.targets.last, height: 28),
        TextWidget.body1(
          todo?.targets.last.name ?? '',
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          color: AppColors.blue,
        ).paddingLeft(AppSpace.listItem).constrained(width: Get.width * 0.65),
      ]
          .toRow(crossAxisAlignment: CrossAxisAlignment.center)
          .paddingBottom(AppSpace.listItem),
    ]
        .toColumn(mainAxisAlignment: MainAxisAlignment.start)
        .paddingTop(AppSpace.listItem);
  }

  ///头像组件
  // _imageWidget({XTarget? target, ShareIcon? shareIcon}) {
  //   ShareIcon? icon;
  //   if (target?.icon == null) {
  //     icon = shareIcon ??
  //         relationCtrl.provider.user?.findShareById(target?.id ?? '');
  //     if (icon?.name.isEmpty ?? false) {
  //       icon?.name = (shareIcon == null
  //               ? target == null
  //                   ? ''
  //                   : target.name
  //               : shareIcon.typeName) ??
  //           '';
  //       icon?.typeName = (shareIcon == null
  //               ? target == null
  //                   ? ''
  //                   : target.typeName
  //               : shareIcon.typeName) ??
  //           '';
  //     }
  //   } else {
  //     icon = ShareIcon(
  //         name: target?.name ?? '',
  //         typeName: target?.typeName ?? '',
  //         avatar: parseAvatar(target?.icon));
  //   }

  //   return icon?.avatar?.thumbnailUint8List == null
  //       ? XImageWidget.asset(
  //           IconsUtils.workDefaultAvatar(
  //               target?.typeName ?? shareIcon?.typeName ?? ''),
  //           // target!.defaultAvatar(),
  //           width: 20,
  //           height: 20,
  //           fit: BoxFit.fill,
  //         )
  //       : XImageWidget(
  //           data: icon?.avatar?.thumbnailUint8List,
  //           width: 20,
  //           height: 20,
  //           type: ImageWidgetType.memory,
  //           url: '');
  // }

  _buildApproveView() {
    int status = todo?.taskdata.status ?? 0;

    if (status > 1) return const SizedBox();
    return ApproveWidget(
      todo: todo,
      comment: comment,
    );
  }

  Widget _opinion() {
    if (todo?.metadata.status != 1) {
      return Container();
    }
    return CommonWidget.commonTextTile(
      "备注",
      "",
      required: true,
      backgroundColor: AppColors.bgColor,
      controller: comment,
      hint: "请填写备注信息",
      maxLine: 4,
    ).paddingTop(AppSpace.listItem);
  }

  _buildApplyResultView() {
    ShareIcon? record = relationCtrl.provider.user?.findShareById(
        todo?.taskdata.records == null
            ? ''
            : todo?.taskdata.records?.first.createUser ?? '');

    String createUser = todo?.taskdata.records == null
        ? ''
        : todo?.taskdata.records?.first.createUser ?? '';
    // LogUtil.d('_buildApplyResultView');
    // LogUtil.d(record?.toJson());
    // LogUtil.d(todo?.taskdata.records?.first.createUser);
    int status = todo?.taskdata.status ?? 0;
    if (status < TaskStatus.approvalStart.status) return const SizedBox();
    var result = <Widget>[
      // Image.network('src'),
      XImage.entityIcon("createUser", entityId: createUser, height: 28),

      // _imageWidget(shareIcon: record),
      TextWidget.body1(
        record?.name ?? '',
        color: AppColors.primary,
      ).paddingLeft(AppSpace.listItem),
      const SizedBox(
              height: 15, width: 4, child: VerticalDivider(color: Colors.grey))
          .paddingLeft(AppSpace.listItem),
      const TextWidget.body1('审批意见：').paddingLeft(AppSpace.listItem),
      const SizedBox(
              height: 15, width: 4, child: VerticalDivider(color: Colors.grey))
          .paddingHorizontal(AppSpace.listItem),
      TextWidget.body1(_statusToStr(status),
          color: status == TaskStatus.approvalStart.status
              ? AppColors.blue
              : AppColors.red),
    ]
        .toRow(crossAxisAlignment: CrossAxisAlignment.center)
        .paddingBottom(AppSpace.listItem);

    return <Widget>[
      result,
      _buildDateView('审批时间：${todo?.taskdata.records?.first.createTime ?? ''}'),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
  }

  _buildDateView(String text) {
    return TextWidget(text: text).paddingBottom(AppSpace.listItem);
  }

  _statusToStr(int status) {
    if (status == TaskStatus.approvalStart.status) {
      return '已同意';
    }
    if (status == TaskStatus.refuseStart.status) {
      return '已拒绝';
    }
    return '';
  }
}
