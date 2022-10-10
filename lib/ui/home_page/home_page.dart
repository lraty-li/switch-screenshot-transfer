import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';

import 'package:switch_screenshot_transfer/model/page_indicator.dart';
import 'package:switch_screenshot_transfer/ui/home_page/home_page_logic.dart';
import 'package:switch_screenshot_transfer/ui/navigation_bar/navigation_bar.dart';
import 'package:switch_screenshot_transfer/util/life_cycle_watcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends LifecycleWatcherState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      bottomNavigationBar: sNavigationBar(
        pageIndicator: PageIndicator.homePage,
      ),
    );
  }

  @override
  void onResumed() {
    final logic = Get.find<HomePageLogic>();
    //todo await?
    logic.onResume();
  }
}

Widget _body() {
  final logic = Get.put(HomePageLogic());
  return Column(
    children: [
      _showScanBox(logic),
      _showStepIndicating(logic),
      _showImgSrc(logic)
    ],
  );
}

Widget _showScanBox(HomePageLogic logic) {
  return Expanded(
    child: MobileScanner(
        allowDuplicates: false,
        controller: logic.cameraController,
        onDetect: logic.onQrCodeDected),
  );
}

Widget _showStepIndicating(HomePageLogic logic) {
  return Column(
    children: [
      Row(
        children: [
          Text('1. scan the first qrCode'),
          Icon(Icons.done),
        ],
      ),
      _wifiState(logic),
      Row(
        children: [
          Text('2. scan the second qrCode'),
          Icon(Icons.done),
        ],
      ),
      GetBuilder<HomePageLogic>(
          builder: (logic) => ElevatedButton(
              onPressed:
                  logic.canOpenGallery ? logic.openMediaGalleryPage : null,
              child: Text('open gallery')))
    ],
  );
}

Widget _showImgSrc(HomePageLogic logic) {
  return Row(
    children: [
      ElevatedButton(
          onPressed: logic.pickImgWithCam, child: Text('using system camera')),
      ElevatedButton(
          onPressed: logic.pickImgFromGallery,
          child: Text('choose from gallery'))
    ],
  );
}

Widget _wifiState(HomePageLogic logic) {
  // var currConnectedWifi = logic.currConnectedWifiConfig;
  var scanedWifi = logic.wifiConfig;
  return Column(
    children: [
      GetBuilder<HomePageLogic>(
        builder: ((logic) => Column(
              children: [
                // Text(
                //     'wifi ${currConnectedWifi.wifiName} connected is ${currConnectedWifi.isSwitchWifi() ? '' : 'not'} switch\'s wifi,'),
                Text('scanned wifi : ${scanedWifi.wifiName}'),
              ],
            )),
      ),
      Row(
        children: [
          GetBuilder<HomePageLogic>(
            builder: ((logic) => Text('password: ${logic.wifiConfig.wifiPwd}')),
          ),
          IconButton(onPressed: logic.setClipBoard, icon: Icon(Icons.copy))
        ],
      )
    ],
  );
}
