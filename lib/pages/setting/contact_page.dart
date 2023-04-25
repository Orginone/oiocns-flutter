import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:orginone/widget/template/base_view.dart';
import 'package:orginone/widget/template/originone_scaffold.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/widget/widgets/index_bar.dart';
import 'package:orginone/widget/widgets/loading_widget.dart';
import 'package:orginone/widget/widgets/text_avatar.dart';
import 'package:orginone/config/enum.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/common/uint.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/pages/other/search_page.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/string_util.dart';

///联系人页面
class ContactPage extends GetView<ContactController> {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrginoneScaffold(
        appBarCenterTitle: true,
        appBarTitle: Text(
          "我的联系人",
          style: XFonts.size22Black3,
        ),
        appBarLeading: XWidgets.defaultBackBtn,
        appBarActions: _actions(),
        bgColor: XColors.white,
        body: Obx(() {
          return LoadingWidget(
            currStatus: controller.mLoadStatus.value,
            builder: (BuildContext context) {
              return Stack(
                  children: [_contactList(), _indexList(), _stickIndexBar()]);
            },
          );
        }),
        resizeToAvoidBottomInset: false);
  }

  List<Widget> _actions() {
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
  int mSelectIndex = -1;
  RxBool mTouchUp = RxBool(true);
  RxString mTouchChar = RxString("");
  List<XTarget> mData = [];
  double _listAllItemHeight = 0;
  final Rx<LoadStatusX> mLoadStatus = LoadStatusX.loading.obs;

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
    var settingCtrl = Get.find<SettingController>();
    // var target = settingCtrl.space;
    // await KernelApi.getInstance()
    //     .querySubTargetById(IDReqSubModel(
    //   id: target.id,
    //   typeNames: [target.typeName],
    //   subTypeNames: [TargetType.person.label],
    //   page: PageRequest(
    //     limit: Constants.maxUint16,
    //     offset: 0,
    //     filter: filter,
    //   ),
    // ))
    //     .then((pageResp) {
    //   if (pageResp.data == null || pageResp.data!.result?.isEmpty == true) {
    //     mLoadStatus.value = LoadStatusX.empty;
    //     return;
    //   }
    //   mData.addAll(pageResp.data!.result!);
    //
    //   /// 排序
    //   mData.sort((a, b) => a.name.compareTo(b.name));
    //
    //   /// 提取首字符
    //   List<String> firstChars = [];
    //   List<int> insertPos = [];
    //   for (var value in mData) {
    //     firstChars.add(StringUtil.getStrFirstUpperChar(
    //         PinyinHelper.getFirstWordPinyin(value.name)));
    //   }
    //
    //   /// 记录内容区域插入索引的位置
    //   for (var index = 0; index < firstChars.length; index++) {
    //     if (index == 0) {
    //       insertPos.add(0);
    //     } else if (firstChars[index - 1] != firstChars[index]) {
    //       insertPos.add(index);
    //     }
    //   }
    //   //插入字符
    //   var index = 0;
    //   for (var pos in insertPos) {
    //     var targetResp = XTarget(
    //       id: typeChar,
    //       name: firstChars[pos],
    //       code: "",
    //       typeName: "",
    //       thingId: "",
    //       status: 1,
    //       avatar: '',
    //       belongId: '',
    //       createUser: '',
    //       updateUser: '',
    //       idProofs: [],
    //       version: '',
    //       createTime: '',
    //       updateTime: '',
    //       orders: [],
    //       markets: [],
    //       ruleStds: [],
    //       stags: [],
    //       products: [],
    //       identitys: [],
    //       samrMarkets: [],
    //       things: [],
    //       relations: [],
    //       team: null,
    //       dicts: [],
    //       sellOrder: [],
    //       dictItems: [],
    //       species: [],
    //       attributes: [],
    //       authority: [],
    //       marketRelations: [],
    //       relTeams: [],
    //       operations: [],
    //       operationItems: [],
    //       givenIdentitys: [],
    //       belong: null,
    //       targets: [],
    //       thing: null,
    //       distributes: [],
    //       flowDefines: [],
    //       flowRecords: [],
    //     );
    //     mData.insert(pos + index, targetResp);
    //     index++;
    //   }
    //   mIndex.addAll(firstChars.toSet().toList());
    //   _calcAllItemHeight();
    //   mLoadStatus.value = LoadStatusX.success;
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
