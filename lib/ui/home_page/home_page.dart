import 'package:flutter/material.dart';
// import 'package:get/get.dart';

import 'package:switch_screenshot_transfer/model/page_indicator.dart';
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
      // floatingActionButton: FloatingActionButton(onPressed: () => Get.back(),),
      bottomNavigationBar: sNavigationBar(
        pageIndicator: PageIndicator.homePage,
      ),
    );
  }
}
