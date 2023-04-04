import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import 'logic.dart';
import 'state.dart';

class ApplicationDetailsPage
    extends BaseGetView<ApplicationDetailsController, ApplicationDetailsState> {
  EdgeInsetsGeometry get defaultPadding =>
      EdgeInsets.symmetric(vertical: 17.h, horizontal: 16.w);

  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "应用详情",
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  header(),
                  SizedBox(
                    height: 10.h,
                  ),
                  CommonWidget.commonHeadInfoWidget("资源信息"),
                  info(),
                ],
              ),
            ),
          ),
          bottomButton(),
        ],
      ),
    );
  }

  Widget bottomButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15.h),
      color: Colors.white,
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(child: Container(
            margin: EdgeInsets.only(left: 32.w),
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                controller.addCommon();
              },
              child: LayoutBuilder(builder:(context, type) {
                bool has = false;
                return Container(
                  width: 300.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: has?Colors.white:Colors.blueAccent,
                    borderRadius: BorderRadius.circular(4.w),
                    border:has?Border.all(color: Colors.blueAccent):null
                  ),
                  alignment: Alignment.center,
                  child: Text(
                     has
                        ? "取消常用"
                        : "设为常用",
                    style: TextStyle(color: has?Colors.blueAccent:Colors.white, fontSize: 16.sp),
                  ),
                );
              },),
            ),
          ),),
          CommonWidget.commonPopupMenuButton(items: const [
             PopupMenuItem(value: "createThing", child: Text("退订"),),
          ],),
        ],
      ),
    );
  }


  Widget header() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.w),
      ),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.w),
                image: const DecorationImage(
                    image: NetworkImage(
                        "http://anyinone.com:888/img/logo/logo3.jpg"))),
          ),
          SizedBox(
            width: 20.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.product.prod.name ?? "",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  state.product.prod.remark ?? "",
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("版本号:${state.product.prod.version}",
                        style: TextStyle(
                          fontSize: 16.sp,
                        )),
                    SizedBox(
                      width: 20.w,
                    ),
                    Text(
                        "订阅到期时间:${DateTime.tryParse(
                            state.product.prod.createTime ?? "")!.format(
                            format: "yyyy-MM-dd HH:mm")}",
                        style: TextStyle(
                          fontSize: 16.sp,
                        ))
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            width: 20.w,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.w),
                color: Colors.indigoAccent),
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 15.w),
            child: Text(
              "续费",
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
          )
        ],
      ),
    );
  }

  Widget info() {
    return Column(
      children: [
        CommonWidget.commonTextContentWidget(
            "资源名称", state.product.prod.name ?? "",
            textSize: 22,
            contentSize: 22,
            padding: defaultPadding,
            color: Colors.white),
        CommonWidget.commonTextContentWidget(
            "资源地址", state.product.resource.first.resource.link ?? "",
            textSize: 22,
            contentSize: 22,
            padding: defaultPadding,
            color: Colors.white),
        CommonWidget.commonTextContentWidget("业务信息", "",
            textSize: 22,
            contentSize: 22,
            padding: defaultPadding,
            color: Colors.white),
        CommonWidget.commonTextContentWidget("应用组件", "",
            textSize: 22,
            contentSize: 22,
            padding: defaultPadding,
            color: Colors.white),
        CommonWidget.commonTextContentWidget(
            "资产编码", state.product.resource.first.resource.code ?? "",
            textSize: 22,
            contentSize: 22,
            padding: defaultPadding,
            color: Colors.white),
      ],
    );
  }
}
