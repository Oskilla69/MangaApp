import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangaapp/manga_reader_page/models/reactions_model.dart';
import 'package:provider/provider.dart';
import '../../shared/sliding_app_bar.dart';
import 'manga.dart';
import '../widgets/comment_card.dart';
import '../widgets/emote_button_bar.dart';
import '../../shared/comment_box.dart';
import '../../shared/muhnga_app_bar.dart';
import '../../shared/muhnga_constants.dart';
import '../../pages/account_settings_page.dart';
import '../../manga_page/screens/manga_page.dart';
import '../../shared/muhnga_colors.dart';
import '../../shared/muhnga_icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MangaReader extends StatefulWidget {
  const MangaReader({Key? key, required this.mangaData}) : super(key: key);
  final Map<String, dynamic> mangaData;
  static const routeName = '${MangaPage.routeName}/display';

  @override
  State<MangaReader> createState() => _MangaReaderState();
}

class _MangaReaderState extends State<MangaReader>
    with SingleTickerProviderStateMixin {
  bool _showAppBar = false;

  late final AnimationController _controller;
  final _supabase = Supabase.instance.client;
  bool dataSaver = false;
  bool verticalScroll = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _loadPreferences();
  }

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
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<PostgrestResponse<dynamic>> future = _supabase
        .from("chapter")
        .select("pages")
        .eq("id", widget.mangaData["chapter"]["id"])
        .execute();
    return Scaffold(
      body: Center(
          child: FutureBuilder<PostgrestResponse<dynamic>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.data != null) {
              List<Widget> commentSection = [
                CommentBox(),
                ChangeNotifierProvider(
                    create: (context) => ReactionsModel(),
                    child: EmoteButtonBar()),
                CommentCard(),
                CommentCard(),
                CommentCard(),
                CommentCard(),
              ];
              List<dynamic> pages = snapshot.data!.data[0]['pages'];
              // return buildReader(pages, commentSection, verticalScroll);
              return MangaPages(pages, commentSection, widget.mangaData);
            }
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                  "There was an error with loading the chapter. Try reloading the chapter."),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )),
    );
  }

  Widget buildReader(
      List<dynamic> pages, List<Widget> commentSection, bool verticalScroll) {
    return Stack(children: [
      GestureDetector(
          onTap: () {
            setState(() {
              _showAppBar = !_showAppBar;
            });
          },
          // onDoubleTap: () {
          //   print('zoom in');
          // },
          child: verticalScroll
              ? buildVerticalScroll(pages, commentSection)
              : buildHorizontalScroll(pages, commentSection)),
      // child: buildPages(pages)),
      SlidingAppBar(
        controller: _controller,
        visible: _showAppBar,
        child: MuhngaAppBar(
          'Chapter ${widget.mangaData['chapter']['chapter']}',
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
    // return SliverGrid.count(
    //     crossAxisCount: 1,
    //     children: pages.map((pageUrl) {
    //       return CachedNetworkImage(
    //         width: 1.sw,
    //         imageUrl: pageUrl,
    //         placeholder: (context, url) =>
    //             const Center(child: CircularProgressIndicator()),
    //         errorWidget: (context, url, error) =>
    //             const Center(child: Icon(Icons.error)),
    //       );
    //     }).toList());
    return SliverList(
        delegate: SliverChildBuilderDelegate(childCount: pages.length,
            (context, index) {
      return CachedNetworkImage(
        width: 1.sw,
        imageUrl: pages[index],
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) =>
            const Center(child: Icon(Icons.error)),
      );
    }));
  }

  Widget buildVerticalScroll(List<dynamic> pages, List<Widget> commentSection) {
    return CustomScrollView(scrollDirection: Axis.vertical, slivers: [
      buildPages(pages),
      SliverPadding(
          padding: const EdgeInsets.fromLTRB(18.0, 28.0, 18.0, 0.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: commentSection.length,
              (context, index) {
                return commentSection[index];
              },
            ),
          ))
    ]);
  }

  Widget buildHorizontalScroll(
      List<dynamic> pages, List<Widget> commentSection) {
    return CustomScrollView(
        reverse: true,
        scrollDirection: Axis.horizontal,
        slivers: [
          buildPages(pages),
          SliverToBoxAdapter(
            child: Container(
              width: 1.sw,
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: ListView.builder(
                itemCount: commentSection.length,
                itemBuilder: (context, index) {
                  return commentSection[index];
                },
              ),
            ),
            // sliver: SliverList(
            //     delegate: SliverChildBuilderDelegate(
            //   childCount: commentSection.length,
            //   (context, index) {
            //     return commentSection[index];
            //   },
            // )),
          )
        ]);
  }
}
