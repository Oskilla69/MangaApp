import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangaapp/manga_reader_page/screens/manga_reader_page.dart';
import 'package:mangaapp/manga_reader_page/widgets/load_chapter_wheel.dart';
import 'package:mangaapp/manga_reader_page/widgets/manga_image.dart';
import 'package:mangaapp/manga_reader_page/widgets/manga_page_loaders.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zoom_widget/zoom_widget.dart';
import '../../shared/sliding_app_bar.dart';
import '../../pages/account_settings_page.dart';
import '../../shared/muhnga_app_bar.dart';
import '../../shared/muhnga_colors.dart';
import '../../shared/muhnga_constants.dart';
import '../../shared/muhnga_icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MangaPages extends StatefulWidget {
  const MangaPages(this.pages, this.commentSection, this.chapter, {super.key});
  final List<dynamic> pages;
  final List<Widget> commentSection;
  final Map<String, dynamic> chapter;

  @override
  State<MangaPages> createState() => MangaPagesState();
}

class MangaPagesState extends State<MangaPages>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  final supabase = Supabase.instance.client;
  late final ScrollController commentController;
  late final PageController photoPageController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _loadPreferences();
    photoPageController = PageController(initialPage: 9);
    commentController = ScrollController();
  }

  bool dataSaver = false;
  bool verticalScroll = true;
  bool _showAppBar = false;

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dataSaver = prefs.getBool(SHARED_PREFERENCES.DATA_SAVER.parse()) ?? false;
      verticalScroll =
          prefs.getBool(SHARED_PREFERENCES.VERTICAL_SCROLL.parse()) ?? true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
    photoPageController.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      verticalScroll
          ? buildVerticalScroll(widget.pages, widget.commentSection)
          : buildHorizontalScroll(widget.pages, widget.commentSection),
      SlidingAppBar(
        controller: animationController,
        visible: _showAppBar,
        child: MuhngaAppBar(
          'Chapter ${widget.chapter["chapter"]["chapter"]}',
          MuhngaIconButton(const Icon(Icons.arrow_back_ios_new), () {
            Navigator.pop(context);
          }),
          [
            MuhngaIconButton(const Icon(Icons.settings), () async {
              await Navigator.pushNamed(context, AccountSettingsPage.routeName);
              _loadPreferences();
            })
          ],
          appBarColor: MuhngaColors.secondary,
        ),
      ),
    ]);
  }

  Widget buildPages(List<dynamic> pages) {
    // return SliverToBoxAdapter(
    //   child: SizedBox(
    //     height: 1.sh,
    //     child: PhotoViewGallery.builder(
    //         scrollDirection: Axis.vertical,
    //         itemCount: pages.length,
    //         builder: ((context, index) {
    //           return PhotoViewGalleryPageOptions(
    //             imageProvider: CachedNetworkImageProvider(pages[index]),
    //             initialScale: PhotoViewComputedScale.contained,
    //             minScale: PhotoViewComputedScale.contained,
    //             maxScale: PhotoViewComputedScale.covered * 1.1,
    //           );
    //         })),
    //   ),
    // );
    // return SliverList(
    //     delegate: SliverChildBuilderDelegate(childCount: pages.length,
    //         (context, index) {
    //   return SizedBox(
    //     child: PhotoView(
    //       minScale: 1.0,
    //       imageProvider: CachedNetworkImageProvider(pages[index],
    //           maxHeight: 1.sh.toInt(), maxWidth: 1.sw.toInt()),
    //       // fit: BoxFit.contain,
    //       // imageUrl: pages[index],
    //       // placeholder: (context, url) =>
    //       //     const Center(child: CircularProgressIndicator()),
    //       // errorWidget: (context, url, error) =>
    //       //     const Center(child: Icon(Icons.error)),
    //     ),
    //   );
    // }));

    return SliverList(
        delegate: SliverChildBuilderDelegate(childCount: pages.length,
            (context, index) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _showAppBar = !_showAppBar;
          });
        },
        // child: CachedNetworkImage(
        //   width: 1.sw,
        //   fit: BoxFit.contain,
        //   imageUrl: pages[index],
        //   placeholder: (context, url) =>
        //       const Center(child: CircularProgressIndicator()),
        //   errorWidget: (context, url, error) =>
        //       const Center(child: Icon(Icons.error)),
        // ),
        child: MangaImage(pages[index]),
      );
    }));
  }

  Future<void> loadChapter(bool prev) async {
    print("???");
    num nextNum = prev ? -1 : 1;
    // get manga of chapter and see if it is equivalent
    PostgrestResponse<dynamic> mangaId =
        await supabase.from("chapter").select('''
      manga
    ''').eq('id', widget.chapter['chapter']['id']).execute();
    PostgrestResponse<dynamic> response = await supabase
        .from("chapter")
        .select('''
      id, chapter
    ''')
        .eq('manga', mangaId.data[0]['manga'])
        .eq('chapter', widget.chapter['chapter']['chapter'] + nextNum)
        .execute();
    if (response.hasError || response.data == null || response.data.isEmpty) {
      Flushbar(
        message: prev
            ? "This is the first chapter available"
            : "This is the latest chapter available",
        icon: const Icon(
          Icons.error,
          size: 28.0,
          color: Colors.white,
        ),
        duration: const Duration(seconds: 4),
        backgroundGradient: LinearGradient(
          colors: [MuhngaColors.danger[600]!, MuhngaColors.danger[400]!],
        ),
        onTap: (flushbar) => flushbar.dismiss(),
      )..show(context);
    } else {
      Navigator.of(context)
          .pushReplacementNamed(MangaReader.routeName, arguments: {
        "chapter": {
          "chapter": response.data[0]['chapter'],
          "id": response.data[0]['id']
        }
      });
    }
    //
  }

  Widget buildGallery(List<dynamic> pages, {required bool vertical}) {
    // return LayoutBuilder(
    //     builder: (BuildContext context, BoxConstraints constraints) {
    // });
    // children: pages
    //     .map((e) => PhotoView(
    //         backgroundDecoration:
    //             const BoxDecoration(color: MuhngaColors.secondaryShade),
    //         imageProvider: CachedNetworkImageProvider(e)))
    //     .toList()
    // ));
    // return PageView.builder(
    //     scrollDirection: vertical ? Axis.vertical : Axis.horizontal,
    //     reverse: vertical ? false : true,
    //     controller: PageController(viewportFraction: 1),
    //     itemCount: pages.length + 1,
    //     itemBuilder: ((context, index) {
    //       if (index == pages.length) {
    //         return SafeArea(
    //           child: Container(
    //             width: 1.sw,
    //             padding: const EdgeInsets.only(
    //                 left: 18.0, right: 18.0, top: kToolbarHeight),
    //             child: ListView.builder(
    //               itemCount: widget.commentSection.length,
    //               itemBuilder: (context, index) {
    //                 return widget.commentSection[index];
    //               },
    //             ),
    //             // child: CustomScrollView(
    //             //   slivers: [
    //             //     SliverList(
    //             //         delegate: SliverChildBuilderDelegate(
    //             //       childCount: widget.commentSection.length,
    //             //       (context, index) {
    //             //         return widget.commentSection[index];
    //             //       },
    //             //     ))
    //             //   ],
    //             // )
    //           ),
    //         );
    //       } else {
    //         return GestureDetector(
    //             onTap: () {
    //               setState(() {
    //                 _showAppBar = !_showAppBar;
    //               });
    //             },
    //             // child: MangaImage(pages[index]),
    //             child: PhotoView(
    //               initialScale: PhotoViewComputedScale.contained,
    //               minScale: PhotoViewComputedScale.contained,
    //               maxScale: PhotoViewComputedScale.covered * 4,
    //               backgroundDecoration:
    //                   const BoxDecoration(color: MuhngaColors.secondaryShade),
    //               imageProvider: CachedNetworkImageProvider(pages[index]),
    //             ));
    //       }
    //     }));
    // PhotoViewController photoViewController = PhotoViewController();
    // PhotoViewScaleStateController scaleStateController =
    //     PhotoViewScaleStateController();
    // return PhotoView.customChild(
    //     initialScale: PhotoViewComputedScale.contained,
    //     minScale: PhotoViewComputedScale.contained,
    //     maxScale: PhotoViewComputedScale.covered * 4,
    //     scaleStateController: scaleStateController,
    //     scaleStateCycle: (actual) {
    //       print("hey");
    //       switch (actual) {
    //         case PhotoViewScaleState.initial:
    //           print("initial");
    //           return PhotoViewScaleState.covering;
    //         case PhotoViewScaleState.covering:
    //           print("covering");
    //           return PhotoViewScaleState.originalSize;
    //         case PhotoViewScaleState.originalSize:
    //           print("original");
    //           return PhotoViewScaleState.initial;
    //         default:
    //           print("default");
    //           return PhotoViewScaleState.initial;
    //       }
    //     },
    //     child: SingleChildScrollView(
    //       child: Column(children: [
    //         ...pages.map((e) => CachedNetworkImage(imageUrl: e)).toList(),
    //         SafeArea(
    //           child: Container(
    //             width: 1.sw,
    //             padding: const EdgeInsets.only(
    //                 left: 18.0, right: 18.0, top: kToolbarHeight),
    //             child: Column(children: widget.commentSection),
    //             // child: Column(children: widget.commentSection),
    //           ),
    //         )
    //       ]),
    //     ));
    return GestureDetector(
      onTap: () {
        setState(() {
          _showAppBar = !_showAppBar;
        });
      },
      // child: CachedNetworkImage(
      //   width: 1.sw,
      //   fit: BoxFit.contain,
      //   imageUrl: pages[index],
      //   placeholder: (context, url) =>
      //       const Center(child: CircularProgressIndicator()),
      //   errorWidget: (context, url, error) =>
      //       const Center(child: Icon(Icons.error)),
      // ),
      child: MangaImage(pages),
    );
    return GestureDetector(
      onTap: () => setState(() {
        _showAppBar = !_showAppBar;
      }),
      child: PhotoViewGallery.builder(
          pageController: photoPageController,
          scrollDirection: vertical ? Axis.vertical : Axis.horizontal,
          reverse: vertical ? false : true,
          itemCount: pages.length + 1,
          backgroundDecoration:
              const BoxDecoration(color: MuhngaColors.secondaryShade),
          builder: ((context, index) {
            if (index == pages.length) {
              return PhotoViewGalleryPageOptions.customChild(
                  onTapDown: (context, details, controllerValue) {
                    FocusScope.of(context).unfocus();
                  },
                  child: SafeArea(
                    child: Container(
                      width: 1.sw,
                      padding: const EdgeInsets.only(
                          left: 18.0, right: 18.0, top: kToolbarHeight),
                      child: ListView.builder(
                        controller: commentController,
                        itemCount: widget.commentSection.length,
                        itemBuilder: (context, index) {
                          return widget.commentSection[index];
                        },
                      ),
                      // child: Column(children: widget.commentSection),
                    ),
                  ));
            }
            return PhotoViewGalleryPageOptions(
              imageProvider: CachedNetworkImageProvider(pages[index]),
              initialScale: PhotoViewComputedScale.contained,
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 4,
            );
          })),
    );
  }

  Widget buildVerticalScroll(List<dynamic> pages, List<Widget> commentSection) {
    return MangaPageLoaders(loadChapter,
            vertical: true, child: buildGallery(pages, vertical: true))
        // child: CustomScrollView(scrollDirection: Axis.vertical, slivers: [
        //   buildPages(pages),
        //   SliverSafeArea(
        //     sliver: SliverPadding(
        //         padding: const EdgeInsets.fromLTRB(18.0, 28.0, 18.0, 0.0),
        //         sliver: SliverList(
        //           delegate: SliverChildBuilderDelegate(
        //             childCount: commentSection.length,
        //             (context, index) {
        //               return commentSection[index];
        //             },
        //           ),
        //         )),
        //   )
        // ]),
        ;
  }

  Widget buildHorizontalScroll(
      List<dynamic> pages, List<Widget> commentSection) {
    return MangaPageLoaders(loadChapter,
            vertical: false, child: buildGallery(pages, vertical: false))
        // child: PageView.builder(
        //     reverse: true,
        //     controller: PageController(viewportFraction: 1),
        //     itemCount: pages.length + 1,
        //     itemBuilder: ((context, index) {
        //       if (index == pages.length) {
        //         return SafeArea(
        //           child: Container(
        //             width: 1.sw,
        //             padding: const EdgeInsets.only(
        //                 left: 18.0, right: 18.0, top: kToolbarHeight),
        //             child: ListView.builder(
        //               itemCount: commentSection.length,
        //               itemBuilder: (context, index) {
        //                 return commentSection[index];
        //               },
        //             ),
        //           ),
        //         );
        //       } else {
        //         return GestureDetector(
        //           onTap: () {
        //             setState(() {
        //               _showAppBar = !_showAppBar;
        //             });
        //           },
        //           child: MangaImage(pages[index]),
        //         );
        //       }
        //     })),
        ;
  }
}
