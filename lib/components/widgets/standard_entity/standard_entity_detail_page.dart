import 'package:flutter/material.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/base/orginone_stateful_widget.dart';
import 'package:orginone/components/widgets/common/others/common_widget.dart';
import 'package:orginone/config/index.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/thing/standard/index.dart';
import 'package:orginone/utils/index.dart';

import 'widgets/standard_entity_Info_view.dart';
import 'widgets/standard_entity_child_list_view.dart';

// ignore: must_be_immutable
class StandardEntityDetailPage extends OrginoneStatefulWidget {
  StandardEntityDetailPage({super.key, super.data});

  @override
  State<StandardEntityDetailPage> createState() =>
      _StandardEntityDetailPageState();
}

class _StandardEntityDetailPageState
    extends OrginoneStatefulState<StandardEntityDetailPage, dynamic> {
  @override
  Widget buildWidget(BuildContext context, dynamic data) {
    return _buildMainView(context, data);
  }

  // 主视图
  Widget _buildMainView(BuildContext context, data) {
    if (data == null || data.metadata == null) {
      return const Text('数据异常');
    }

    // ignore: prefer_typing_uninitialized_variables
    var item;
    // if (data is Property) {
    //   item = data.metadata.toJson();
    //   LogUtil.d(item);
    // } else if (data is Species) {
    //   item = data.metadata.toJson();
    //   LogUtil.d(item);
    // } else {
    //   item = data.metadata.toJson();
    // }

    item = data.metadata.toJson();

    if (data is Species) {
      //如果是字典和分类项目  加载loadContent
      return FutureBuilder(
        future: data.loadContent(reload: true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator()
                .center()
                .backgroundColor(AppColors.white);
          }
          if (snapshot.connectionState != ConnectionState.done &&
              !snapshot.hasData) {
            return Container();
          }
          LogUtil.d('FutureBuilder');
          // LogUtil.d('-------------------');
          // LogUtil.d(item);
          XSpecies species = XSpecies.fromJson(item);
          species.speciesItems = data.items;
          // LogUtil.d('-------------------');
          // LogUtil.d(item);
          item = species.toJson();
          // LogUtil.d('-------------------');
          LogUtil.d(item);

          return _buildBody(data, item, species);
        },
      );
    }
    return _buildBody(data, item, XSpecies.fromJson(item));
  }

  _buildBody(dynamic data, dynamic item, XSpecies species) {
    return SingleChildScrollView(
        child: <Widget>[
      CommonWidget.sectionHeaderView(
          '${data.typeName ?? ''}${[data.name ?? '']}基本信息'),
      StandardEntityInfoView(
        item: item,
        belong: data.belong,
      ),
      StandardEntityChildListView(
        data: species,
      )
    ].toColumn().backgroundColor(AppColors.white));
  }
}
