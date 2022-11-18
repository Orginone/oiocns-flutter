import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/api/market_api.dart';
import 'package:orginone/api_resp/market_entity.dart';
import 'package:orginone/api_resp/page_resp.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/choose_item.dart';
import 'package:orginone/component/icon_avatar.dart';
import 'package:orginone/component/text_search.dart';
import 'package:orginone/component/text_tag.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/util/widget_util.dart';

class ApplicationMarketPage extends GetView<ApplicationMarketController> {
  const ApplicationMarketPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarTitle: Text("市场", style: AFont.instance.size22Black3),
      appBarCenterTitle: true,
      appBarLeading: WidgetUtil.defaultBackBtn,
      bgColor: UnifiedColors.navigatorBgColor,
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
      color: UnifiedColors.navigatorBgColor,
      child: Column(
        children: [
          TextSearch(
            margin: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 20.h,
              bottom: 20.h,
            ),
            searchingCallback: controller.searchingCallback,
            bgColor: Colors.white,
          ),
          Obx(() => ListView.builder(
              shrinkWrap: true,
              itemCount: controller.data.length,
              itemBuilder: (context, index) {
                return _item(controller.data[index]);
              })),
        ],
      ),
    );
  }

  Widget _item(MarketEntity market) {
    return ChooseItem(
      bgColor: Colors.white,
      padding: EdgeInsets.all(20.w),
      margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
      header: IconAvatar(
        width: 64.w,
        radius: 20.w,
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.group, color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("资产监管", style: AFont.instance.size16Black0W500),
              Padding(padding: EdgeInsets.only(left: 10.w)),
              Text("归属:-", style: AFont.instance.size14Black6),
              Padding(padding: EdgeInsets.only(left: 10.w)),
              Text("编码:${market.code}", style: AFont.instance.size14Black6),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 10.h)),
          Text(
            market.remark,
            overflow: TextOverflow.ellipsis,
            style: AFont.instance.size12Black9,
            maxLines: 3,
          ),
        ],
      ),
      operate: Wrap(
        children: [
          Padding(padding: EdgeInsets.only(left: 10.w)),
          Column(
            children: [
              if (market.public ?? false)
                TextTag(
                  "私有",
                  padding: EdgeInsets.only(
                    top: 6.w,
                    bottom: 6.w,
                    left: 10.w,
                    right: 10.w,
                  ),
                )
            ],
          )
        ],
      ),
      func: () {},
    );
  }
}

class ApplicationMarketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApplicationMarketController());
  }
}

const int initOffset = 0, initLimit = 20;

class ApplicationMarketController extends GetxController {
  int offset = initOffset;
  int limit = initLimit;
  RxList<MarketEntity> data = <MarketEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    onLoad();
  }

  onLoad() async {
    await searchingCallback();
  }

  searchingCallback({String? value}) async {
    offset = initOffset;
    limit = initLimit;
    data.clear();
    data.addAll(await _getData());
  }

  loadMore() async {
    List<MarketEntity> res = await _getData();
    data.addAll(res);
    offset += res.length;
  }

  Future<List<MarketEntity>> _getData({String? value}) async {
    PageResp<MarketEntity> page = await MarketApi.searchOwn(
      offset: offset,
      limit: limit,
      filter: value ?? "",
    );
    return page.result;
  }
}
