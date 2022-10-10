import 'dart:convert';

import 'package:get/get.dart';
import 'package:switch_screenshot_transfer/model/asset_file.dart';
import 'package:switch_screenshot_transfer/model/media_gallery/media_gallery.dart';
import 'package:switch_screenshot_transfer/model/media_gallery/media_gallery_service.dart';

enum FileType { image, video, unknown }

class GalleryPageLogic extends GetxController {
  MediaGallery gallery = MediaGallery();
  // List<List> imageDatas = [];
  int currentProgress = 0;
  bool isLoading = true;

  @override
  void onInit() {
    var galleryMap = jsonDecode(Get.parameters['gallery']!);
    gallery.formJson(galleryMap);

    super.onInit();
    _downloadAllToLocal();
  }

  FileType diffFileType(AssetFile file) {
    if (file.fileName!.endsWith('.mp4')) {
      return FileType.video;
    } else if (file.fileName!.endsWith('.png')) {
      return FileType.image;
    }
    return FileType.unknown;
  }

  Future<void> shareFile() async {}

  Future<void> saveFile() async {}

  _setProgress(int progress) {
    currentProgress = progress;
    update();
  }

  _downloadAllToLocal() async {
    // isLoading = false;
    // var datas =
    await MediaGalleryService.downLoadToLocal(gallery, _setProgress);
    // if (datas != null) {
    //   imageDatas = datas;
    // }
    isLoading = false;
    update();
  }
}
