import 'package:flutter/material.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/base/orginone_stateful_widget.dart';
import 'package:orginone/config/index.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/thing/standard/index.dart';
import 'package:orginone/utils/index.dart';

import 'widgets/standard_entity_Info_view.dart';

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

          return StandardEntityInfoView(
            item: item,
            belong: data.belong,
          );
        },
      );
    }
    return StandardEntityInfoView(
      item: item,
      belong: data.belong,
    );
  }
}
