


import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/store/state.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/unified.dart';

class MessageFile extends StatefulWidget {
  const MessageFile({Key? key}) : super(key: key);

  @override
  State<MessageFile> createState() => _MessageFileState();
}

class _MessageFileState extends State<MessageFile> {

  late FileItemShare fileShare;

  late String type;

  bool fileExists = false;

  DownloadTask? task;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fileShare = Get.arguments['file'];

    type = Get.arguments['type'];

    FileDownloader().database.allRecords().then((records){
      try{
        task = records.firstWhere((element) => element.task.filename == fileShare.name! && element.task.url == fileShare.shareLink!).task as DownloadTask;
        fileExists = task != null;
        setState(() {});
      }catch(e){

      };
    });
    
    if(type == "store"){
      settingCtrl.store.onRecordRecent(
          RecentlyUseModel(type: StoreEnum.file.label, file: FileItemModel.fromJson(fileShare.toJson())));
    }
  }


  @override
  Widget build(BuildContext context) {
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
              fileShare.name!,
              style: XFonts.size26Black0,
            ),
            SizedBox(
              height: 100.h,
            ),
            CommonWidget.commonSubmitWidget(
                text: fileExists ? "打开" : "下载",
                submit: () async {
                  if (fileExists) {
                    openFile();
                  } else {
                    task = DownloadTask(
                        url:fileShare.shareLink!,
                        baseDirectory: BaseDirectory.applicationSupport,
                        filename: fileShare.name!);
                    ToastUtils.showMsg(msg: "开始下载");
                    await FileDownloader().download(task!,onProgress: (prpgress){
                      if(prpgress == 1){
                        FileDownloader().trackTasks();
                        ToastUtils.showMsg(msg: "下载完成");
                        setState(() {
                          fileExists = true;
                        });
                      }
                    });
                  }
                })
          ],
        ),
      ),
    );
  }

  void openFile() async{
    await FileDownloader().openFile(task: task);
  }
}
