import 'dart:math';

import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:logging/logging.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:orginone/api/person_api.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/page/home/home_controller.dart';
import 'package:orginone/public/http/base_controller.dart';
import 'package:orginone/public/loading/load_status.dart';
import 'package:orginone/util/string_util.dart';


get typeChar => "-101";

class ContactController extends BaseController {
  int limit = 20;
  int offset = 0;
  int mSelectIndex = -1;
  bool mTouchUp = true;
  List<TargetResp> mData = [];
  Logger logger = Logger("ContactController");

  //索引
  List<String> mIndex = [
    "☆",
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "G",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  ];
  HomeController homeController = Get.find<HomeController>();

  @override
  void onInit() {
    loadAllContact("");
    homeController.currentSpace;
  }

  /// 一次性加载全部好友，并提取索引
  Future<void> loadAllContact(String filter) async {
    var pageResp = await PersonApi.friends(limit, offset, filter);
    if (pageResp.result.length < limit) {
      mData.addAll(pageResp.result);
      //提取首字符
      List<String> firstChars = [];
      List<int> insertPos = [];
      for (var value in mData) {
        firstChars.add(StringUtil.getStrFirstUpperChar(
            PinyinHelper.getFirstWordPinyin(value.name)));
      }
      for (var element in firstChars) {
        logger.info("====>1 加载完成${element}");
      }
      //记录内容区域插入索引的位置
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
        var targetResp = TargetResp(typeChar, firstChars[pos], "", "", "", "", 0,
            "", "", "", null, null, null, null);
        mData.insert(pos + index, targetResp);
        index++;
      }
      mIndex.addAll(firstChars.toSet().toList());
      for (var value1 in mData) {
        logger.info("====>1 名称：${value1.name}");
      }
      updateLoadStatus(LoadStatusX.success);
    } else {
      offset++;
      mData.addAll(pageResp.result);
      loadAllContact(filter);
    }
  }

  Future<void> moreContact(int offset, int limit, String filter) async {
    var pageResp = await PersonApi.friends(offset, limit, filter);
    mData.addAll(pageResp.result);
    update();
  }

  String getBarStr() {
    if (mSelectIndex >= 0 && mSelectIndex <= mIndex.length) {
      return mIndex[mSelectIndex];
    }
    return "";
  }

  bool isVisibility() {
    return !mTouchUp;
  }

  updateIndex(int index, bool touchUp) {
    mSelectIndex = index;
    mTouchUp = touchUp;
    update();
  }
}
