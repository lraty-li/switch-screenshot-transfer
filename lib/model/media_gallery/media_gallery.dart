import 'dart:convert';

import 'package:switch_screenshot_transfer/model/asset_file.dart';

class MediaGallery {
  //TODO setting to set
  String host = '192.168.0.1';
  String dataUrn = 'data.json';
  String imgUrn = 'img';
  String _fileNameKey = 'FileNames';
  late List<AssetFile> assetFiles;

  MediaGallery() {
    assetFiles = [];
  }

  fromJson(dynamic data) {
    try {
      var strData = data as String;
      var map = jsonDecode(strData);
      for (var element in map[_fileNameKey]) {
        assetFiles.add(AssetFile(
            url: element, fileName: 'http://${host}/${imgUrn}/${element}'));
      }
    } catch (e) {
      rethrow;
    }
  }
}
