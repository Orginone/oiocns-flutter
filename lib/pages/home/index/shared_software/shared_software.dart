




import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/submenu_list/item.dart';
import 'package:orginone/dart/core/getx/submenu_list/list_adapter.dart';
import 'package:orginone/images.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/home/index/widget/widget.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/image_widget.dart';
import 'package:orginone/widget/unified.dart';

class SharedSoftware extends StatefulWidget {
  const SharedSoftware({Key? key}) : super(key: key);

  @override
  State<SharedSoftware> createState() => _SharedSoftwareState();
}

class _SharedSoftwareState extends State<SharedSoftware> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        hotSoftware(),
        sharedSoftware(),
        allSoftware(),
      ],
    );
  }


  Widget hotSoftware(){
    return Column(
      children: [
        CommonWidget.commonHeadInfoWidget("热门软件",action: ImageWidget(Images.iconBlueArrow)),
        Container(
          height: 180.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 12,
            itemBuilder: (context, index) {
              return PopularItem();
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 10.h,
              crossAxisSpacing: 10.w,
              childAspectRatio: 0.75,
            ),
          ),
        )
      ],
    );
  }

  Widget sharedSoftware(){
    return Column(
      children: [
        CommonWidget.commonHeadInfoWidget("我共享的",action: ImageWidget(Images.iconBlueArrow)),
        Obx((){
          return Column(
            children: settingCtrl.provider.myApps.map((element){
              return ListItem(
                adapter: ListAdapter.application(element.keys.first, element.values.first),
              );
            }).toList(),
          );
        })
      ],
    );
  }

  Widget allSoftware(){
    return Column(
      children: [
        CommonWidget.commonHeadInfoWidget("全部软件",action: ImageWidget(Images.iconBlueArrow)),
      ],
    );
  }
}


