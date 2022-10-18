import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart' as provider;

import '../../providers/profile_model.dart';
import '../../shared/muhnga_app_bar.dart';
import '../../shared/muhnga_colors.dart';
import '../../shared/muhnga_icon_button.dart';
import 'manga_chapters.dart';
import 'manga_reviews.dart';
import 'manga_summary.dart';

class MangaPage extends StatefulWidget {
  const MangaPage({Key? key, required this.mangaDetails}) : super(key: key);
  // const MangaPage(this.mangaDetails);
  final Map<String, dynamic> mangaDetails;
  static const String routeName = '/manga';

  @override
  State<MangaPage> createState() => _MangaPageState();
}

class _MangaPageState extends State<MangaPage> {
  @override
  Widget build(BuildContext context) {
    print(widget.mangaDetails);
    final profileProvider =
        provider.Provider.of<ProfileModel>(context, listen: true);
    List<dynamic> favourites = profileProvider.favourites;
    return ScreenUtilInit(builder: ((context, child) {
      return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: MuhngaAppBar(
              widget.mangaDetails['title'],
              MuhngaIconButton(const Icon(Icons.arrow_back_ios_new), (() {
                Navigator.pop(context);
              })),
              [
                MuhngaIconButton(const Icon(Icons.add), () {
                  print("NOTE: ADD COMMENT CLICKED");
                })
                // favourites.contains(widget.mangaDetails['title'])
                //     ? IconButton(
                //         onPressed: () async {
                //           if (profileProvider.email.isNotEmpty) {
                //             await _firestore
                //                 .collection('profile')
                //                 .doc(profileProvider.email)
                //                 .update({
                //               'bookmarks': FieldValue.arrayRemove(
                //                   [widget.mangaDetails['title']])
                //             });
                //             profileProvider.removeFavourite(
                //                 widget.mangaDetails['title'], true);
                //           }
                //         },
                //         icon: const Icon(Icons.bookmark_remove))
                //     : IconButton(
                //         onPressed: () async {
                //           if (profileProvider.email.isNotEmpty) {
                //             await _firestore
                //                 .collection('profile')
                //                 .doc(profileProvider.email)
                //                 .update({
                //               'bookmarks': FieldValue.arrayUnion(
                //                   [widget.mangaDetails['title']])
                //             });
                //             profileProvider.addFavourite(
                //                 widget.mangaDetails['title'], true);
                //           }
                //         },
                //         icon: const Icon(Icons.bookmark_add_outlined))
              ]),
          body: ListView(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    top: 150,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      // height: 1.sh,
                      decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(32)),
                          color: MuhngaColors.black),
                    ),
                  ),
                  buildCover(widget.mangaDetails)
                ],
              ),
              Container(
                color: MuhngaColors.primary,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.055.sw),
                  child: Column(
                    children: [
                      MangaSummary(widget.mangaDetails),
                      MangaChapters(widget.mangaDetails),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 48.0),
                        child: Divider(
                            color: MuhngaColors.grey,
                            thickness: 0.25,
                            height: 36),
                      ),
                      MangaReviews(widget.mangaDetails)
                    ],
                  ),
                ),
              )
            ],
          ));
    }));
  }

  Widget buildCover(Map<String, dynamic> manga) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: MuhngaColors.black.withOpacity(0.5),
              spreadRadius: 6,
              blurRadius: 4,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
              imageUrl: manga['cover'],
              fit: BoxFit.contain,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress)),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              height: 320.h),
        ),
      ),
    );
  }
}
