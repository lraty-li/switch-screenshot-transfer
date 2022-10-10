class WifiInfo {
  //TODO set throuh setting
  static const String pattern = 'switch_';
  String? wifiName;
  String? wifiPwd;

  clear() {
    wifiName = null;
    wifiPwd = null;
  }

  bool isSwitchWifi() {
    if (wifiName == null) {
      return false;
    }
    if (wifiName!.startsWith(pattern)) {
      return true;
    } else {
      return false;
    }
  }
}
