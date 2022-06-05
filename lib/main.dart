import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangaapp/pages/home_page.dart';
import 'package:mangaapp/pages/login_page.dart';
import 'package:mangaapp/pages/manga_page.dart';
import 'helpers/appcolours.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: (context, child) {
      return MaterialApp(
        theme: ThemeData.dark().copyWith(),
        // theme: ThemeData(
        //     scaffoldBackgroundColor: Color.fromARGB(115, 72, 71, 71),
        //     primaryColor: BG,
        //     fontFamily: 'Comic Sans'),
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (context) => HomePage(),
          MangaPage.routeName: (context) => MangaPage(),
          LoginPage.routeName: (context) => LoginPage(),
          // '/manga': (c) => Builder(builder: (context) {
          //       return MangaPage();
          //     }),
        },
      );
    });
  }
}
