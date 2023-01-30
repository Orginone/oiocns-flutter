import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:orginone/components/load_status.dart';
import 'package:orginone/dart/base/api/person_api.dart';
import 'package:orginone/dart/base/model/target.dart';
import 'package:orginone/dart/controller/base_controller.dart';
import 'package:orginone/pages/other/home/home_controller.dart';
import 'package:orginone/util/string_util.dart';

get typeChar => "-101";

class ContactController extends BaseController {
  int limit = 20;
  int offset = 0;
  int mSelectIndex = -1;
  RxBool mTouchUp = RxBool(true);
  RxString mTouchChar = RxString("");
  List<Target> mData = [];
  Logger logger = Logger("ContactController");
  double _listAllItemHeight = 0;

  //索引
  List<String> mIndex = [];
  HomeController homeController = Get.find<HomeController>();
  ScrollController mScrollController = ScrollController();
  GlobalKey mGlobalKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    loadAllContact("");
  }

  /// 一次性加载全部好友，并提取索引
  Future<void> loadAllContact(String filter) async {
    await PersonApi.friends(limit, offset, filter).then((pageResp) {
      if (pageResp.result.length < limit) {
        mData.addAll(pageResp.result);

        /// 提取首字符
        List<String> firstChars = [];
        List<int> insertPos = [];
        for (var value in mData) {
          firstChars.add(StringUtil.getStrFirstUpperChar(
              PinyinHelper.getFirstWordPinyin(value.name)));
        }

        /// 记录内容区域插入索引的位置
        for (var index = 0; index < firstChars.length; index++) {
          if (index == 0) {
            insertPos.add(0);
          } else if (firstChars[index - 1] != firstChars[index]) {
            insertPos.add(index);
          }
        }
        //插入字符
        var index = 0;
        for (var pos in insertPos) {
          var targetResp = Target(
            id: typeChar,
            name: firstChars[pos],
            code: "",
            typeName: "",
            thingId: "",
            status: 1,
          );
          mData.insert(pos + index, targetResp);
          index++;
        }
        mIndex.addAll(firstChars.toSet().toList());
        for (var value1 in mData) {
          logger.info("====>1 名称：${value1.name}");
        }
        updateLoadStatus(LoadStatusX.success);
        _calcAllItemHeight();
        update();
      } else {
        offset++;
        mData.addAll(pageResp.result);
        loadAllContact(filter);
      }
    }).onError((error, stackTrace) {
      updateLoadStatus(LoadStatusX.error);
    });
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
