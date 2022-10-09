import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:switch_screenshot_transfer/routes/route.dart';

void main() {

  final route = RouteManager();
  runApp(
    GetMaterialApp(
      getPages: route.routes,
      initialRoute: route.initialRoute,
      unknownRoute: route.unknownRoute,
      routingCallback: route.routingCallback,
  ));
}
