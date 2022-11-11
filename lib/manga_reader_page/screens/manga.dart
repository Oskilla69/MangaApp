import 'package:another_flushbar/flushbar.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mangaapp/manga_reader_page/screens/manga_reader_page.dart';
import 'package:mangaapp/manga_reader_page/widgets/manga_page_loaders.dart';
import 'package:mangaapp/manga_reader_page/widgets/vertical_scroll.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _loadPreferences();
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
    // activeScrollController.dispose();
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

  Future<void> loadChapter(bool prev) async {
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
  }

  Widget buildVerticalScroll(List<dynamic> pages, List<Widget> commentSection) {
    return MangaPageLoaders(loadChapter,
        vertical: true,
        child: VerticalScroll(
          commentSection: widget.commentSection,
          pageUrls: pages,
          pageTapCallback: (context, tapUpDetails, photoViewControllerValue) {
            setState(() {
              _showAppBar = !_showAppBar;
            });
          },
        ));
  }

  Widget buildHorizontalScroll(
      List<dynamic> pages, List<Widget> commentSection) {
    return MangaPageLoaders(
      loadChapter,
      vertical: false,
      child: PhotoViewGallery.builder(
        backgroundDecoration:
            const BoxDecoration(color: MuhngaColors.secondaryShade),
        scrollDirection: Axis.horizontal,
        reverse: true,
        itemCount: pages.length + 1,
        builder: (context, index) {
          if (index == pages.length) {
            return PhotoViewGalleryPageOptions.customChild(
              disableGestures: true,
              child: SingleChildScrollView(
                  child: SafeArea(
                      child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(children: widget.commentSection),
              ))),
            );
          }
          return PhotoViewGalleryPageOptions(
              onTapUp: ((context, details, controllerValue) {
                setState(() {
                  _showAppBar = !_showAppBar;
                });
              }),
              initialScale: 1.0,
              minScale: 1.0,
              maxScale: 3.2,
              imageProvider:
                  ExtendedNetworkImageProvider(pages[index], cache: true));
        },
      ),
    );
  }
}
