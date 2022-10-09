import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';

import 'package:switch_screenshot_transfer/model/page_indicator.dart';
import 'package:switch_screenshot_transfer/ui/home_page/home_page_logic.dart';
import 'package:switch_screenshot_transfer/ui/home_page/home_page_state.dart';
import 'package:switch_screenshot_transfer/ui/navigation_bar/navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      bottomNavigationBar: sNavigationBar(
        pageIndicator: PageIndicator.homePage,
      ),
    );
  }
}

Widget _body() {
  final logic = Get.put(HomePageLogic());
  final state = Get.find<HomePageLogic>().state;
  return Column(
    children: [
      _showScanBox(logic, state),
      _showStepIndicating(state),
      _showImgSrc(logic)
    ],
  );
}

Widget _showScanBox(HomePageLogic logic, HomePageState state) {
  return Expanded(
    child: MobileScanner(
        allowDuplicates: false,
        controller: state.cameraController,
        onDetect: logic.onQrCodeDected),
  );
}

Widget _showStepIndicating(HomePageState state) {
  return Column(
    children: [
      Row(
        children: [
          Text('1. scan the first qrCode'),
          Icon(Icons.done),
        ],
      ),
      _wifiState(state),
      Row(
        children: [
          Text('2. scan the second qrCode'),
          Icon(Icons.done),
        ],
      ),
      ElevatedButton(onPressed: null, child: Text('open gallery'))
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

Widget _wifiState(HomePageState state) {
  return Column(
    children: [
      Text('wifi ${state.wifiConfig.wifiName} scanned,'),
      Row(
        children: [
          Text('password: ${state.wifiConfig.wifiPwd}'),
          Icon(Icons.copy)
        ],
      )
    ],
  );
}
