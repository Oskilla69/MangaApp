import 'package:algolia/algolia.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangaapp/pages/account_page_no_user.dart';
import 'package:mangaapp/pages/comments_page.dart';
import 'package:mangaapp/pages/home_page.dart';
import 'package:mangaapp/pages/login_page.dart';
import 'package:mangaapp/pages/manga_page.dart';
import 'package:mangaapp/pages/account_page.dart';
import 'package:mangaapp/pages/account_settings_page.dart';
import 'package:mangaapp/pages/display_manga.dart';
import 'package:mangaapp/providers/profile_model.dart';
import 'package:provider/provider.dart';
import 'helpers/appcolours.dart';

class Application {
  static final Algolia algolia = Algolia.init(
    applicationId: dotenv.env['ALGOLIA_APP_ID']!,
    apiKey: dotenv.env['ALGOLIA_SEARCH_API_KEY']!,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: '.env');
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
        // routes: {
        //   HomePage.routeName: (context) => const HomePage(),
        //   MangaPage.routeName: (context) => MangaPage(),
        //   LoginPage.routeName: (context) => const LoginPage(),
        //   AccountSettingsPage.routeName: (context) =>
        //       const AccountSettingsPage(),
        //   DisplayManga.routeName: (context) => DisplayManga(),
        //   AccountPage.routeName: (context) => const AccountPage(),
        //   // '/manga': (c) => Builder(builder: (context) {
        //   //       return MangaPage();
        //   //     }),
        // },
        onGenerateRoute: (settings) {
          late Widget page;
          if (settings.name == HomePage.routeName) {
            page = const HomePage();
          } else if (settings.name == LoginPage.routeName) {
            page = const LoginPage();
          } else if (settings.name == AccountSettingsPage.routeName) {
            page = const AccountSettingsPage();
          } else if (settings.name == AccountPage.routeName) {
            page = const AccountPage();
          } else if (settings.name == AccountPageNoUser.routeName) {
            page = const AccountPageNoUser();
          } else if (settings.name == MangaPage.routeName) {
            var data = settings.arguments as Map<String, dynamic>;
            page = MangaPage(
              mangaDetails: data,
            );
          } else if (settings.name == DisplayManga.routeName) {
            var data = settings.arguments as Map<String, dynamic>;
            page = DisplayManga(mangaData: data);
          } else if (settings.name == CommentsPage.routeName) {
            var data = settings.arguments as Map<String, dynamic>;
            page = CommentsPage(mangaData: data);
          } else {
            throw Exception('Unknown Route ${settings.name}');
          }

          return MaterialPageRoute(
              builder: (context) => page, settings: settings);
        },
      );
    });
  }
}
