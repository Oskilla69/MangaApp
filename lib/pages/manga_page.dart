import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:mangaapp/components/manga_summary.dart';
import 'package:mangaapp/models/manga.dart';
import 'package:mangaapp/providers/profile_model.dart';
import 'package:provider/provider.dart';

class MangaPage extends StatefulWidget {
  const MangaPage({Key? key, required this.mangaDetails}) : super(key: key);
  // const MangaPage(this.mangaDetails);
  final Map<String, dynamic> mangaDetails;
  static const String routeName = '/manga';

  @override
  State<MangaPage> createState() => _MangaPageState();
}

class _MangaPageState extends State<MangaPage> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileModel>(context, listen: false);
    List<dynamic> bookmarks = profileProvider.bookmarks;
    return ScreenUtilInit(builder: ((context, child) {
      return Scaffold(
          appBar: AppBar(
            title: Text(widget.mangaDetails['title']),
            actions: [
              bookmarks.contains(widget.mangaDetails['title'])
                  ? IconButton(
                      onPressed: () {
                        print('delete');
                        if (profileProvider.email.isNotEmpty) {
                          profileProvider
                              .removeBookmark(widget.mangaDetails['title']);
                          _firestore
                              .collection('profile')
                              .doc(profileProvider.email)
                              .update({
                            'bookmarks': FieldValue.arrayRemove(
                                [widget.mangaDetails['title']])
                          });
                          setState(() {});
                        }
                      },
                      icon: const Icon(Icons.bookmark_remove))
                  : IconButton(
                      onPressed: () {
                        if (profileProvider.email.isNotEmpty) {
                          profileProvider
                              .addBookmark(widget.mangaDetails['title']);
                          _firestore
                              .collection('profile')
                              .doc(profileProvider.email)
                              .update({
                            'bookmarks': FieldValue.arrayUnion(
                                [widget.mangaDetails['title']])
                          });
                          setState(() {});
                        }
                        print('hi');
                      },
                      icon: const Icon(Icons.bookmark_add_outlined))
            ],
          ),
          body: Stack(children: [MangaSummary(widget.mangaDetails)]));
    }));
  }
}
