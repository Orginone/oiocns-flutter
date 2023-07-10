import 'package:flutter/material.dart';
import 'package:flutter_filereader/flutter_filereader.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/other/file_reader/state.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/load_state_widget.dart';

import 'logic.dart';

class FileReaderPage
    extends BaseGetView<FileReaderController, FileReaderState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: state.file.name!,
      body: FutureBuilder<String>(
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if(snapshot.hasData){
            return FileReaderView(filePath: snapshot.data!,

            );
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
