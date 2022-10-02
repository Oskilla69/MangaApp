import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangaapp/shared/sliding_app_bar.dart';
import 'package:mangaapp/pages/account_settings_page.dart';
import 'package:mangaapp/shared/muhnga_app_bar.dart';
import 'package:mangaapp/shared/muhnga_colors.dart';
import 'package:mangaapp/shared/muhnga_constants.dart';
import 'package:mangaapp/shared/muhnga_icon_button.dart';
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
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
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
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      verticalScroll
          ? buildVerticalScroll(widget.pages, widget.commentSection)
          : buildHorizontalScroll(widget.pages, widget.commentSection),
      SlidingAppBar(
        controller: _controller,
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
    return SliverList(
        delegate: SliverChildBuilderDelegate(childCount: pages.length,
            (context, index) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _showAppBar = !_showAppBar;
          });
        },
        onDoubleTap: () {
          print('zoom in');
        },
        child: CachedNetworkImage(
          width: 1.sw,
          fit: BoxFit.contain,
          imageUrl: pages[index],
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) =>
              const Center(child: Icon(Icons.error)),
        ),
      );
    }));
  }

  Future<void> loadNextChapter() async {
    print("wass");
    // Navigator.pushNamed(context, MangaReader.routeName, arguments: {"chapter"});
  }

  Widget buildVerticalScroll(List<dynamic> pages, List<Widget> commentSection) {
    return CustomRefreshIndicator(
      onRefresh: loadNextChapter,
      reversed: true,
      trailingScrollIndicatorVisible: false,
      leadingScrollIndicatorVisible: true,
      child: CustomScrollView(scrollDirection: Axis.vertical, slivers: [
        buildPages(pages),
        SliverSafeArea(
          sliver: SliverPadding(
              padding: const EdgeInsets.fromLTRB(18.0, 28.0, 18.0, 0.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: commentSection.length,
                  (context, index) {
                    return commentSection[index];
                  },
                ),
              )),
        )
      ]),
      builder:
          (BuildContext context, Widget child, IndicatorController controller) {
        const height = 200.0;
        return AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              final dy = controller.value.clamp(0.0, 1.25) * -(0.95 * height);
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
                                : "Pull up to go to the next chapter.",
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

  Widget buildHorizontalScroll(
      List<dynamic> pages, List<Widget> commentSection) {
    return CustomRefreshIndicator(
      onRefresh: loadNextChapter,
      reversed: true,
      trailingScrollIndicatorVisible: false,
      leadingScrollIndicatorVisible: true,
      child: PageView.builder(
          reverse: true,
          controller: PageController(viewportFraction: 1),
          itemCount: pages.length + 1,
          itemBuilder: ((context, index) {
            if (index == pages.length) {
              return SafeArea(
                child: Container(
                  width: 1.sw,
                  padding: const EdgeInsets.only(
                      left: 18.0, right: 18.0, top: kToolbarHeight),
                  child: ListView.builder(
                    itemCount: commentSection.length,
                    itemBuilder: (context, index) {
                      return commentSection[index];
                    },
                  ),
                ),
              );
            } else {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _showAppBar = !_showAppBar;
                  });
                },
                onDoubleTap: () {
                  print('zoom in');
                },
                child: CachedNetworkImage(
                  width: 1.sw,
                  fit: BoxFit.contain,
                  imageUrl: pages[index],
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.error)),
                ),
              );
            }
          })),
      builder: (context, child, controller) {
        const width = 120.0;
        return AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              final dx = controller.value.clamp(0.0, 6.9) * -(0.75 * width);
              return Stack(
                children: [
                  Transform.translate(
                    offset: Offset(-dx, 0.0),
                    child: child,
                  ),
                  Positioned(
                    top: .46.sh,
                    left: -width,
                    width: width,
                    height: width,
                    child: Container(
                      transform: Matrix4.translationValues(-dx, 0.0, 0.0),
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
                              Icons.keyboard_arrow_right,
                            ),
                          Text(
                            controller.isLoading
                                ? "Loading..."
                                : "Pull right to go to the next chapter.",
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
