import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:mangaapp/components/manga_summary.dart';
import 'package:mangaapp/models/manga.dart';

class MangaPage extends StatelessWidget {
  const MangaPage({Key? key}) : super(key: key);
  // const MangaPage(this.mangaDetails);
  static const String routeName = '/manga';

  @override
  Widget build(BuildContext context) {
    final Manga mangaDetails =
        ModalRoute.of(context)!.settings.arguments as Manga;
    return ScreenUtilInit(builder: ((context, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(mangaDetails.title),
        ),
        body: Container(child: MangaSummary(mangaDetails)),
      );
    }));
  }
}
