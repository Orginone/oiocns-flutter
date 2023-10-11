import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart' hide Column;
import 'package:orginone/dart/core/getx/base_bindings.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/unified.dart';

class MessageFilePage
    extends BaseGetView<MessageFileController, MessageFileState> {
  const MessageFilePage({super.key});

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
              if (state.downloadStatus.value == DownloadStatus.downloading) {
                return CircularProgressIndicator(
                  value: state.downloadProgress.value,
                  backgroundColor: XColors.statisticsBoxColor,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      XColors.blueTextColor),
                );
              }
              return CommonWidget.commonSubmitWidget(
                  text: state.downloadStatus.value ==
                          DownloadStatus.downloadCompleted
                      ? "打开"
                      : "下载",
                  submit: () async {
                    if (state.downloadStatus.value ==
                        DownloadStatus.downloadCompleted) {
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
  @override
  final MessageFileState state = MessageFileState();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    FileDownloader().database.allRecords().then((records) {
      print('');
      try {
        state.task = records
            .firstWhere(
                (element) => element.task.filename == state.fileShare.name!)
            .task as DownloadTask;
        state.downloadStatus.value = state.task != null
            ? DownloadStatus.downloadCompleted
            : DownloadStatus.notStarted;
        state.downloadStatus.refresh();
      } catch (e) {
        print(e);
      }
    });
  }

  void downloadFile() async {
    state.task = DownloadTask(
        url: state.fileShare.shareLink!,
        baseDirectory: BaseDirectory.applicationSupport,
        filename: state.fileShare.name!);
    ToastUtils.showMsg(msg: "开始下载");
    state.downloadStatus.value = DownloadStatus.downloading;
    await FileDownloader().download(state.task!, onProgress: (prpgress) {
      state.downloadProgress.value = prpgress;
      if (prpgress == 1) {
        FileDownloader().trackTasks();
        state.downloadStatus.value = DownloadStatus.downloadCompleted;
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

  var downloadStatus = DownloadStatus.notStarted.obs;

  var downloadProgress = 0.0.obs;

  DownloadTask? task;

  MessageFileState() {
    fileShare = Get.arguments['file'];
  }
}

enum DownloadStatus {
  notStarted,
  downloading,
  downloadCompleted,
}
