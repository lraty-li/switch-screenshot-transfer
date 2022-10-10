import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:switch_screenshot_transfer/model/media_gallery/media_gallery.dart';

class MediaGalleryService {
// or new Dio with a BaseOptions instance.
  static final _options = BaseOptions(
    // baseUrl: 'https://www.xx.com/api',
    connectTimeout: 2000,
  );

  static final _dio = Dio(_options);
  static final _defaultGallery = MediaGallery();

  static Future<List<List>?> downLoadToLocal(
      MediaGallery gallery, Function(int) progressCallBack) async {
    //download all file to local
    var progress = 0;
    var imgsDatas = <List>[];
    var tempDir = await getTemporaryDirectory();
    for (var element in gallery.assetFiles) {
      try {
        element.localPath =
            "${tempDir.path}${Platform.pathSeparator}${element.fileName}";
        await _dio.download(element.url!, element.localPath);
        // var response = await _dio.get(element.url!,
        //     options: Options(responseType: ResponseType.bytes));
        progress += 1;
        // imgsDatas.add(response.data);
        progressCallBack(progress);
      } catch (e) {
        rethrow;
      }
    }
    return imgsDatas;
  }

  static Future<MediaGallery> fromHtml() async {
    //TODO 刚启动的时候如果是switchWiFi，下载
    //parse html
    var gallery = MediaGallery();
    try {
      var response =
          await _dio.get('http://${gallery.host}/${gallery.dataUrn}');
      gallery.fromDataJson(response.data);
    } catch (e) {
      rethrow;
    }
    return gallery;
  }
}
