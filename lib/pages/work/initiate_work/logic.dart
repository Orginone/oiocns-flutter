import 'package:get/get.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/thing/app/application.dart';
import 'package:orginone/dart/core/thing/base/work.dart';
import 'package:orginone/dart/core/thing/market/market.dart';
import 'package:orginone/routers.dart';

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

  void createWork(WorkBreadcrumbNav work) {
    var defines = getAllDefine(work);
    Get.toNamed(Routers.workStart, arguments: {"defines": defines});
  }

  void jumpWorkList(WorkBreadcrumbNav work) {
    Get.toNamed(Routers.workList, arguments: {"data": work});
  }

  Future<void> init() async {
    if (state.model.value!.name == "发起办事") {
      List<WorkBreadcrumbNav> initiationWork =
          getInitiationWorkModel([state.model.value!]);
      for (var element in initiationWork) {
        await loadDefines(element);
      }
      state.model.refresh();
    }
  }

  Future<void> loadDefines(WorkBreadcrumbNav model) async {
    var space = model.space;
    model.children = [];
    for (var element in space!.targets) {
      for (var item in element.species) {
        List<WorkBreadcrumbNav> children = [];
        if ((item.metadata.typeName ==
            SpeciesType.application.label ||
            item.metadata.typeName == SpeciesType.market.label) && item.belongId == space.belongId) {
          try {
            await (item as IMarket).loadWorkDefines();
          } catch (e) {
            await (item as IApplication).loadWorkDefines();
          }
          for (var element in item.children) {
            if (element is IWork || element is IApplication) {
              if ((element as dynamic).defines.isNotEmpty) {
                children.add(WorkBreadcrumbNav(
                    children: [],
                    image: element.share.avatar?.shareLink,
                    source: element,
                    space: model.space,
                    name: element.metadata.name,
                    workEnum: model.workEnum));
              }
            }
          }

          model.children.add(WorkBreadcrumbNav(
              children: children,
              image: item.share.avatar?.shareLink,
              source: item,
              space: model.space,
              name: item.metadata.name,
              workEnum: model.workEnum));
        }
      }
    }
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

  List<IWorkDefine> getAllDefine(WorkBreadcrumbNav model) {
    List<IWorkDefine> list = [];
    if(model.source?.defines != null){
      list.addAll(model.source?.defines);
    }
    if(list.isEmpty){
      for (var value in model.children) {
        if(value.source?.defines != null){
          list.addAll(value.source?.defines);
        }else{
          list.addAll(getAllDefine(value));
        }
      }
    }
    return list;
  }
}
