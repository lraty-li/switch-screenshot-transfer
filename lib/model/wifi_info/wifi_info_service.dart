import 'package:network_info_plus/network_info_plus.dart';
import 'package:switch_screenshot_transfer/model/wifi_info/wifi_info.dart';

class WifiInfoService {
  static final networkInfo = NetworkInfo();
  isSwitchWifi(WifiInfo info) {}

  Future<WifiInfo> fromSys() async {
    var wifiInfo = WifiInfo();
    wifiInfo.wifiName = await _getWifiNameFromSys();
    return wifiInfo;
  }

  updateFromSys(WifiInfo info) async {

    info.wifiName = await _getWifiNameFromSys(); // "FooNetwork"
  }

  Future<String?> _getWifiNameFromSys() async {
    var wifiName = await networkInfo.getWifiName();
    return wifiName;
  }
}
