import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:switch_screenshot_transfer/model/asset_file.dart';
import 'package:switch_screenshot_transfer/model/media_gallery/media_gallery.dart';
import 'package:switch_screenshot_transfer/model/media_gallery/media_gallery_service.dart';
import 'package:switch_screenshot_transfer/util/toast.dart';

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
    } else if (file.fileName!.endsWith('.jpg')) {
      return FileType.image;
    }
    return FileType.unknown;
  }

  Future<void> shareFile() async {
    try {
      Share.shareXFiles(
          gallery.assetFiles.map((e) => XFile(e.localPath!)).toList());
    } catch (e) {
      ToastHelper.showToast('share file fail');
    }
  }

  Future<void> saveFile() async {
    // var extPicDirPath =
    //     await getExternalStorageDirectories(type: StorageDirectory.pictures);
    // var localDictory = await Directory(
    //         '${extPicDirPath!.first.path}${Platform.pathSeparator}Switch_Share')
    //     .create(recursive: true);

    for (var element in gallery.assetFiles) {
      await GallerySaver.saveImage(element.localPath!);
    }
    ToastHelper.showToast('files saved to system gallery');
  }

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
