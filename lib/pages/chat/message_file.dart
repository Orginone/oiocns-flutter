import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/widgets/index.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/base/model.dart' hide Column;
import 'package:orginone/dart/core/getx/base_bindings.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/chat/widgets/info_item.dart';
import 'package:orginone/utils/load_image.dart';
import 'package:orginone/utils/log/log_util.dart';
import 'package:orginone/utils/toast_utils.dart';
import 'package:orginone/config/unified.dart';

class MessageFilePage
    extends BaseGetView<MessageFileController, MessageFileState> {
  const MessageFilePage({super.key});

  @override
  Widget buildView() {
    return GyScaffold(
      body: Container(
          width: double.infinity,
          color: Colors.white,
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100.h,
                    ),
                    XImage.entityIcon(state.fileShare, width: 60.w),
                    // Icon(
                    //   Icons.file_open,
                    //   size: 60.w,
                    // ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Text(
                      state.fileShare.name!,
                      style: XFonts.size26Black0,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      '文件大小：${getFileSizeString(bytes: state.fileShare.size ?? 0)}',
                      style: XFonts.size16Black9,
                    ),
                  ]),
              Column(
                children: [
                  Obx(() {
                    if (state.downloadStatus.value ==
                        DownloadStatus.downloading) {
                      return Column(
                        children: [
                          Text(
                            "正在接收下载文件",
                            style: XFonts.size16Black9,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          CircularProgressIndicator(
                            value: state.downloadProgress.value,
                            backgroundColor: XColors.statisticsBoxColor,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                XColors.blueTextColor),
                          )
                        ],
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
                  }),
                  SizedBox(
                    height: 200.h,
                  ),
                ],
              ),
            ],
          )),
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
    super.onInit();
    FileDownloader().database.allRecords().then((records) {
      try {
        if (records.isNotEmpty) {
          state.task = records
              .firstWhere(
                  (element) => element.task.filename == state.fileShare.name!)
              .task as DownloadTask;
          state.downloadStatus.value = state.task != null
              ? DownloadStatus.downloadCompleted
              : DownloadStatus.notStarted;
          state.downloadStatus.refresh();
        }
      } catch (e) {
        LogUtil.e(e);
      }
    });
  }

  void downloadFile() async {
    state.task = DownloadTask(
        url: '${Constant.host}${state.fileShare.shareLink}',
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
