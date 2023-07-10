import 'package:orginone/dart/core/getx/base_controller.dart';
import 'state.dart';

class PhotoViewController extends BaseController<PhotoViewState>{
  final PhotoViewState state = PhotoViewState();

  void onPageChanged(int index){
    state.currentIndex.value = index;
  }

}