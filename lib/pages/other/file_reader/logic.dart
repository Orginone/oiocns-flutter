import 'package:background_downloader/background_downloader.dart';
import 'package:get/get.dart';
import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class FileReaderController extends BaseController<FileReaderState> {
  final FileReaderState state = FileReaderState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  Future<String> loadFile() async {
    var tasks = await FileDownloader().database.allRecords();
    dynamic task = tasks
        .firstWhereOrNull((element) =>
            element.task.filename == state.file.name! &&
            element.task.url == state.file.shareLink!)?.task;

    if(task == null){
      task = DownloadTask(
          url: state.file.shareLink!,
          baseDirectory: BaseDirectory.applicationSupport,
          filename: state.file.name!);
      var status =await FileDownloader().download(task!, onProgress: (prpgress) {
        if (prpgress == 1) {
          FileDownloader().trackTasks();
        }
      });
    }
    String path = await task.filePath();

    return path;
  }
}
