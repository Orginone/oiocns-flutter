import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/api_resp/version_entity.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/page/home/mine/version/version_controller.dart';
import 'package:orginone/public/view/base_list_view.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../component/progress_dialog.dart';
import '../../../../component/unified_colors.dart';
import '../../../../public/image/load_image.dart';
import '../../../../routers.dart';
import '../../../../util/string_util.dart';

class VersionPage extends BaseListView<VersionController> {
  const VersionPage({Key? key}) : super(key: key);

  @override
  String getTitle() {
    return "版本列表";
  }

  @override
  bool isUseScaffold() {
    return true;
  }

  @override
  ListView listWidget() {
    return ListView.builder(
      itemCount: controller.dataList.length,
      itemBuilder: (context, index) {
        return itemInit(context, index, controller.dataList[index]);
      },
    );
  }

  Widget itemInit(BuildContext context, int index, VersionVersionMes value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 0.h),
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          Align(alignment: AlignmentDirectional.topStart,
              child: AImage.netImageRadiusAll(
                  url: value.uploadName?.shareLink ?? '',
                  radius: 5,
                  size: Size(60.w, 60.w)),),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Padding(
              padding: EdgeInsets.fromLTRB(70.w, 0.h, 138.w, 0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    value.appName ?? "",
                    style: AFont.instance.size22Black3W500,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      Text(
                        "发布时间：${DateUtil.formatDateStr(
                            value.pubTime ?? "", format: "yyyy-MM-dd HH:mm")}",
                        style: AFont.instance.size20Black6,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    "　版本号：${value.version}",
                    style: AFont.instance.size20Black6,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    "版本信息：${value.remark}",
                    style: AFont.instance.size20Black6,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 135.w,
              child: Row(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: 135.w,
                        height: 42.h,
                        child: GFButton(
                          onPressed: () async {
                            //筛选出当前最新版本
                            PackageInfo packageInfo = await PackageInfo
                                .fromPlatform();
                            String appName = packageInfo.appName;
                            int versionCode = int.parse(
                                packageInfo.buildNumber);
                            if (appName == value.appName &&
                                (value.version ?? 1) <= versionCode) {
                              Fluttertoast.showToast(msg: "此版本低于当前安装版本，无法安装!");
                              return;
                            }
                            showAnimatedDialog(
                              context: context,
                              barrierDismissible: true,
                              animationType: DialogTransitionType.fadeScale,
                              builder: (BuildContext context) {
                                return UpdaterDialog(
                                  icon: value.uploadName?.shareLink ?? '',
                                  version: "${value.version ?? ''}",
                                  path: value.shareLink ?? '',
                                  content: value.remark ?? '',
                                );
                              },
                            );
                          },
                          color: UnifiedColors.backColor,
                          text:
                          "更新(${StringUtil.formatFileSize(value.size ?? 0)})",
                          textColor: Colors.white,
                          textStyle:AFont.instance.size18White
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      SizedBox(
                        width: 135.w,
                        height: 42.h,
                        child: GFButton(
                          onPressed: () {
                            Get.toNamed(Routers.publisher, arguments: value);
                          },
                          color: UnifiedColors.themeColor,
                          text: "查看详情",
                          textStyle: AFont.instance.size18White,
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0.w,
            bottom: 0.h,
            child: const Divider(
              height: 1.0,
              color: UnifiedColors.lineLight2,
            ),
          )
        ],
      ),
    );
  }
}
