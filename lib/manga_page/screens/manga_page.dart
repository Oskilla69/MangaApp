import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:mangaapp/manga_page/screens/manga_summary.dart';
import 'package:mangaapp/models/manga.dart';
import 'package:mangaapp/providers/profile_model.dart';
import 'package:mangaapp/shared/muhnga_app_bar.dart';
import 'package:mangaapp/shared/muhnga_icon_button.dart';
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
    final profileProvider = Provider.of<ProfileModel>(context, listen: true);
    List<dynamic> favourites = profileProvider.favourites;
    return ScreenUtilInit(builder: ((context, child) {
      return Scaffold(
          appBar: MuhngaAppBar(
              widget.mangaDetails['title'],
              MuhngaIconButton(const Icon(Icons.arrow_back_ios_new), (() {
                Navigator.pop(context);
              })),
              [
                favourites.contains(widget.mangaDetails['title'])
                    ? IconButton(
                        onPressed: () async {
                          if (profileProvider.email.isNotEmpty) {
                            await _firestore
                                .collection('profile')
                                .doc(profileProvider.email)
                                .update({
                              'bookmarks': FieldValue.arrayRemove(
                                  [widget.mangaDetails['title']])
                            });
                            profileProvider.removeFavourite(
                                widget.mangaDetails['title'], true);
                          }
                        },
                        icon: const Icon(Icons.bookmark_remove))
                    : IconButton(
                        onPressed: () async {
                          if (profileProvider.email.isNotEmpty) {
                            await _firestore
                                .collection('profile')
                                .doc(profileProvider.email)
                                .update({
                              'bookmarks': FieldValue.arrayUnion(
                                  [widget.mangaDetails['title']])
                            });
                            profileProvider.addFavourite(
                                widget.mangaDetails['title'], true);
                          }
                        },
                        icon: const Icon(Icons.bookmark_add_outlined))
              ]),
          body: MangaSummary(widget.mangaDetails));
    }));
  }
}
