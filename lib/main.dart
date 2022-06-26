import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangaapp/pages/home_page.dart';
import 'package:mangaapp/pages/login_page.dart';
import 'package:mangaapp/pages/manga_page.dart';
import 'package:mangaapp/pages/account_page.dart';
import 'package:mangaapp/pages/account_settings_page.dart';
import 'package:mangaapp/pages/display_manga.dart';
import 'package:mangaapp/providers/profile_model.dart';
import 'package:provider/provider.dart';
import 'helpers/appcolours.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: ((context) {
      ProfileModel pfModel = ProfileModel();
      return pfModel;
    })),
  ], child: const Home()));
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
          HomePage.routeName: (context) => const HomePage(),
          MangaPage.routeName: (context) => MangaPage(),
          LoginPage.routeName: (context) => const LoginPage(),
          AccountSettingsPage.routeName: (context) =>
              const AccountSettingsPage(),
          DisplayManga.routeName: (context) => DisplayManga(),
          AccountPage.routeName: (context) => const AccountPage(),
          // '/manga': (c) => Builder(builder: (context) {
          //       return MangaPage();
          //     }),
        },
      );
    });
  }
}
