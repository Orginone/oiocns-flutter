import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/widgets/index.dart';
import 'package:orginone/config/colors.dart';
import 'package:orginone/dart/base/model.dart' as model;
import 'package:orginone/utils/date_utils.dart';
import 'package:orginone/config/unified.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../../../dart/core/getx/base_get_page_view.dart';
import 'logic.dart';
import 'state.dart';

class UseTracesPage
    extends BaseGetPageView<UseTracesController, UseTracesState> {
  UseTracesPage({super.key});

  @override
  Widget buildView() {
    return _timeLine();
  }

  Widget _timeLine() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
      height: double.infinity,
      color: AppColors.backgroundColor,
      child: Obx(() {
        int length = state.archives.length;

        return ListView.builder(
          itemCount: length,
          itemBuilder: (context, index) {
            return Container(
              child: _buildTimelineTile(index, state.archives[index]),
            );
          },
        );
      }),
    );
  }

  Widget _buildTimelineTile(int index, model.Archives archive) {
    bool isLast = index == state.archives.length - 1 ? true : false;
    return TimelineTile(
      isFirst: index == 0 ? true : false,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 15.w,
        height: 15.w,
        color: XColors.themeColor,
        indicatorXY: 0,
      ),
      afterLineStyle: const LineStyle(thickness: 1, color: XColors.themeColor),
      beforeLineStyle: const LineStyle(thickness: 1, color: XColors.themeColor),
      endChild: Container(
        margin: EdgeInsets.only(left: 15.h),
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(archive.title ?? ""),
                    Text(archive.status == 100
                        ? "已通过"
                        : archive.status == 1
                            ? "待审核"
                            : "未通过"),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text.rich(TextSpan(children: [
                  const TextSpan(text: "创建人:"),
                  WidgetSpan(
                      child: TargetText(
                    userId: archive.createUser ?? "",
                  )),
                ])),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(
                      "内容:${archive.content ?? ""}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    )),
                    Text(DateTime.tryParse(archive.createTime ?? "")
                            ?.format(format: "yyyy-MM-dd HH:mm:ss") ??
                        ""),
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
    return "UseTraces";
  }
}
