import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/widget/a_font.dart';
import 'package:orginone/widget/base_list_controller.dart';
import 'package:orginone/widget/template/originone_scaffold.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/chat/chat_controller.dart';
import 'package:orginone/pages/chat/message_page.dart';
import 'package:orginone/util/load_image.dart';
import 'package:orginone/util/string_util.dart';
import 'package:orginone/util/widget_util.dart';

class PublisherPage extends GetView<PublisherController> {
  late VersionVersionMes version;
  var chatCtrl = Get.find<ChatController>();

  PublisherPage({Key? key}) : super(key: key) {
    version = Get.arguments as VersionVersionMes;
  }

  @override
  Widget build(BuildContext context) {
    return OrginoneScaffold(
      appBarTitle: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          XImage.netImageRadiusAll(
              url: version.uploadName?.shareLink ?? '',
              radius: 5,
              size: Size(30.w, 30.w)),
          SizedBox(
            width: 5.w,
          ),
          Text(
            "${version.appName}",
            style: AFont.instance.size22Black3,
          )
        ],
      ),
      appBarCenterTitle: true,
      appBarLeading: WidgetUtil.defaultBackBtn,
      bgColor: XColors.navigatorBgColor,
      body: Container(
        padding: EdgeInsets.all(20.w),
        width: double.infinity,
        color: XColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "应用信息",
              style: AFont.instance.size24Black0W500,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.w, top: 10.h),
              child: Text(
                "　版本号：${version.version}",
                style: AFont.instance.size22Black6,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.w, top: 10.h),
              child: Text(
                "　　大小：${StringUtil.formatFileSize(version.size ?? 0)}",
                style: AFont.instance.size22Black6,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.w, top: 10.h),
              child: Text(
                "上传时间：${DateUtil.formatDateStr(version.pubTime ?? "", format: "yyyy-MM-dd HH:mm")}",
                style: AFont.instance.size22Black6,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.w, top: 10.h),
              child: Text(
                "版本信息：${version.remark}",
                style: AFont.instance.size22Black6,
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Text(
              "开发者信息(${(version.pubTeam?.id ?? '').isEmpty ? "个人" : "单位"})",
              style: AFont.instance.size24Black0W500,
            ),
            Visibility(
                visible: (version.pubTeam?.id ?? '').isNotEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, top: 10.h),
                      child: Text(
                        "单位名称：${version.pubTeam?.team?.name ?? ""}",
                        style: AFont.instance.size22Black6,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, top: 10.h),
                      child: Text(
                        "单位简称：${version.pubTeam?.name ?? ''}",
                        style: AFont.instance.size22Black6,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, top: 10.h),
                      child: Text(
                        "　设立人：${chatCtrl.getName(version.pubTeam?.createUser ?? '')}",
                        style: AFont.instance.size22Black6,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, top: 10.h),
                      child: Text(
                        "创建时间：${DateUtil.formatDateStr(version.pubTeam?.createTime?.toString() ?? '', format: "yyyy-MM-dd HH:mm")}",
                        style: AFont.instance.size22Black6,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, top: 10.h),
                      child: Text(
                        "信用代码：${version.pubTeam?.code ?? ''}",
                        style: AFont.instance.size22Black6,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, top: 10.h),
                      child: Text(
                        "单位简介：${version.pubTeam?.team?.remark ?? '无'}",
                        style: AFont.instance.size22Black6,
                      ),
                    ),
                  ],
                )),
            Visibility(
                visible: (version.pubTeam?.id ?? '').isEmpty,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, top: 10.h),
                      child: Text(
                        "作者姓名：${version.pubAuthor?.name ?? ""}",
                        style: AFont.instance.size22Black6,
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}


class PublisherController extends GetxController{

}

class PublisherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PublisherController());
  }
}
