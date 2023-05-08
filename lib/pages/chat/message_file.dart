


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/util/download_utils.dart';
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

  late String url;

  late String name;

  late String extension;

  late bool fileExists;

  DownloadTaskInfo? info;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    url = Get.arguments['shareLink'];
    name = Get.arguments['name'];
    info =  DownloadUtils().findFile(name);
    fileExists = info!=null;
    extension = Get.arguments['extension'];
    DownloadUtils().addTaskListen((event) {
      if(event.last.status == DownloadTaskStatus.complete){
        setState(() {
          ToastUtils.showMsg(msg: "下载完成");
          info = event.last;
          fileExists = true;
        });
      }
    });
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
            Icon(Icons.file_open,size: 60.w,),
            SizedBox(height: 40.h,),
            Text(
              name,
              style: XFonts.size26Black0,
            ),
            SizedBox(height: 100.h,),
            CommonWidget.commonSubmitWidget(text: fileExists?"打开":"下载",submit: (){
              if(fileExists){
                DownloadUtils().open(info!);
              }else{
                DownloadUtils().save(DownloadModel(name: name, downloadUrl: url,type: extension));
              }

            })
          ],
        ),
      ),
    );
  }
}
