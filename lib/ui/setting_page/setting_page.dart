import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:switch_screenshot_transfer/model/page_indicator.dart';
import 'package:switch_screenshot_transfer/ui/navigation_bar/navigation_bar.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
      bottomNavigationBar: sNavigationBar(
        pageIndicator: PageIndicator.settingPage,
      ),
    );
  }
}

Widget _body(BuildContext context) {
  return Center(
    child: ElevatedButton(
      child: Row(children: [
        const Icon(Icons.translate),
        Text(AppLocalizations.of(context)!.setting_language_follow_sys)
      ]),
      onPressed: null,
    ),
  );
}
