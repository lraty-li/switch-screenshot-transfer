import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:switch_screenshot_transfer/model/page_indicator.dart';
import 'package:switch_screenshot_transfer/routes/route.dart';

class sNavigationBar extends StatelessWidget {
  sNavigationBar({required this.pageIndicator, Key? key}) : super(key: key);
  final PageIndicator pageIndicator;
  final RouteManager _route = RouteManager(); 
  
  _navigationBarItems(BuildContext context) => [
    BottomNavigationBarItem(
      icon: const Icon(Icons.home),
      label: AppLocalizations.of(context)!.home,
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.settings),
      label: AppLocalizations.of(context)!.setting,
    ),
  ];

  int _getPageIndex(PageIndicator indicator){
    return PageIndicator.values.indexOf(indicator);
  }

  String _getPageRouteName(int index){
    return _route.routes[index].name;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: _navigationBarItems(context),
      currentIndex: _getPageIndex(pageIndicator),
      onTap: (index){
        //until ?
        Get.offNamedUntil(_getPageRouteName(index), ((route) => false));
      },
    );
  }
}
