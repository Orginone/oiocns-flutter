import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';
import 'package:orginone/components/widgets/keep_alive_widget.dart';
import 'package:orginone/utils/index.dart';
import 'package:photo_manager/photo_manager.dart';
import 'controller.dart';
import 'state.dart';

class PhotoViewPage extends BaseGetView<PhotoViewController, PhotoViewState> {
  const PhotoViewPage({super.key});

  @override
  Widget buildView() {
    return GyScaffold(
      appBarColor: Colors.transparent,
      titleWidget: Obx(() {
        return Text(
          "${state.currentIndex.value + 1}/${state.images.length}",
          style: const TextStyle(color: Colors.white),
        );
      }),
      backColor: Colors.white,
      backgroundColor: Colors.black,
      body: InkWell(
        onTap: () {
          Get.back();
        },
        child: Stack(
          children: <Widget>[
            ExtendedImageGesturePageView.builder(
              itemCount: state.images.length,
              itemBuilder: (context, index) {
                var image = state.images[index];
                ImageProvider provider;
                if (image is AssetEntity) {
                  provider = AssetEntityImageProvider(image);
                } else {
                  if (FileUtils.isAssetsImg(image)) {
                    provider = AssetImage(image);
                  } else if (FileUtils.isNetworkImg(image)) {
                    provider = CachedNetworkImageProvider(image);
                  } else {
                    provider = ExtendedResizeImage(
                      FileImage(File(image)),
                      width: 375,
                    );
                  }
                }
                return KeepAliveWidget(
                  child: ExtendedImage(
                    image: provider,
                    fit: BoxFit.contain,
                    mode: ExtendedImageMode.gesture,
                    clearMemoryCacheWhenDispose: true,
                    initGestureConfigHandler: (state) {
                      return GestureConfig(
                        inPageView: true,
                        minScale: 0.5,
                      );
                    },
                  ),
                );
              },
              controller: state.pageController,
              onPageChanged: (index) {
                controller.onPageChanged(index);
              },
            ),
          ],
        ),
      ),
    );
  }
}
