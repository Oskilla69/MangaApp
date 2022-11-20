import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'comments_page/screens/comments_page.dart';
import 'pages/account_page_no_user.dart';
import 'home_page/screens/home_page.dart';
import 'login_page/screens/login_page.dart';
import 'manga_page/screens/manga_page.dart';
import 'pages/account_page.dart';
import 'pages/account_settings_page.dart';
import 'manga_reader_page/screens/manga_reader_page.dart';
import 'providers/profile_model.dart';
import 'shared/muhnga_colors.dart';
import 'shared/supabase/supabase_constants.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Supabase.initialize(
      url: SupabaseConstants.projectUrl, anonKey: SupabaseConstants.apiKey);
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
        theme: ThemeData.dark().copyWith(
            cardTheme: const CardTheme(elevation: 0, color: Colors.transparent),
            appBarTheme: const AppBarTheme(
                elevation: 0, backgroundColor: Colors.transparent),
            scaffoldBackgroundColor: MuhngaColors.darkGrey,
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: MuhngaColors.darkGrey),
            textTheme: const TextTheme(
                titleSmall: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins"),
                titleMedium: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins"),
                titleLarge: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins"),
                bodySmall: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins"),
                bodyMedium: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins"),
                bodyLarge: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins"))),

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
          } else if (settings.name == MangaReader.routeName) {
            var data = settings.arguments as Map<String, dynamic>;
            page = MangaReader(mangaData: data);
          } else if (settings.name == CommentsPage.routeName) {
            // var data = settings.arguments as Map<String, dynamic>;
            // page = CommentsPage(mangaData: data);
            page = CommentsPage();
          } else {
            throw Exception('Unknown Route ${settings.name}');
          }

          return MaterialPageRoute(
              builder: (context) => GestureDetector(
                  onHorizontalDragEnd: (details) {
                    String? currRoute = ModalRoute.of(context)!.settings.name;
                    if (details.primaryVelocity != null &&
                        details.primaryVelocity! >= 320 &&
                        currRoute != HomePage.routeName &&
                        currRoute != MangaReader.routeName) {
                      print("swiping back");
                      Navigator.pop(context);
                    }
                  },
                  child: page),
              settings: settings);
        },
      );
    });
  }
}
