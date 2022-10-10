import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/observers/route_observer.dart';
import 'package:switch_screenshot_transfer/ui/gallery_page/gallery_page.dart';
import 'package:switch_screenshot_transfer/ui/home_page/home_page.dart';
import 'package:switch_screenshot_transfer/ui/root/root.dart';
import 'package:switch_screenshot_transfer/ui/setting_page/setting_page.dart';

class RouteManager {
  final routes = [
    GetPage(name: '/home', page: () => const HomePage()),
    GetPage(name: '/setting', page: () => const SettingPage()),
    GetPage(name: '/gallery', page: () => const GalleryPage()),
    //keep this in the end
    GetPage(name: '/', page: () => const Root()),
  ];
  String get initialRoute => '/';
  GetPage get unknownRoute => routes.first;

  void routingCallback(Routing? routing) {}
}
