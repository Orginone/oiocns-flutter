import 'package:flutter/material.dart';
// import 'package:flutter_filereader/flutter_filereader.dart';
import 'package:orginone/components/modules/file_reader/index.dart';
import 'package:orginone/components/widgets/index.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';

class FileReaderPage
    extends BaseGetView<FileReaderController, FileReaderState> {
  const FileReaderPage({super.key});

  @override
  Widget buildView() {
    return GyScaffold(
      titleName: state.file.name!,
      body: FutureBuilder<String>(
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return const Text('文档预览');
            // return FileReaderView(
            //   filePath: snapshot.data!,
            // );
          }
          return LoadStateWidget(
            isSuccess: snapshot.hasData,
            isLoading: !snapshot.hasData,
            child: Container(),
          );
        },
        future: controller.loadFile(),
      ),
    );
  }
}
