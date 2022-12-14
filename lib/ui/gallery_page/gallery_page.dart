import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:switch_screenshot_transfer/ui/gallery_page/gallery_page_logic.dart';
import 'package:video_player/video_player.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    var logic = Get.put(GalleryPageLogic());
    logic.setAll(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          GetBuilder<GalleryPageLogic>(
              builder: (logic) => IconButton(
                  onPressed: logic.isLoading ? null : logic.saveFile,
                  icon: const Icon(Icons.download))),
          GetBuilder<GalleryPageLogic>(
              builder: (logic) => IconButton(
                  onPressed: logic.isLoading ? null : logic.shareFile,
                  icon: const Icon(Icons.share))),
        ],
      ),
      body: _body(),
    );
  }
}

Widget _body() {
  return WillPopScope(
    onWillPop: () async {
      //TODO dispose hold page to reset scanner?
      // Get.offAllNamed('/home'); 
      return true; //won't return actually
    },
    child: GetBuilder<GalleryPageLogic>(
      builder: (logic) =>
          logic.isLoading ? _downloadingProgress() : _showGallery(),
    ),
  );
}

Widget _downloadingProgress() {
  return Center(
    child: Column(
      children: [
        const CircularProgressIndicator(),
        GetBuilder<GalleryPageLogic>(
            builder: (logic) => Text(
                '${logic.currentProgress} / ${logic.gallery.assetFiles.length}'))
      ],
    ),
  );
}

Widget _showGallery() {
  var logic = Get.find<GalleryPageLogic>();
  var files = logic.gallery.assetFiles;
  return ListView.builder(
      itemCount: files.length,
      itemBuilder: (ctx, index) {
        var type = logic.diffFileType(files[index]);
        switch (type) {
          case FileType.video:
            var controller =
                VideoPlayerController.file(File(files[index].localPath!))
                  ..initialize();
            controller.play();
            controller.setVolume(0);
            controller.setLooping(true);
            return AspectRatio(
              //todo bad hardcode
              aspectRatio: 16 / 9,
              child: VideoPlayer(controller),
            );
          case FileType.image:
            return Image.file(File(files[index].localPath!));
          default:
            return Container();
        }
      });
}
