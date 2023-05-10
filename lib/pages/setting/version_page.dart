import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/widget/a_font.dart';
import 'package:orginone/widget/base_list_controller.dart';
import 'package:orginone/widget/template/originone_scaffold.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/widget/widgets/loading_widget.dart';
import 'package:orginone/widget/widgets/progress_dialog.dart';
import 'package:orginone/config/enum.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/market/index.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/load_image.dart';
import 'package:orginone/util/string_util.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionPage extends GetView<VersionController> {
  const VersionPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return OrginoneScaffold(
        appBarCenterTitle: true,
        appBarTitle: Text(
          "版本列表",
          style: XFonts.size22Black3,
        ),
        appBarLeading: XWidgets.defaultBackBtn,
        bgColor: XColors.white,
        body: Obx(() {
          return LoadingWidget(
            currStatus: controller.mLoadStatus.value,
            builder: (BuildContext context) {
              return listWidget();
            },
          );
        }),
        resizeToAvoidBottomInset: false);
  }

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
          Align(
            alignment: AlignmentDirectional.topStart,
            child: XImage.netImageRadiusAll(
                url: value.uploadName?.shareLink ?? '',
                radius: 5,
                size: Size(60.w, 60.w)),
          ),
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
                        "发布时间：${DateUtil.formatDateStr(value.pubTime ?? "", format: "yyyy-MM-dd HH:mm")}",
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
                              PackageInfo packageInfo =
                                  await PackageInfo.fromPlatform();
                              String appName = packageInfo.appName;
                              int versionCode =
                                  int.parse(packageInfo.buildNumber);
                              if (appName == value.appName &&
                                  (value.version ?? 1) <= versionCode) {
                                Fluttertoast.showToast(
                                    msg: "此版本低于当前安装版本，无法安装!");
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
                            color: XColors.backColor,
                            text:
                                "更新(${StringUtil.formatFileSize(value.size ?? 0)})",
                            textColor: Colors.white,
                            textStyle: AFont.instance.size18White),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      SizedBox(
                        width: 135.w,
                        height: 42.h,
                        child: GFButton(
                          onPressed: () {

                          },
                          color: XColors.themeColor,
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
              color: XColors.lineLight2,
            ),
          )
        ],
      ),
    );
  }

}


class VersionController extends BaseListController<VersionVersionMes> {
  var fileCtrl = UpdateController();
  final Rx<LoadStatusX> mLoadStatus = LoadStatusX.loading.obs;

  @override
  void onInit() {
    super.onInit();
    onRefresh();
  }

  @override
  void onRefresh() async {
    var version = await fileCtrl.versionList();
    if (version != null) {
      List<VersionVersionMes> versionList = [];
      for (var element in (version.versionMes ?? [])) {
        if (Platform.isAndroid && element.platform.toLowerCase() == "android") {
          versionList.add(element);
        } else if (Platform.isIOS && element.platform.toLowerCase() == "ios") {
          versionList.add(element);
        }
      }
      if (versionList.isEmpty) {
        mLoadStatus.value = LoadStatusX.empty;
        update();
        return;
      }
      PageResp<VersionVersionMes> pageResp =
      PageResp(versionList.length, versionList.length, versionList);
      addData(true, pageResp);
      mLoadStatus.value = LoadStatusX.success;
      update();
    } else {
      mLoadStatus.value = LoadStatusX.error;
      update();
    }
  }

  @override
  void onLoadMore() {}

  @override
  void search(String value) {}
}

class VersionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VersionController());
  }
}


class UpdateController extends GetxController {

  Future<Map<String, dynamic>> apkDetail() async {
    var key = "apkFile";
    var domain = "all";
    ResultType resp = await kernel.anystore.get(key, domain);
    return resp.data["apk"];
  }

  Future<VersionEntity?> versionList() async {
    var key = "version";
    var domain = "all";
    ResultType resp = await kernel.anystore.get(key, domain);
    if (resp.success) {
      return VersionEntity.fromJson(resp.data);
    }
    return null;
  }
}

class UpdateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UpdateController());
  }
}


