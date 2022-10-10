import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
      body: _body(context),
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

Widget _body(BuildContext context) {
  final logic = Get.put(HomePageLogic());
  logic.setAll(context);
  return Column(
    children: [
      _showScanBox(logic),
      _showStepIndicating(context, logic),
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

Widget _showStepIndicating(BuildContext context, HomePageLogic logic) {
  return Column(
    children: [
      // Row(
      //   children: [
      //     Text(AppLocalizations.of(context)!.scan_first_qrCode),
      //   ],
      // ),
      _wifiState(context, logic),
      // Row(
      //   children: [
      //     Text(AppLocalizations.of(context)!.scan_second_qrCode),
      //   ],
      // ),
      GetBuilder<HomePageLogic>(
          builder: (logic) => ElevatedButton(
              onPressed:
                  //TODO 自动重试（检测是否连接了switch wifi的唯一方式）
                  logic.canOpenGallery ? logic.openMediaGalleryPage : null,
              child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text(AppLocalizations.of(context)!.open_gallery))))
    ],
  );
}

Widget _showImgSrc(HomePageLogic logic) {
  return Row(
    children: [
      IconButton(
          onPressed: logic.pickImgWithCam,
          icon: const Icon(Icons.photo_camera)),
      IconButton(
          onPressed: logic.pickImgFromGallery,
          icon: const Icon(Icons.photo_library))
    ],
  );
}

Widget _wifiState(BuildContext context, HomePageLogic logic) {
  // var currConnectedWifi = logic.currConnectedWifiConfig;
  var scanedWifi = logic.wifiConfig;
  return Column(
    children: [
      GetBuilder<HomePageLogic>(
        builder: ((logic) => Column(
              children: [
                // Text(
                //     'wifi ${currConnectedWifi.wifiName} connected is ${currConnectedWifi.isSwitchWifi() ? '' : 'not'} switch\'s wifi,'),
                Text(AppLocalizations.of(context)!
                    .scaned_wifi(scanedWifi.wifiName)),
              ],
            )),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GetBuilder<HomePageLogic>(
            builder: ((logic) => Text(
                AppLocalizations.of(context)!.password(scanedWifi.wifiPwd))),
          ),
          IconButton(
              onPressed: logic.setClipBoard, icon: const Icon(Icons.copy))
        ],
      )
    ],
  );
}
