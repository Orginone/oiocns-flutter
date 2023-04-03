import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/setting/classification_info/classification_basic_info.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import 'classification_attrs.dart';
import 'logic.dart';
import 'state.dart';


class ClassificationInfoPage extends BaseGetView<ClassificationInfoController,ClassificationInfoState>{
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: state.species.name,
      body: Column(
        children: [
          tabBar(),
          Expanded(
            child: TabBarView(
              controller: state.tabController,
              children: [
                ClassificationBasicInfo(species: state.species,),
                ClassificationAttrs(species: state.species,),
                Container(),
                Container(),
                Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tabBar() {
    return Container(
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: TabBar(
        controller: state.tabController,
        tabs: tabTitle.map((e) {
          return Tab(
            text: e,
            height: 40.h,
          );
        }).toList(),
        indicatorColor: XColors.themeColor,
        indicatorSize: TabBarIndicatorSize.label,
        unselectedLabelColor: Colors.grey,
        unselectedLabelStyle: TextStyle(fontSize: 18.sp),
        labelColor: XColors.themeColor,
        labelStyle: TextStyle(fontSize: 21.sp),
        isScrollable: true,
      ),
    );
  }
}