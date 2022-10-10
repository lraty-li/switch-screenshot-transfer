import 'package:app_settings/app_settings.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:switch_screenshot_transfer/model/wifi_info/wifi_info.dart';
import 'package:switch_screenshot_transfer/model/wifi_info/wifi_info_service.dart';
import 'package:switch_screenshot_transfer/util/toast.dart';

class HomePageLogic extends GetxController {
  MobileScannerController cameraController = MobileScannerController();

  WifiInfo wifiConfig = WifiInfo();

  WifiInfo currConnectedWifiConfig = WifiInfo();

  WifiInfoService wifiInfoService = WifiInfoService();

  //TODO destruction , check doc
  final ImagePicker picker = ImagePicker();

  connetToWifi() async {
    await ToastHelper.showToast(
        'pls connect to wifi ${wifiConfig.wifiName}\n password is ${wifiConfig.wifiPwd}, has copy to clip board');

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
    await _setConnectedWifiInfo();
    update();
  }

  showErrorMsg() {}

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

  _setWifiInfo(Barcode barcode) {
    try {
      wifiConfig.wifiName = barcode.wifi!.ssid;
      wifiConfig.wifiPwd = barcode.wifi!.password;
    } catch (e) {
      ToastHelper.showToast('set wifi conf fail');
    }
  }

  _setConnectedWifiInfo() async {
    await wifiInfoService.updateFromSys(currConnectedWifiConfig);
  }

  _dectQrCodeFromImg(XFile? imgFile) async {
    if (imgFile == null) {
      return;
    }
    var controller = cameraController;
    Barcode galleryBarCode = Barcode(rawValue: '');
    var result = await controller.analyzeImage(imgFile.path);
  }
}
