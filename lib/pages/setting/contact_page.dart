import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:orginone/components/template/base_view.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/components/widgets/index_bar.dart';
import 'package:orginone/components/widgets/text_avatar.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/chat/index.dart';
import 'package:orginone/dart/controller/setting/index.dart';
import 'package:orginone/pages/other/search_page.dart';
import 'package:orginone/routers.dart';

///联系人页面
class ContactPage extends BaseView<ContactController> {
  const ContactPage({Key? key}) : super(key: key);

  @override
  String getTitle() {
    return "我的联系人";
  }

  @override
  bool isUseScaffold() {
    return true;
  }

  @override
  List<Widget> actions() {
    return [
      GFIconButton(
        color: Colors.white.withOpacity(0),
        icon: const Icon(Icons.person_add_alt, color: Colors.black),
        onPressed: () {
          List<SearchItem> friends = [SearchItem.friends];
          Get.toNamed(Routers.search, arguments: {
            "items": friends,
            "point": FunctionPoint.addFriends,
          });
        },
      ),
    ];
  }

  @override
  Widget builder(BuildContext context) {
    return Stack(children: [_contactList(), _indexList(), _stickIndexBar()]);
  }

  /// 联系人列表
  Widget _contactList() {
    return GetBuilder<ContactController>(
      init: controller,
      builder: (controller) => ListView.builder(
          key: controller.mGlobalKey,
          shrinkWrap: true,
          controller: controller.mScrollController,
          scrollDirection: Axis.vertical,
          itemCount: controller.mData.length,
          itemBuilder: (context, index) {
            return item(controller.mData[index]);
          }),
    );
  }

  /// 联系人列表item
  Widget item(XTarget target) {
    if (target.id == "-101") {
      return Container(
          color: XColors.lineLight,
          height: 45.h,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 40.w),
          child: Text(
            target.name,
            style: XFonts.size20ThemeW700,
          ));
    }
    return Column(children: [
      Container(
        color: Colors.white,
        height: 110.h,
        child: ListTile(
            onTap: () async {
              var settingCtrl = Get.find<SettingController>();
              var chatCtrl = Get.find<ChatController>();
              await chatCtrl.setCurrent(settingCtrl.space.id, target.id);
              if (chatCtrl.chat == null) {
                Fluttertoast.showToast(msg: "未获取到会话信息！");
                return;
              }
              Get.toNamed(Routers.chat);
            },
            leading: TextAvatar(
              avatarName: target.name.substring(0, 2),
            ),
            title: Text(target.name, style: XFonts.size22Black3),
            subtitle: Text(target.team?.name ?? "", style: XFonts.size20Black9),
            contentPadding: EdgeInsets.only(left: 30.w)),
      ),
      Container(
          padding: EdgeInsets.only(left: 72.w, right: 10.w),
          child: Divider(height: 1.5.h, color: XColors.lineLight))
    ]);
  }

  /// 索引widget
  _indexList() {
    return Align(
      alignment: Alignment.centerRight,
      child: GetBuilder<ContactController>(
          init: controller,
          builder: (controller) => IndexBar(
              mData: controller.mIndex,
              indexBarCallBack: (str, index, touchUp) {
                controller.updateIndex(index, touchUp);
              })),
    );
  }

  /// 触摸索引显示的view
  _stickIndexBar() {
    return Obx(() => Visibility(
          visible: !controller.mTouchUp.value,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(5.w))),
              width: 100.w,
              height: 100.w,
              child: Align(
                alignment: Alignment.center,
                child: Text(controller.mTouchChar.value,
                    style: XFonts.size28White),
              ),
            ),
          ),
        ));
  }
}

class ContactBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ContactController());
  }
}

get typeChar => "-101";

class ContactController extends BaseController {
  int limit = 20;
  int offset = 0;
  int mSelectIndex = -1;
  RxBool mTouchUp = RxBool(true);
  RxString mTouchChar = RxString("");
  List<XTarget> mData = [];
  double _listAllItemHeight = 0;

  //索引
  List<String> mIndex = [];
  ScrollController mScrollController = ScrollController();
  GlobalKey mGlobalKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    loadAllContact("");
  }

  /// 一次性加载全部好友，并提取索引
  Future<void> loadAllContact(String filter) async {
    // await PersonApi.friends(limit, offset, filter).then((pageResp) {
    //   if (pageResp.result.length < limit) {
    //     mData.addAll(pageResp.result);
    //
    //     /// 提取首字符
    //     List<String> firstChars = [];
    //     List<int> insertPos = [];
    //     for (var value in mData) {
    //       firstChars.add(StringUtil.getStrFirstUpperChar(
    //           PinyinHelper.getFirstWordPinyin(value.name)));
    //     }
    //
    //     /// 记录内容区域插入索引的位置
    //     for (var index = 0; index < firstChars.length; index++) {
    //       if (index == 0) {
    //         insertPos.add(0);
    //       } else if (firstChars[index - 1] != firstChars[index]) {
    //         insertPos.add(index);
    //       }
    //     }
    //     //插入字符
    //     var index = 0;
    //     for (var pos in insertPos) {
    //       var targetResp = Target(
    //         id: typeChar,
    //         name: firstChars[pos],
    //         code: "",
    //         typeName: "",
    //         thingId: "",
    //         status: 1,
    //       );
    //       mData.insert(pos + index, targetResp);
    //       index++;
    //     }
    //     mIndex.addAll(firstChars.toSet().toList());
    //     for (var value1 in mData) {
    //       logger.info("====>1 名称：${value1.name}");
    //     }
    //     updateLoadStatus(LoadStatusX.success);
    //     _calcAllItemHeight();
    //     update();
    //   } else {
    //     offset++;
    //     mData.addAll(pageResp.result);
    //     loadAllContact(filter);
    //   }
    // }).onError((error, stackTrace) {
    //   updateLoadStatus(LoadStatusX.error);
    // });
  }

  String getBarStr() {
    if (mSelectIndex >= 0 && mSelectIndex <= mIndex.length) {
      return mIndex[mSelectIndex];
    }
    return "";
  }

  bool isVisibility() {
    return !mTouchUp.value;
  }

  updateIndex(int index, bool touchUp) {
    mSelectIndex = index;
    mTouchUp.value = touchUp;
    scrollPos(index);
    mTouchChar.value = getBarStr();
  }

  void _calcAllItemHeight() {
    _listAllItemHeight = 0;
    for (var i = 0; i < mData.length; i++) {
      if (typeChar == mData[i].id) {
        _listAllItemHeight += 45.h;
      } else {
        _listAllItemHeight += 110.h;
      }
    }
  }

  void scrollPos(int index) {
    double height = 0;
    int charIndex = 0;
    for (var i = 0;; i++) {
      var item = mData[i];
      if (typeChar == item.id) {
        if (charIndex == index) {
          break;
        }
        charIndex++;
        height += 45.h;
      } else {
        height += 11.h;
      }
    }

    /// 不足一页滑动到底部
    if (_listAllItemHeight - height > 1000.h) {
      mScrollController.jumpTo(height);
    } else {
      mScrollController.jumpTo(mScrollController.position.maxScrollExtent);
    }
  }
}
