import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangaapp/helpers/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  static const routeName = '/settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool dataSaver = false;
  bool verticalScroll = false;

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
          prefs.getBool(SHARED_PREFERENCES.VERTICAL_SCROLL.parse()) ?? false;
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
                'Scroll Down', 'assets/images/scroll_down.jpeg', context, true)
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
        ListTile(
          leading: const Icon(Icons.delete_forever),
          title: const Text('Delete Account'),
          textColor: Colors.red,
          onTap: () {},
        ),
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
