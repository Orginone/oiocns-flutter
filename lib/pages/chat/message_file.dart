import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/getx/base_bindings.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/store/state.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/unified.dart';


class MessageFilePage
    extends BaseGetView<MessageFileController, MessageFileState> {
  @override
  Widget buildView() {
    return GyScaffold(
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.file_open,
              size: 60.w,
            ),
            SizedBox(
              height: 40.h,
            ),
            Text(
              state.fileShare.name!,
              style: XFonts.size26Black0,
            ),
            SizedBox(
              height: 100.h,
            ),
            Obx(() {
              return CommonWidget.commonSubmitWidget(
                  text: state.fileExists.value ? "打开" : "下载",
                  submit: () async {
                    if (state.fileExists.value) {
                      controller.openFile();
                    } else {
                      controller.downloadFile();
                    }
                  });
            })
          ],
        ),
      ),
    );
  }


}

class MessageFileBinding extends BaseBindings<MessageFileController> {
  @override
  MessageFileController getController() {
    return MessageFileController();
  }
}

class MessageFileController extends BaseController<MessageFileState> {
  final MessageFileState state = MessageFileState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    FileDownloader().database.allRecords().then((records) {
      try {
        state.task = records
            .firstWhere((element) =>
        element.task.filename == state.fileShare.name! &&
            element.task.url == state.fileShare.shareLink!)
            .task as DownloadTask;
        state.fileExists.value = state.task != null;
      } catch (e) {

      };
    });
  }

  void downloadFile() async {
    state.task = DownloadTask(
        url: state.fileShare.shareLink!,
        baseDirectory: BaseDirectory.applicationSupport,
        filename: state.fileShare.name!);
    ToastUtils.showMsg(msg: "开始下载");
    await FileDownloader().download(state.task!, onProgress: (prpgress) {
      if (prpgress == 1) {
        FileDownloader().trackTasks();
        state.fileExists.value = true;
        ToastUtils.showMsg(msg: "下载完成");
      }
    });
  }

  void openFile() async {
    await FileDownloader().openFile(task: state.task);
  }
}

class MessageFileState extends BaseGetState {
  late FileItemShare fileShare;

  late String type;

  var fileExists = false.obs;

  DownloadTask? task;

  MessageFileState() {
    fileShare = Get.arguments['file'];

    type = Get.arguments['type'];

    if (type == "store") {
      settingCtrl.store.onRecordRecent(
          RecentlyUseModel(type: StoreEnum.file.label,
              file: FileItemModel.fromJson(fileShare.toJson())));
    }
  }
}
