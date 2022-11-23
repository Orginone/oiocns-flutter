import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoWidget extends StatelessWidget {
  final ImageProvider imageProvider;

  const PhotoWidget({
    Key? key,
    required this.imageProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: imageProvider,
          initialScale: PhotoViewComputedScale.contained * 0.8,
        );
      },
      itemCount: 1,
    );
  }
}
