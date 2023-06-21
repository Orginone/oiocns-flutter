import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/main.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/loading_dialog.dart';

import 'state.dart';

class MarketTreeController
    extends BaseBreadcrumbNavController<MarketTreeState> {
  final MarketTreeState state = MarketTreeState();


  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    LoadingDialog.showLoading(context);
    state.model.value ??= BaseBreadcrumbNavModel(
      name: HomeEnum.market.label,
      children: await buildNav(),
    );
    LoadingDialog.dismiss(context);
  }

  Future<List<BaseBreadcrumbNavModel>> buildNav() async {
    // List<IMarket> market = [];
    // for (var cohort in settingCtrl.user.cohorts) {
    //   if (cohort.market != null) {
    //     market.add(cohort.market!);
    //   }
    // }
    // for (var company in settingCtrl.user.companys) {
    //   for (var group in company.groups) {
    //     if (group.market != null) {
    //       market.add(group.market!);
    //     }
    //   }
    // }
    //
    // Future<List<BaseBreadcrumbNavModel>> buildSpeciesNav(
    //     List<ISpeciesItem> species) async {
    //   List<BaseBreadcrumbNavModel> navs = [];
    //
    //   for (var specie in species) {
    //     if (specie.metadata.typeName == SpeciesType.thing.label) {
    //       List<IForm> form = await (specie as IThingClass).loadForms();
    //       for (var element in form) {
    //         await element.loadAttributes();
    //       }
    //       navs.add(
    //         BaseBreadcrumbNavModel<BaseBreadcrumbNavModel>(
    //             name: specie.metadata.name,
    //             source: specie,
    //             children: [
    //               ...await buildSpeciesNav(specie.children),
    //               ...form
    //                   .map((e) =>
    //                       BaseBreadcrumbNavModel<BaseBreadcrumbNavModel>(
    //                           name: e.metadata.name,
    //                           source: e,
    //                           children: e.attributes
    //                               .map((e) => BaseBreadcrumbNavModel<
    //                                       BaseBreadcrumbNavModel>(
    //                                     name: e.name ?? "",
    //                                     source: e,
    //                                   ))
    //                               .toList()))
    //                   .toList()
    //             ]),
    //       );
    //     }
    //   }
    //   return navs;
    // }

    List<BaseBreadcrumbNavModel> navs = [];
    // for (var value in market) {
    //   navs.add(BaseBreadcrumbNavModel<BaseBreadcrumbNavModel>(
    //       name: value.metadata.name,
    //       source: value,
    //       children: await buildSpeciesNav(value.children)));
    // }
    return navs;
  }

  void onNext(e) {
    Get.toNamed(Routers.marketTree,
        preventDuplicates: false, arguments: {'data': e});
  }

  void jumpDetails(e) {}
}
