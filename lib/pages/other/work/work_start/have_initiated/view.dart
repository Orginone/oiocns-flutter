import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/core/getx/base_get_list_page_view.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';
import 'package:orginone/util/date_utils.dart';
import 'item.dart';
import 'logic.dart';
import 'state.dart';

class HaveInitiatedPage
    extends BaseGetListPageView<HaveInitiatedController, HaveInitiatedState> {
  final ISpeciesItem species;

  HaveInitiatedPage(this.species);

  @override
  Widget buildView() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var item = state.dataList[index];
            return Item(item: item,);
          },
          itemCount: state.dataList.length,
        ),
      ),
    );
  }

  @override
  HaveInitiatedController getController() {
    return HaveInitiatedController(species);
  }
}
