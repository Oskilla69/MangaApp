import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangaapp/shared/muhnga_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);
  static const routeName = '/settings';

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  bool dataSaver = false;
  bool notifications = true;
  bool verticalScroll = true;

  @override
  void initState() {
    super.initState();
    _loadSharedPreferences();
  }

  Future<void> _loadSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dataSaver = prefs.getBool(SHARED_PREFERENCES.DATA_SAVER.parse()) ?? false;
      verticalScroll =
          prefs.getBool(SHARED_PREFERENCES.VERTICAL_SCROLL.parse()) ?? true;
      notifications =
          prefs.getBool(SHARED_PREFERENCES.NOTIFICATIONS.parse()) ?? true;
    });
  }

  Future<void> _setDataSaver(val) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dataSaver = val;
      prefs.setBool(SHARED_PREFERENCES.DATA_SAVER.parse(), val);
    });
  }

  Future<void> _setVerticalDirection(val) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      verticalScroll = val;
      prefs.setBool(SHARED_PREFERENCES.VERTICAL_SCROLL.parse(), val);
    });
  }

  Future<void> _setNotifications(val) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notifications = val;
      prefs.setBool(SHARED_PREFERENCES.NOTIFICATIONS.parse(), val);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(children: [
        SizedBox(
          height: 24.h,
        ),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            buildOrientationToggles(
                'Scroll Left', 'assets/images/scroll_left.png', context, false),
            buildOrientationToggles(
                'Scroll Down', 'assets/images/scroll_down.png', context, true)
          ],
        ),
        // TODO: decide on tooltip?
        // or use subtext?
        Tooltip(
          message:
              'Reduce data usage by viewing lower quality versions of images.',
          child: SwitchListTile(
              title: const Text('Data saver mode'),
              value: dataSaver,
              onChanged: _setDataSaver),
        ),
        Tooltip(
          message: 'Get notifications on the latest manga updates',
          child: SwitchListTile(
              title: const Text('Notifications'),
              value: notifications,
              onChanged: _setNotifications),
        )
      ]),
    );
  }

  Widget buildOrientationToggles(text, iconLocation, context, vertical) {
    return Card(
      color: vertical == verticalScroll
          ? Theme.of(context).backgroundColor
          : Theme.of(context).canvasColor,
      child: InkWell(
        onTap: () => _setVerticalDirection(vertical),
        splashColor: Colors.black26,
        splashFactory: InkRipple.splashFactory,
        child: Column(
          children: [
            Ink.image(
              image: AssetImage(iconLocation),
              height: 120.w,
              width: 120.w,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}
