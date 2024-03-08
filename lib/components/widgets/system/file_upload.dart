import 'package:flutter/material.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:orginone/config/colors.dart';

/// 文件上传
class FileUpload extends StatefulWidget {
  const FileUpload({super.key});

  @override
  State<StatefulWidget> createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: const Text('文件上传'),
        actions: const <Widget>[],
      ),
      body: Container(),
    );
  }
}
