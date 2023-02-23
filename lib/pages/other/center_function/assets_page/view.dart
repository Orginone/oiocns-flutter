import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_list_page_view.dart';
import 'package:orginone/pages/other/assets_config.dart';

import 'item.dart';
import 'logic.dart';
import 'state.dart';

class AssetsPage extends BaseGetListPageView<AssetsController, AssetsState> {
  late AssetsListType assetsListType;

  late AssetsType assetsType;

  AssetsPage(this.assetsListType, this.assetsType);

  @override
  Widget buildView() {
    return SingleChildScrollView(
      child: Obx(() {
        int length = state.useList.length;
        if (assetsListType == AssetsListType.myGoods) {
          length = 0;
        }
        if (assetsListType == AssetsListType.myAssets) {
          length = state.dataList.length;
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            if (assetsType == AssetsType.myAssets) {
              return MyAssetsItem(
                assets: state.dataList[index],
              );
            }
            return CommonItem(
              assetUse: state.useList[index],
              assetsListType: assetsListType,
              assetsType: assetsType,
            );
          },
          itemCount: length,
        );
      }),
    );
  }

  @override
  Widget headWidget() {
    // TODO: implement headWidget
    List<Widget> children = [];
    children.add(Expanded(child: searchBar()));
    if (assetsListType == AssetsListType.myAssets) {
      children.insert(0, scan());
      children.insert(2, batchDelete());
    }

    return Column(
      children: [
        Container(
          color: XColors.themeColor,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                child: Row(
                  children: children,
                ),
              ),
            ],
          ),
        ),
        myAssetsInfo(),
      ],
    );
  }

  Widget batchDelete() {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        Icons.batch_prediction,
        size: 32.w,
      ),
      color: Colors.white,
    );
  }

  Widget scan() {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        Icons.qr_code_scanner,
        size: 32.w,
      ),
      color: Colors.white,
    );
  }

  Widget searchBar() {
    String hint = "请输入${assetsType.name}单据编号";
    if (assetsType == AssetsType.check) {
      hint = "请输入盘点任务名称";
    }
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 10.h),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.w)),
            child: TextField(
              textInputAction: TextInputAction.done,
              onChanged: (str) {
                controller.search(str);
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                isDense: true,
                hintText: hint,
                border: InputBorder.none,
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 24.w,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget bottomWidget() {
    // TODO: implement bottomWidget
    if (assetsType == AssetsType.check || assetsType == AssetsType.myAssets) {
      return Container();
    }

    return GestureDetector(
      onTap: () {
        controller.create(assetsType);
      },
      child: Container(
        height: 100.h,
        width: double.infinity,
        color: Colors.white,
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            color: XColors.themeColor,
            borderRadius: BorderRadius.circular(4.w),
          ),
          width: 300.w,
          height: 50.h,
          alignment: Alignment.center,
          child: Text(
            "创建${assetsType.name}",
            style: TextStyle(color: Colors.white, fontSize: 20.sp),
          ),
        ),
      ),
    );
  }

  Widget myAssetsInfo() {
    if (assetsListType != AssetsListType.myAssets) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 75.w,
              decoration: BoxDecoration(
                image: const DecorationImage(
                    image: NetworkImage(
                        "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/totalValue-bg.png"),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(4.w),
              ),
              child: Container(
                margin: EdgeInsets.only(top: 10.h, left: 10.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(
                            top: 5.h
                        ),
                        child: Image.network(
                          "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/totalValue-icon.png",
                          width: 16.w,
                          height: 16.w,
                        )),
                    Container(
                      margin: EdgeInsets.only(left: 5.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("资产总值",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500)),
                          Obx(() {
                            double grossValue = 0;
                            for (var element in state.dataList) {
                              grossValue += element.netVal ?? 0;
                            }
                            return Text(
                              "$grossValue",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w500),
                            );
                          }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Container(
              height: 75.w,
              decoration: BoxDecoration(
                image: const DecorationImage(
                    image: NetworkImage(
                        "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/totalValue-bg.png"),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(4.w),
              ),
              child: Container(
                margin: EdgeInsets.only(top: 10.h, left: 10.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: 5.h
                      ),
                      child: Image.network(
                        "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/totalNum-icon.png",
                        width: 16.w,
                        height: 16.w,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("资产数量",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500)),
                          Obx(() {
                            int count = 0;
                            for (var element in state.dataList) {
                              count +=
                              (int.tryParse(element.numOrArea.toString()) ?? 0);
                            }
                            return Text(
                              "$count",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w500),
                            );
                          }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  AssetsController getController() {
    return AssetsController(assetsListType, assetsType);
  }

  @override
  String tag() {
    // TODO: implement tag
    return "${this.toString() + assetsListType.toString()}$hashCode";
  }
}
