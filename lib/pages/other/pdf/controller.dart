import 'dart:async';
import 'dart:io';
import 'dart:math';
// import 'package:flutter_cache_manager/file.dart'; //导入file.dart文件得时候要注意千万不能错 实际使用得是import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/model/file_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

///枚举类型类
Logger logger = Logger('PDFReaderController');

class PDFReaderController extends GetxController {
  PDFReaderController();

  final Completer<PDFViewController> pdfcontroller =
      Completer<PDFViewController>();

  ///总页数
  int? totalPage = 0;

  ///当前页 第一页下标为0
  int? currentPage = 0;
  bool isReady = false;
  bool pathReady = false;
  String errorMessage = '';
  FileModel? fileModel;
  String? path;
  _initData() {
    ///判断是否是网络链接
    if (fileModel!.fileType == FileType.pdf) {
      ///判断是否是网络链接
      if (fileModel!.filePath.startsWith("http")) {
        createFileOfPdfUrl().then((f) {
          path = f.path;
          pathReady = true;
          update(["pdf_reader_page"]);
        });
      } else {
        fromAsset().then((f) {
          path = f.path;
          pathReady = true;
          update(["pdf_reader_page"]);
        });
      }
    }
    update(["pdf_reader_page"]);
  }

  void onTap() {}

  @override
  void onInit() {
    super.onInit();

    ///获取路由传参
    fileModel = Get.arguments ?? '';
    _initData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  ///pdf加载完成
  onRender(int? pages) {
    totalPage = pages;
    isReady = true;
    logger.info('onRender: $pages');
    update(["pdf_reader_page"]);
  }

  ///页面切换
  onPageChanged(int? page, int? total) {
    logger.info('page change: $page/$total');

    currentPage = page!;

    update(["pdf_reader_page"]);
  }

  ///链接跳转
  onLinkHandler(String? uri) {
    logger.info('goto uri: $uri');
    update(["pdf_reader_page"]);
  }

  ///pdf加载完成
  onViewCrweated(PDFViewController pdfViewController) {
    pdfcontroller.complete(pdfViewController);
    update(["pdf_reader_page"]);
  }

  ///pdf加载错误
  onPageError(int? page, error) {
    errorMessage = '$page: ${error.toString()}';
    update(["pdf_reader_page"]);
    logger.info('$page: ${error.toString()}');
  }

  ///pdf加载错误
  onError(error) {
    errorMessage = error.toString();
    update(["pdf_reader_page"]);
    logger.info(error.toString());
  }

  //跳转页码
  nextPage(AsyncSnapshot<PDFViewController> snapshot) async {
    if (currentPage! < totalPage!) {
      await snapshot.data!.setPage(currentPage! + 1);
    }
  }

  ///上一页
  previousPage(AsyncSnapshot<PDFViewController> snapshot) async {
    if (currentPage! > 0) {
      update(["pdf_reader_page"]);
      await snapshot.data!.setPage(currentPage! - 1);
    }
  }

  ///从本地加载PDF
  Future<File> fromAsset() async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/${fileModel?.fileName}");

      var data = await rootBundle.load(fileModel?.filePath ?? '');
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  ///从网络加载PDF
  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    logger.info("Start download file from internet!");
    try {
      // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
      // final url = "https://pdfkit.org/docs/guide.pdf";
      // const url = "http://www.pdf995.com/samples/pdf.pdf";
      final url = fileModel?.filePath ?? '';
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      logger.info("Download files");
      logger.info("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }
}
