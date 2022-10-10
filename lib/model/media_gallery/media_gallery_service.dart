import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:switch_screenshot_transfer/model/media_gallery/media_gallery.dart';

class MediaGalleryService {
// or new Dio with a BaseOptions instance.
  static final _options = BaseOptions(
    // baseUrl: 'https://www.xx.com/api',
    connectTimeout: 2000,
    receiveTimeout: 3000,
  );

  static final _dio = Dio(_options);
  static final _defaultGallery = MediaGallery();

  static downLoadToLocal(MediaGallery gallery) {
    //download all file to local
  }

  static Future<MediaGallery> fromHtml() async {
    //TODO 刚启动的时候如果是switchWiFi，下载
    //parse html
    var gallery = MediaGallery();
    try {
      var response =
          await _dio.get('http://${gallery.host}/${gallery.dataUrn}');
      gallery.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
    return gallery;
  }
}
