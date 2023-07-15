import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/list_adapter.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/item.dart';
import 'package:orginone/main.dart';

import '../../../widget/load_state_widget.dart';
import 'item.dart';
import 'logic.dart';
import 'state.dart';

class ApplicationPage
    extends BaseGetPageView<ApplicationController, ApplicationState> {
  @override
  Widget buildView() {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.loadApps(true);
      },
      child: Obx(() {
        return LoadStateWidget(
          isSuccess: state.isSuccess.value,
          isLoading: state.isLoading.value,
          onRetry: () async{
            await controller.loadApps();
          },
          child: ListView.builder(
            itemBuilder: (context, index) {
              var app = settingCtrl.provider.myApps[index];

              return ListItem(adapter: ListAdapter.application(app.keys.first, app.values.first),);
            },
            itemCount: settingCtrl.provider.myApps.length,
          ),
        );
      }),
    );
  }

  @override
  ApplicationController getController() {
    return ApplicationController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return "application";
  }
}
