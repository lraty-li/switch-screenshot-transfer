import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:switch_screenshot_transfer/model/media_gallery/media_gallery.dart';
import 'package:switch_screenshot_transfer/model/media_gallery/media_gallery_service.dart';
import 'package:switch_screenshot_transfer/model/wifi_info/wifi_info.dart';
import 'package:switch_screenshot_transfer/model/wifi_info/wifi_info_service.dart';
import 'package:switch_screenshot_transfer/util/toast.dart';

class HomePageLogic extends GetxController {
  late BuildContext _context;
  MobileScannerController cameraController = MobileScannerController();

  WifiInfo wifiConfig = WifiInfo();

  // WifiInfo currConnectedWifiConfig = WifiInfo();

  WifiInfoService wifiInfoService = WifiInfoService();

  bool autoOpenGallery = false;

  bool canOpenGallery = false;

  MediaGallery? _gallery = MediaGallery();

  //TODO destruction , check doc
  final ImagePicker picker = ImagePicker();

  connetToWifi() async {
    await ToastHelper.showToast(
        '${AppLocalizations.of(_context)!.pls_connect_to_wifi(wifiConfig.wifiName!)}\n${AppLocalizations.of(_context)!.password(wifiConfig.wifiPwd)} ${AppLocalizations.of(_context)!.has_copied_to_clipboard}');
    autoOpenGallery = true;
    await AppSettings.openWIFISettings();
  }

  onQrCodeDected(Barcode barcode, MobileScannerArguments? args) {
    if (barcode.rawValue == null) {
      showErrorMsg();
      return;
    }
    switch (barcode.type) {
      case BarcodeType.wifi:
        {
          _setWifiInfo(barcode);
          setClipBoard();
          update();
          connetToWifi();
          break;
        }
      case BarcodeType.url:
        break;
      default:
    }
  }

  onResume() async {
    // await _setConnectedWifiInfo();
    canOpenGallery = false;
    update();
    _gallery = await _downloadGallery();
    update();
    if (autoOpenGallery && _gallery != null) {
      autoOpenGallery = false;
      openMediaGalleryPage();
    }
  }

  setAll(BuildContext context){
    _context = context;
  }

  showErrorMsg() {}

  openMediaGalleryPage() {
    Get.toNamed('/gallery', parameters: {'gallery': jsonEncode(_gallery)});
  }

  pickImgWithCam() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    await _dectQrCodeFromImg(photo);
  }

  pickImgFromGallery() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    await _dectQrCodeFromImg(image);
  }

  setClipBoard() {
    var wifiPassword = wifiConfig.wifiPwd;
    Clipboard.setData(ClipboardData(text: wifiPassword));
  }

  ///
  /// ** private method **
  ///

  Future<MediaGallery?> _downloadGallery() async {
    try {
      var gallery = await MediaGalleryService.fromHtml();
      canOpenGallery = true;
      return gallery;
    } catch (e) {
      //connect timeout / parse data fail
      canOpenGallery = false;
    }
    return null;
  }

  _setWifiInfo(Barcode barcode) {
    wifiConfig.clear();
    try {
      wifiConfig.wifiName = barcode.wifi!.ssid;
      wifiConfig.wifiPwd = barcode.wifi!.password;
    } catch (e) {
      ToastHelper.showToast('read wifi conf fail');
    }
  }

  // _setConnectedWifiInfo() async {
  //   currConnectedWifiConfig.clear();
  //   await wifiInfoService.updateFromSys(currConnectedWifiConfig);
  // }

  _dectQrCodeFromImg(XFile? imgFile) async {
    if (imgFile == null) {
      return;
    }
    var controller = cameraController;
    await controller.analyzeImage(imgFile.path);
  }
}
