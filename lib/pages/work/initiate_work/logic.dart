import 'package:get/get.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/thing/app/application.dart';
import 'package:orginone/dart/core/thing/app/flowclass.dart';
import 'package:orginone/dart/core/thing/base/flow.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/dart/core/thing/market/market.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/loading_dialog.dart';

import 'state.dart';

class InitiateWorkController
    extends BaseBreadcrumbNavController<InitiateWorkState> {
  final InitiateWorkState state = InitiateWorkState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    await init();
  }

  void jumpNext(WorkBreadcrumbNav work) {
    if (work.children.isEmpty && work.name != WorkEnum.initiationWork.label) {
      if (work.workEnum == WorkEnum.initiationWork) {
        createWork(work);
      } else {
        jumpWorkList(work);
      }
    } else {
      Get.toNamed(Routers.initiateWork,
          preventDuplicates: false, arguments: {"data": work});
    }
  }

  void createWork(WorkBreadcrumbNav work) async{
    var defines =await getAllDefine(work);
    Get.toNamed(Routers.workStart, arguments: {"defines": defines,'target':work.space});
  }

  void jumpWorkList(WorkBreadcrumbNav work) {
    Get.toNamed(Routers.workList, arguments: {"data": work});
  }

  Future<void> init() async {
    if (state.model.value!.name == "发起办事") {
      LoadingDialog.showLoading(context);
      List<WorkBreadcrumbNav> initiationWork =
          getInitiationWorkModel([state.model.value!]);
      for (var element in initiationWork) {
        List<ISpeciesItem> species = [];
        for (var target in element.space!.targets) {
          if (target.space == element.space!.space) {
            for (var specie in target.species) {
              switch (SpeciesType.getType(specie.metadata.typeName)) {
                case SpeciesType.market:
                case SpeciesType.application:
                  species.add(specie);
                  (specie as IApplication).loadWorkDefines();
                  break;
              }
            }
          }
        }
        element.children =
            await loadDefines(species, element.space, element.workEnum);
      }
      state.model.refresh();
      LoadingDialog.dismiss(context);
    }
  }

  Future<List<WorkBreadcrumbNav>> loadDefines(List<ISpeciesItem> species,
      [IBelong? space, WorkEnum? workEnum]) async {
    List<WorkBreadcrumbNav> list = [];
    for (var item in species) {
      List<WorkBreadcrumbNav> children = [];
      switch (SpeciesType.getType(item.metadata.typeName)) {
        case SpeciesType.market:
          await (item as IMarket).loadWorkDefines();
          break;
        case SpeciesType.application:
          await (item as IApplication).loadWorkDefines();
          children.addAll(await loadDefines(item.children, space, workEnum));
          break;
        case SpeciesType.flow:
           await (item as IFlowClass).loadWorkDefines();
          children.addAll(await loadDefines(item.children, space, workEnum));
          break;
        default:
          continue;
      }
      list.add(WorkBreadcrumbNav(
          children: children,
          image: item.share.avatar?.shareLink,
          source: item,
          space: space,
          name: item.metadata.name,
          workEnum: workEnum));
    }

    return list;
  }

  List<WorkBreadcrumbNav> getInitiationWorkModel(
      List<WorkBreadcrumbNav> models) {
    List<WorkBreadcrumbNav> list = [];
    for (var value in models) {
      if (value.workEnum == WorkEnum.initiationWork) {
        list.add(value);
      } else if (value.children.isNotEmpty) {
        list.addAll(getInitiationWorkModel(value.children));
      }
    }
    return list;
  }

  Future<List<IWorkDefine>> getAllDefine(WorkBreadcrumbNav model) async{
    List<IWorkDefine> list = [];
    if(model.source?.defines != null){
      await model.source.loadWorkDefines();
      list.addAll(model.source?.defines);
    }else{
      for (var value in model.children) {
        list.addAll(await getAllDefine(value));
      }
    }
    return list;
  }
}
