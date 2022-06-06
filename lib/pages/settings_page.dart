import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiver/iterables.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  static const routeName = '/settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(children: [
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {},
              splashColor: Colors.black26,
              child: Column(
                children: [
                  Ink.image(
                    image: AssetImage('assets/images/scroll_left.png'),
                    height: 120.w,
                    width: 120.w,
                  ),
                  Text('Scroll Left'),
                ],
              ),
            ),
            InkWell(
              onTap: () {},
              splashColor: Colors.black26,
              child: Column(
                children: [
                  Ink.image(
                    image: AssetImage('assets/images/scroll_down.jpeg'),
                    height: 120.w,
                    width: 120.w,
                  ),
                  Text('Scroll Down'),
                ],
              ),
            ),
          ],
        ),
        ListTile(
          leading: const Icon(Icons.delete_forever),
          title: Text('Delete Account'),
          textColor: Colors.red,
          onTap: () {},
        ),
      ]),
    );
  }
}
