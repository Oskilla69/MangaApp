import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangaapp/components/sliding_app_bar.dart';
import 'package:mangaapp/helpers/app_constants.dart';
import 'package:mangaapp/pages/account_settings_page.dart';
import 'package:mangaapp/pages/comment_page.dart';
import 'package:mangaapp/pages/comments_page.dart';
import 'package:mangaapp/home_page/screens/home_page.dart';
import 'package:mangaapp/manga_page/screens/manga_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return Scaffold(
      // bottomNavigationBar: _showAppBar ? AppBar() : null,
      body: Stack(children: [
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
                ? _buildVerticalScroll(widget.mangaData)
                : _buildHorizontalScroll(widget.mangaData)),
        SlidingAppBar(
          controller: _controller,
          visible: _showAppBar,
          child: AppBar(
            title: Text('Chapter ${widget.mangaData['chapter']['chapter']}'),
            actions: [
              IconButton(
                  onPressed: () async {
                    await Navigator.pushNamed(
                        context, AccountSettingsPage.routeName);
                    _loadPreferences();
                  },
                  icon: const Icon(Icons.settings))
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildHorizontalScroll(Map<String, dynamic> mangaData) {
    Map<String, dynamic> mangaPages = mangaData['chapter'];
    return CustomRefreshIndicator(
      onRefresh: () async {
        Navigator.pushReplacementNamed(context, CommentsPage.routeName,
            arguments: {
              'chapter': mangaPages['chapter'],
              'manga': mangaData['title']
            });
      },
      reversed: true,
      builder: (
        BuildContext context,
        Widget child,
        IndicatorController controller,
      ) {
        const height = 500.0;
        const width = 100.0;
        return AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              final dx =
                  controller.value.clamp(0.0, 16.9) * -(width - (width * 0.25));
              return Stack(
                children: [
                  Transform.translate(
                    offset: Offset(-dx, 0.0),
                    child: child,
                  ),
                  Positioned(
                    bottom: .1.sw,
                    left: -width,
                    width: width,
                    height: height,
                    child: Container(
                      transform: Matrix4.translationValues(-dx, 0.0, 0.0),
                      padding: const EdgeInsets.only(top: 30.0),
                      constraints: const BoxConstraints.expand(),
                      child: Column(
                        children: [
                          if (controller.isLoading)
                            Container(
                              margin: const EdgeInsets.only(bottom: 8.0),
                              width: 16,
                              height: 16,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          else
                            const Icon(
                              Icons.keyboard_arrow_left,
                            ),
                          Text(
                            controller.isLoading
                                ? "Loading..."
                                : "Pull to load next chapter.",
                            textAlign: TextAlign.center,
                            // style: const TextStyle(),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            });
      },
      child: ListView.builder(
          reverse: true,
          scrollDirection: Axis.horizontal,
          itemCount: mangaPages['pages'].length,
          itemBuilder: (context, index) {
            String pageUrl = mangaPages['pages'][index];
            return CachedNetworkImage(
              width: 1.sw,
              imageUrl: pageUrl,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  const Center(child: Icon(Icons.error)),
            );
          }),
    );
  }

  Widget _buildImageViews(Map<String, dynamic> mangaPages) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      return CachedNetworkImage(
        imageUrl: mangaPages['pages'][index],
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) =>
            const Center(child: Icon(Icons.error)),
      );
    }, childCount: mangaPages['pages'].length));
  }

  Widget _buildVerticalScroll(Map<String, dynamic> mangaData) {
    Map<String, dynamic> mangaPages = mangaData['chapter'];
    return CustomRefreshIndicator(
      onRefresh: () async {
        Navigator.pushReplacementNamed(context, CommentsPage.routeName,
            arguments: {
              'chapter': mangaPages['chapter'],
              'manga': mangaData['title']
            });
      },
      reversed: true,
      trailingScrollIndicatorVisible: false,
      leadingScrollIndicatorVisible: true,
      child: ListView.builder(
          itemCount: mangaPages['pages'].length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            String pageUrl = mangaPages['pages'][index];
            return CachedNetworkImage(
              imageUrl: pageUrl,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  const Center(child: Icon(Icons.error)),
            );
          }),
      builder: (
        BuildContext context,
        Widget child,
        IndicatorController controller,
      ) {
        const height = 200.0;
        return AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              final dy = controller.value.clamp(0.0, 1.25) *
                  -(height - (height * 0.25));
              return Stack(
                children: [
                  Transform.translate(
                    offset: Offset(0.0, dy),
                    child: child,
                  ),
                  Positioned(
                    bottom: -height,
                    left: 0,
                    right: 0,
                    height: height,
                    child: Container(
                      transform: Matrix4.translationValues(0.0, dy, 0.0),
                      padding: const EdgeInsets.only(top: 30.0),
                      constraints: const BoxConstraints.expand(),
                      child: Column(
                        children: [
                          if (controller.isLoading)
                            Container(
                              margin: const EdgeInsets.only(bottom: 8.0),
                              width: 16,
                              height: 16,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          else
                            const Icon(
                              Icons.keyboard_arrow_up,
                            ),
                          Text(
                            controller.isLoading
                                ? "Loading..."
                                : "Pull to load next chapter.",
                            // style: const TextStyle(),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            });
      },
    );
  }
}
