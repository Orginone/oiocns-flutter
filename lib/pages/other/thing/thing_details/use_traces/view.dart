import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/widget/target_text.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/config/color.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../../../dart/core/getx/base_get_page_view.dart';
import 'logic.dart';
import 'state.dart';

class UseTracesPage extends BaseGetPageView<UseTracesController,UseTracesState>{


  @override
  Widget buildView() {
    return _timeLine();
  }


  Widget _timeLine() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
      height: double.infinity,
      color: GYColors.backgroundColor,
      child: Obx(() {
        int length = state.archives.value?.archives?.length ?? 0;

        return ListView.builder(
          itemCount: length,
          itemBuilder: (context, index) {
            return Container(
              child: _buildTimelineTile(
                  index,
                  state.archives.value!.archives![index]),
            );
          },
        );
      }),
    );
  }

  Widget _buildTimelineTile(int index, Archive archive) {
    bool isLast = index == state.archives.value!.archives!.length - 1
        ? true
        : false;
    return TimelineTile(
        isFirst: index == 0 ? true : false,
        isLast: isLast,
        indicatorStyle: IndicatorStyle(
          width: 15.w,
          height: 15.w,
          color: XColors.themeColor,
          indicatorXY: 0,
        ),
        afterLineStyle:
        const LineStyle(thickness: 1, color: XColors.themeColor),
        beforeLineStyle:
        const LineStyle(thickness: 1, color: XColors.themeColor),
        endChild:Container(
          margin: EdgeInsets.only(left: 15.h),
          child: Card(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(archive.record?.status == 100?"已通过":archive.record?.status == 1?"待审核":"未通过"),
                      SizedBox(width: 20.w,),
                      Expanded(child: TargetText(userId: archive.instance?.createUser??"",)),
                      Text("审核节点:${archive.node?.nodeType}"),
                    ],
                  ),
                  SizedBox(height:30.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text("审批意见:${archive.record?.comment??""}",overflow: TextOverflow.ellipsis,maxLines: 1,)),
                      Text(DateTime.tryParse(archive.instance?.createTime ?? "")?.format(
                          format: "yyyy-MM-dd HH:mm:ss") ?? ""),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }


  @override
  UseTracesController getController() {
    return UseTracesController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return "UseTraces";
  }
}