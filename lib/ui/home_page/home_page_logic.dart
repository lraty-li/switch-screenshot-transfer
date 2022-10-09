import 'dart:async';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:switch_screenshot_transfer/ui/home_page/home_page_state.dart';

class HomePageLogic extends GetxController {
  final HomePageState state = HomePageState();

  onQrCodeDected(Barcode barcode, MobileScannerArguments? args) {
    if (barcode.rawValue == null) {
      showErrorMsg();
      return;
    }
    switch (barcode.type) {
      case BarcodeType.wifi:
        
        break;
      case BarcodeType.url:
        
        break;
      default:
    }
  }

  showErrorMsg() {}

  pickImgWithCam() async {
    final XFile? photo =
        await state.picker.pickImage(source: ImageSource.camera);
    await _dectQrCodeFromImg(photo);
  }

  pickImgFromGallery() async {
    final XFile? image =
        await state.picker.pickImage(source: ImageSource.gallery);
    await _dectQrCodeFromImg(image);
  }

  /// 
  /// ** private method **
  /// 
  
  _setWifiInfo(){
    
  }

  _dectQrCodeFromImg(XFile? imgFile) async {
    if (imgFile == null) {
      return;
    }
    var controller = state.cameraController;
    Barcode galleryBarCode = Barcode(rawValue: '');

    late StreamSubscription sub;
    sub = controller.barcodesController.stream.listen((barcode) {
      if (barcode.rawValue == null) {
        print('Failed to scan Barcode');
      } else {
        galleryBarCode = barcode;
        print("sent one code to be elaborated");
      }
      sub.cancel();
    });
    var result = await controller.analyzeImage(imgFile.path);
    if (result == true) {
      //TODO use galleryBarCode do someThing
      print('gallery qrCode dected');
      onQrCodeDected(galleryBarCode, null);
    }
  }
}
