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
  bool scannerLocked = false;
  bool canOpenGallery = false;

  String? barcodeCache; // used to avoid onDect triggered muti times

  MediaGallery? _gallery = MediaGallery();

  //TODO destruction , check doc
  final ImagePicker picker = ImagePicker();

  connetToWifi() async {
    ToastHelper.showToast(
        '${AppLocalizations.of(_context)!.pls_connect_to_wifi(wifiConfig.wifiName!)}\n${AppLocalizations.of(_context)!.password(wifiConfig.wifiPwd)} ${AppLocalizations.of(_context)!.has_copied_to_clipboard}');
    autoOpenGallery = true;
    await AppSettings.openWIFISettings(asAnotherTask: true);
  }

  onQrCodeDected(Barcode barcode, MobileScannerArguments? args) async {
    if (barcode.rawValue == null) {
      ToastHelper.showToast('no code');
      return;
    }
    if (barcodeCache != null) {
      return;
    }

    barcodeCache ??= barcode.rawValue;

    switch (barcode.type) {
      case BarcodeType.wifi:
        {
          _setWifiInfo(barcode);
          setClipBoard();
          connetToWifi();
          break;
        }
      case BarcodeType.url:
        break;
      default:
    }
    barcodeCache = null;
  }

  onResume() async {
    // await _setConnectedWifiInfo();
    canOpenGallery = false;
    update();
    // when user scan while correct wifi connected, will open gallery first(resume from picking image)
    try {
      _gallery = await _downloadGallery();
      if (_gallery != null) {
        canOpenGallery = true;
      }
      if (autoOpenGallery && _gallery != null) {
        autoOpenGallery = false;
        openMediaGalleryPage();
      }
    } catch (e) {
      canOpenGallery = false;
    }
    update();
  }

  setAll(BuildContext context) {
    _context = context;
  }

  openMediaGalleryPage() {
    //TODO dispose hold page to reset scanner?
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
      ToastHelper.showToast(
          AppLocalizations.of(_context)!.msg_read_wifi_config_fail);
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
