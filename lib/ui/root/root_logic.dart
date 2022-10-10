import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:switch_screenshot_transfer/util/toast.dart';

class RootLogic extends GetxController {
  Future<void> checkPermission() async {
    await Permission.storage.request();

    //depreacatd?
    await Permission.locationWhenInUse.request();
    if (!await Permission.locationWhenInUse.serviceStatus.isEnabled) {
      ToastHelper.showToast('location service disabled, not able to get the connected wifi name ');
    }
    
    Get.toNamed('/home');
  }
}
