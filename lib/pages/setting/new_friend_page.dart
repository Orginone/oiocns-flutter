import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:orginone/widget/template/base_list_view.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/widget/widgets/dialog_confirm.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/chat/chat_controller.dart';

class NewFriendsPage extends BaseListView<NewFriendsController> {
  const NewFriendsPage({Key? key}) : super(key: key);

  @override
  String getTitle() {
    return "新朋友";
  }

  @override
  ListView listWidget() {
    return ListView.builder(
        itemCount: controller.dataList.length,
        itemBuilder: (context, index) {
          return itemInit(context, index, controller.dataList[index]);
        });
  }

  Widget itemInit(BuildContext context, int index, XRelation item) {
    return Slidable(
      enabled: false,
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            flex: 2,
            onPressed: (context) {},
            backgroundColor: const Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: 'Archive',
          ),
          SlidableAction(
            onPressed: (context) {},
            backgroundColor: const Color(0xFF0392CF),
            foregroundColor: Colors.white,
            icon: Icons.save,
            label: 'Save',
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 10.h),
              margin: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 0),
              decoration: BoxDecoration(
                  color: XColors.white,
                  border: Border.all(color: XColors.cardBorder, width: 0.1.w),
                  borderRadius: const BorderRadius.all(Radius.circular(0)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x297F7F7F),
                      offset: Offset(8, 8),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(item.target?.name ?? "",
                        style: XFonts.size22Black3W700),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                        "${controller.getName(item.createUser)}申请加入${(item.team?.name) ?? ""}",
                        style: XFonts.size18Black9),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
                        decoration: BoxDecoration(
                            color: XColors.white,
                            border: Border.all(
                                color: XColors.cardBorder, width: 0.1.w),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(0))),
                        child: Text(
                          item.createTime.toString(),
                          style: XFonts.size14Black9,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 106.w,
                            height: 42.h,
                            child: GFButton(
                              onPressed: () {
                                showAnimatedDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  animationType: DialogTransitionType.fadeScale,
                                  builder: (BuildContext context) {
                                    return DialogConfirm(
                                      title: "提示",
                                      content: "确定拒绝吗？",
                                      confirmFun: () {
                                        controller.joinRefuse(item.id);
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                );
                              },
                              color: XColors.backColor,
                              text: "拒绝",
                              textColor: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          SizedBox(
                            width: 106.w,
                            height: 42.h,
                            child: GFButton(
                              onPressed: () {
                                showAnimatedDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  animationType: DialogTransitionType.fadeScale,
                                  builder: (BuildContext context) {
                                    return DialogConfirm(
                                      title: "提示",
                                      content: "确定通过吗？",
                                      confirmFun: () {
                                        controller.joinSuccess(item);
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                );
                              },
                              color: XColors.themeColor,
                              text: "通过",
                              textStyle: XFonts.size18White,
                              textColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              color: XColors.yellow,
              padding: EdgeInsets.fromLTRB(10.w, 2.h, 10.w, 4.h),
              margin: EdgeInsets.only(top: 14.h, right: 14.h),
              child: Text(
                controller.getStatus(item.status),
                softWrap: false,
                style: XFonts.size18White,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NewFriendsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewFriendsController());
  }
}

class NewFriendsController extends BaseListController<XRelation> {
  int limit = 20;
  int offset = 0;

  @override
  void onInit() {
    super.onInit();
    onRefresh();
  }

  @override
  void onLoadMore() async {
    // offset += 1;
    // var pageResp = await PersonApi.approvalAll("0", limit, offset);
    // addData(true, pageResp);
  }

  @override
  void onRefresh() async {
    // var pageResp = await PersonApi.approvalAll("0", limit, offset);
    // addData(true, pageResp);
  }

  String getName(String userId) {
    var chatCtrl = Get.find<ChatController>();
    return chatCtrl.getName(userId);
  }

  void joinSuccess(XRelation friends) async {
    // ALoading.showCircle();
    // await PersonApi.joinSuccess(friends.id)
    //     .then((value) {
    //   //成功，刷新列表
    //   Fluttertoast.showToast(msg: "已通过");
    //   offset = 0;
    //   onRefresh();
    // })
    //     .onError((error, stackTrace) {})
    //     .whenComplete(() => ALoading.dismiss());
  }

  void joinRefuse(String id) async {
    // ALoading.showCircle();
    // await PersonApi.joinRefuse(id)
    //     .then((value) {
    //   //成功，刷新列表
    //   offset = 0;
    //   onRefresh();
    // })
    //     .onError((error, stackTrace) {})
    //     .whenComplete(() => ALoading.dismiss());
  }

  String getStatus(int status) {
    if (status >= 0 && status <= 100) {
      return "待批";
    } else if (status >= 100 && status < 200) {
      return "已通过";
    }
    return "已拒绝";
  }
}
