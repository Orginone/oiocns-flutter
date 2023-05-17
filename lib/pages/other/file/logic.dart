import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/dart/core/thing/filesys/filesysItem.dart';
import 'package:orginone/dart/core/thing/filesys/filesystem.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class FileController extends BaseBreadcrumbNavController<FileState> {
  final FileState state = FileState();

  SettingController get setting => Get.find();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    var file = (state.model.value!.source as IFileSystemItem);
    bool success = await file.loadChildren();

    if(success){
      state.model.value!.children = file.children.map((e) => BaseBreadcrumbNavModel(name: e.metadata.name??"",source: e)).toList();
      state.model.refresh();
    }

  }

  void onNextLv(BaseBreadcrumbNavModel model) {
    if(model.source.metadata.isDirectory){
      Get.toNamed(Routers.file,arguments: {'data':model},preventDuplicates: false);
    }
  }

  void onSelected(BaseBreadcrumbNavModel item, String selected) async{
    var file = (item.source as IFileSystemItem);
    switch(selected){
      case "createDir":
        break;
      case "refreshDir":
        await file.loadChildren(true);
        break;
      case "uploadFile":
        break;
      case "rename":
        break;
      case "deleteDir":
      case "deleteFile":
        bool success =  await file.delete();
        if(success){
          ToastUtils.showMsg(msg: "删除成功");
          state.model.value!.children.remove(item);
          state.model.refresh();
        }
        break;
    }
  }

}
