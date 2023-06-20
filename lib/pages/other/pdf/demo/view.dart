import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/model/file_model.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/template/originone_scaffold.dart';
import 'package:orginone/widget/unified.dart';

import 'index.dart';

class PDFReaderDemoPage extends GetView<PDFReaderDemoController> {
  const PDFReaderDemoPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return Center(
        child: Column(children: [
      TextButton(
        child: const Text("Open PDF"),
        onPressed: () {
          Get.toNamed(
            Routers.pdfReader,
            arguments: FileModel(
                filePath: 'assets/demo-link.pdf',
                fileName: 'demo.pdf',
                fileType: FileType.pdf),
          );
        },
      ),
      TextButton(
        child: const Text("Open Landscape PDF"),
        onPressed: () {
          Get.toNamed(Routers.pdfReader,
              arguments: FileModel(
                  filePath: 'assets/demo-landscape.pdf',
                  fileName: 'landscape.pdf',
                  fileType: FileType.pdf));
        },
      ),
      TextButton(
        child: const Text("Remote PDF"),
        onPressed: () {
          Get.toNamed(Routers.pdfReader,
              arguments: FileModel(
                  filePath: 'http://www.pdf995.com/samples/pdf.pdf',
                  fileType: FileType.pdf));
        },
      ),
      TextButton(
        child: const Text("Open Corrupted PDF"),
        onPressed: () {
          Get.toNamed(Routers.pdfReader,
              arguments: FileModel(
                  filePath: 'assets/corrupted.pdf',
                  fileName: 'corrupted.pdf',
                  fileType: FileType.pdf));
        },
      )
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PDFReaderDemoController>(
      init: PDFReaderDemoController(),
      id: "pdf_reader_demo",
      builder: (_) {
        return OrginoneScaffold(
          appBarLeading: XWidgets.defaultBackBtn,
          appBarTitle: Text("pdf样例", style: XFonts.size22Black3),
          appBarCenterTitle: true,
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
