import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/template/originone_scaffold.dart';
import 'package:orginone/widget/unified.dart';

import 'index.dart';

class PDFReaderPage extends GetView<PDFReaderController> {
  const PDFReaderPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return Stack(
      children: [
        _pdfView(),
        controller.errorMessage.isEmpty
            ? !controller.isReady
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container()
            : const Center(
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text('无法识别PDF文件类型或者文件已损坏'),
                ),
              )
      ],
    );
  }

  _pdfView() {
    return controller.pathReady
        ? PDFView(
            filePath: controller.path,
            enableSwipe: false,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: controller.currentPage!,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation: false,
            onRender: (pages) => controller.onRender(pages),
            onError: (error) => controller.onError(error),
            onPageError: (page, error) => controller.onPageError(page, error),
            onViewCreated: (PDFViewController pdfViewController) =>
                controller.onViewCrweated(pdfViewController),
            onLinkHandler: (String? uri) => controller.onLinkHandler(uri),
            onPageChanged: (int? page, int? total) =>
                controller.onPageChanged(page, total))
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PDFReaderController>(
      init: PDFReaderController(),
      id: "pdf_reader_page",
      builder: (_) {
        return GyScaffold(
          titleName: controller.fileModel.name??"",
          body: SafeArea(
            child: _buildView(),
          ),
          floatingActionButton: FutureBuilder<PDFViewController>(
            future: controller.pdfcontroller.future,
            builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
              if (snapshot.hasData) {
                return FloatingActionButton.extended(
                  label: _floatView(snapshot),
                  onPressed: () {},
                );
              }

              return Container();
            },
          ),
        );
      },
    );
  }

  _floatView(AsyncSnapshot<PDFViewController> snapshot) {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              child: const Icon(Icons.arrow_left),
              onTap: () => controller.previousPage(snapshot),
            ),
            Text(" ${controller.currentPage! + 1}/${controller.totalPage!}"),
            GestureDetector(
              child: const Icon(Icons.arrow_right),
              onTap: () => controller.nextPage(snapshot),
            ),
          ],
        )
      ],
    );
  }
}
