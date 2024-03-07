import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/base/orginone_stateful_widget.dart';
import 'package:orginone/components/widgets/common/image/team_avatar.dart';
import 'package:orginone/config/index.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/entity.dart';
import 'package:orginone/dart/core/thing/standard/property.dart';
import 'package:orginone/dart/core/thing/standard/species.dart';
import 'package:orginone/utils/index.dart';

// ignore: must_be_immutable
class StandardEntityPreViewPage extends OrginoneStatefulWidget {
  StandardEntityPreViewPage({super.key, super.data});

  @override
  State<StandardEntityPreViewPage> createState() =>
      _StandardEntityPreViewPageState();
}

class _StandardEntityPreViewPageState
    extends OrginoneStatefulState<StandardEntityPreViewPage, dynamic> {
  @override
  Widget buildWidget(BuildContext context, dynamic data) {
    return _buildView(context, data);
  }

  // 主视图
  Widget _buildView(BuildContext context, data) {
    if (data == null || data.metadata == null) {
      return const Text('数据异常');
    }

    // ignore: prefer_typing_uninitialized_variables
    var item;
    if (data is Property) {
      item = data.metadata.toJson();
      LogUtil.d(item);
    } else if (data is Species) {
      item = data.metadata.toJson();
      LogUtil.d(item);
    } else {
      item = data.metadata.toJson();
    }
    if (data.belong != null) {
      item['belong'] = data.belong.toJson();
    }

    return <Widget>[
      widgets(item, '名称', 'name', required: true),
      widgets(item, '代码', 'code', required: true),
      widgets(item, '类型', 'valueType', required: true),
      // itemWidget('类型', item?.valueType ?? '-', required: true),
      widgets(item, '附加信息', 'info'),
      widgets(
        item,
        '归属',
        'belong',
        icon: data.belong,
      ),

      widgets(
        item,
        '创建人',
        'createUser',
        userId: item['createUser'],
      ),
      widgets(
        item,
        '创建时间',
        'createTime',
      ),
      widgets(
        item,
        '更新人',
        'updateUser',
        userId: item['updateUser'] ?? '-',
      ),
      widgets(
        item,
        '更新时间',
        'updateTime',
      ),
      widgets(item, '备注', 'remark', rowCount: 1),
    ]
        .toWrap(runSpacing: AppSpace.paragraph)
        .paddingAll(AppSpace.page)
        .backgroundColor(AppColors.white);
  }

  widgets(Map item, String title, String key,
      {bool required = false,
      int rowCount = 2,
      ShareIcon? icon,
      String? userId}) {
    //  data.belong != null && data.belong is ShareIcon
    //     ? (data.belong as ShareIcon).name
    //     : '-',
    var value = item[key] ?? '-';
    LogUtil.d(key);
    LogUtil.d(value);
    if (value != null && key.contains('belong')) {
      LogUtil.d(value);
      value = value['name'];
    }

    if (key.contains('User')) {
      value = ShareIdSet[item[key]] != null && ShareIdSet[item[key]] is XTarget
          ? ShareIdSet[item[key]].name
          : '-';
    }

    bool hasKey = item.containsKey(key);
    if (!hasKey) {
      return const SizedBox();
    }
    return itemWidget(title, value,
        required: required, rowCount: rowCount, icon: icon, userId: userId);
  }

  itemWidget(String title, String value,
      {bool required = false,
      int rowCount = 2,
      ShareIcon? icon,
      String? userId}) {
    bool hasIcon = icon != null || userId != null;

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
        TextWidget.body1(
          value,
          color: AppColors.gray_33,
          maxLines: 3,
          softWrap: true,
          overflow: TextOverflow.clip,
        ).width((Get.width - AppSpace.page * 2) / rowCount -
            (hasIcon ? 18 + 3 : 0)),
      ].toRow(crossAxisAlignment: CrossAxisAlignment.center),
    ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .width((Get.width - AppSpace.page * 2) / rowCount);
  }
}
