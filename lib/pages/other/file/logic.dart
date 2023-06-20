import 'dart:convert';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/dart/core/thing/file_info.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/store/state.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/loading_dialog.dart';

import 'state.dart';

class FileController extends BaseBreadcrumbNavController<FileState> {
  final FileState state = FileState();


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    var file = (state.model.value!.source as ISysFileInfo);
    // bool success = await file.loadChildren();
    //
    // if(success){
    //   state.model.value!.children = file.children.map((e) => BaseBreadcrumbNavModel(name: e.metadata.name??"",source: e)).toList();
    //   state.model.refresh();
    // }
  }

  void onNextLv(BaseBreadcrumbNavModel model) {
    if(model.source.metadata.isDirectory){
      Get.toNamed(Routers.file,arguments: {'data':model},preventDuplicates: false);
    }else{
      settingCtrl.store.onRecordRecent(
          RecentlyUseModel(type: StoreEnum.file.label, file: model.source.metadata));
      Get.toNamed(Routers.messageFile,arguments: model.source.metadata.shareInfo());
    }
  }

  void onSelected(BaseBreadcrumbNavModel item, String selected) async{
    switch(selected){
      case "createDir":
        createDir(item);
        break;
      case "refreshDir":
        await item.source.loadChildren(true);
        break;
      case "uploadFile":
        uploadFile(item);
        break;
      case "rename":
        rename(item);
        break;
      case "deleteDir":
      case "deleteFile":
        delete(item);
        break;
      case "set":
        settingCtrl.store
            .setMostUsed(storeEnum: StoreEnum.file, file: item.source.metadata);
        break;
      case "delete":
        String id = base64.encode(utf8.encode(item.source.metadata.name));
        settingCtrl.store.removeMostUsed(id);
        break;
    }
  }

  Future<void> uploadFile(BaseBreadcrumbNavModel nav) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      LoadingDialog.showLoading(context);
      for (PlatformFile item in result.files) {
        ISysFileInfo? fileSystemItem = await nav.source.upload(
          item.name,
          File(item.path!),
          (progress) {},
        );
        if (fileSystemItem != null) {
          nav.children.add(BaseBreadcrumbNavModel(
            source: fileSystemItem,
            name: fileSystemItem.metadata.name!,
            children: [],
          ));
          state.model.refresh();
        }
      }
      LoadingDialog.dismiss(context);
    }
  }

  Future<void> rename(BaseBreadcrumbNavModel item) async {
    showTextInputDialog(
            context: context,
            textFields: [
              DialogTextField(
                hintText: item.source.metadata.name,
              )
            ],
            title: "修改${item.source.metadata.name}名称")
        .then((str) {
      if (str != null && str[0].isNotEmpty) {
        item.source.rename(str[0]).then((value) {
          if (value) {
            ToastUtils.showMsg(msg: "修改成功");
            item.name = str[0];
            state.model.refresh();
          }
        });
      }
    });
  }

  Future<void> createDir(BaseBreadcrumbNavModel item) async {
    showTextInputDialog(
            context: context,
            textFields: [
              const DialogTextField(
                hintText: "请输入文件夹名称",
              ),
            ],
            title: "创建文件夹")
        .then((str) {
      if (str != null && str[0].isNotEmpty) {
        item.source.create(str[0]).then((dir) {
          if (dir != null) {
            ToastUtils.showMsg(msg: "创建成功");
            item.children.add(BaseBreadcrumbNavModel(
              source: dir,
              name: dir.metadata.name!,
              children: [],
            ));
            state.model.refresh();
          }
        });
      }
    });
  }

  Future<void> delete(BaseBreadcrumbNavModel item) async {
    bool success = await item.source.delete();
    if (success) {
      ToastUtils.showMsg(msg: "删除成功");
      state.model.value!.children.remove(item);
      state.model.refresh();
    }
  }
}
