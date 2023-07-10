import 'package:extended_image/extended_image.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class PhotoViewState extends BaseGetState {
  late List<dynamic> images;
  late ExtendedPageController pageController;
  var currentIndex = 0.obs;

  PhotoViewState(){
    Map<String,dynamic>? args = Get.arguments;
    images = args?["images"] ?? [];
    int index = args?["index"] ?? 0;
    currentIndex.value = index;
    pageController =
        ExtendedPageController(initialPage: index);
  }

}
