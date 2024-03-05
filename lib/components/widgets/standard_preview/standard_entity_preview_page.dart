import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/extension/ex_list.dart';
import 'package:orginone/common/extension/ex_widget.dart';
import 'package:orginone/common/widgets/text.dart';
import 'package:orginone/components/base/orginone_stateful_widget.dart';
import 'package:orginone/components/widgets/common/image/team_avatar.dart';
import 'package:orginone/config/index.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/public/entity.dart';
import 'package:orginone/dart/core/thing/standard/property.dart';
import 'package:orginone/utils/index.dart';

// ignore: must_be_immutable
class StandardEntityPreViewPage extends OrginoneStatefulWidget {
  StandardEntityPreViewPage({super.key, super.data});

  @override
  State<StandardEntityPreViewPage> createState() =>
      _StandardEntityPreViewPageState();
}

class _StandardEntityPreViewPageState
    extends OrginoneStatefulState<StandardEntityPreViewPage> {
  @override
  Widget buildWidget(BuildContext context, data) {
    return _buildView(context, data);
  }

  // 主视图
  Widget _buildView(BuildContext context, data) {
    // ignore: prefer_typing_uninitialized_variables
    var item;
    if (data is Property) {
      item = data.metadata;
      LogUtil.d(item.toJson());
    } else {}
    return <Widget>[
      itemWidget('名称', item.name ?? '-', required: true),
      itemWidget('代码', item.code ?? '-', required: true),
      itemWidget('类型', item.valueType ?? '-', required: true),
      itemWidget('附加信息', '-'),
      itemWidget(
        '归属',
        data.belong != null ? (data.belong as ShareIcon).name : '-',
        icon: data.belong,
      ),
      itemWidget(
        '创建人',
        ShareIdSet[item.createUser].name ?? '-',
        userId: item.createUser,
      ),
      itemWidget(
        '创建时间',
        item.createTime ?? '-',
      ),
      itemWidget(
        '更新人',
        ShareIdSet[item.updateUser].name ?? '-',
        userId: item.updateUser ?? '-',
      ),
      itemWidget(
        '更新时间',
        item.updateTime ?? '-',
      ),
      itemWidget('备注', item.remark ?? '-', rowCount: 1),
    ].toWrap().paddingAll(AppSpace.page).backgroundColor(AppColors.white);
  }

  itemWidget(String title, String value,
      {bool required = false,
      int rowCount = 2,
      ShareIcon? icon,
      String? userId}) {
    return <Widget>[
      <Widget>[
        required
            ? const TextWidget(
                text: '*',
                style: TextStyle(color: AppColors.red),
              ).paddingRight(AppSpace.iconTextSmail)
            : const SizedBox(),
        TextWidget(
          text: title,
          style: const TextStyle(color: AppColors.gray_66),
        ),
      ].toRow().paddingBottom(AppSpace.listRow),
      <Widget>[
        icon == null && userId == null
            ? const SizedBox()
            : TeamAvatar(
                key: ValueKey(icon),
                size: 18,
                circular: false,
                info: TeamTypeInfo(share: icon, userId: userId),
              ).paddingRight(3),
        TextWidget.title4(
          value,
          color: AppColors.gray_33,
          maxLines: 3,
          softWrap: true,
          overflow: TextOverflow.clip,
        ),
      ].toRow(),
    ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .width((Get.width - AppSpace.page * 2) / rowCount)
        .paddingBottom(AppSpace.paragraph);
  }
}
