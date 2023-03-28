import 'package:orginone/dart/core/store/ifilesys.dart';
import 'package:orginone/util/file_management.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class FileController extends BaseController<FileState> {
  final FileState state = FileState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    state.file.value ??= FileManagement().directory;
    state.title.value = state.file.value?.target?.name ?? "";
    // if(state.file.value?.parent!=null && state.file.value?.parent?.target?.name!="根目录"){
    //
    //   var dir = state.file.value?.parent;
    //   while(dir!=null || dir!.target?.name!="根目录"){
    //     state.selectedDir.insert(0, dir);
    //     dir = dir.parent;
    //   }
    // }
  }

  void clearGroup() {
    state.selectedDir.clear();
  }

  void removeGroup(index) {
    state.selectedDir.removeRange(index+1, state.selectedDir.length);
    state.selectedDir.refresh();
  }

  void search(String str) {}

  void selectFile(IFileSystemItem item) {
    if(item.target?.isDirectory??false){
      state.selectedDir.add(item);
      state.title.value = item.target?.name??"";
    }
  }
}
