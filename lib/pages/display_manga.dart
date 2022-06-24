import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mangaapp/components/sliding_app_bar.dart';
import 'package:mangaapp/helpers/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplayManga extends StatefulWidget {
  DisplayManga({Key? key}) : super(key: key);

  static const routeName = '/display_manga';

  @override
  State<DisplayManga> createState() => _DisplayMangaState();
}

class _DisplayMangaState extends State<DisplayManga>
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
    Map<String, dynamic> mangaPages =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Stack(children: [
      Scaffold(
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
                  ? _buildVerticalScroll(mangaPages)
                  : _buildHorizontalScroll(mangaPages)),
          SlidingAppBar(
            controller: _controller,
            visible: _showAppBar,
            child: AppBar(
              title: Text('Chapter ${mangaPages['chapter']}'),
              actions: [
                IconButton(
                    onPressed: () {
                      print('settings');
                    },
                    icon: const Icon(Icons.settings))
              ],
            ),
          ),
        ]),
      )
    ]);
  }

  Widget _buildHorizontalScroll(Map<String, dynamic> mangaPages) {
    return ListView(
        reverse: true,
        scrollDirection: Axis.horizontal,
        children: mangaPages['pages'].map<Widget>(
          (pageUrl) {
            return CachedNetworkImage(
              imageUrl: pageUrl,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  const Center(child: Icon(Icons.error)),
            );
          },
        ).toList());
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

  Widget _buildVerticalScroll(Map<String, dynamic> mangaPages) {
    // return _showAppBar
    //     ? CustomScrollView(
    //         slivers: [
    //           SliverAppBar(
    //             title: Text('Chapter ${mangaPages['chapter']}'),
    //             floating: true,
    //             actions: [
    //               IconButton(
    //                   onPressed: () {
    //                     print('settings');
    //                   },
    //                   icon: const Icon(Icons.settings))
    //             ],
    //             expandedHeight: 50,
    //           ),
    //           _buildImageViews(mangaPages)
    //         ],
    //         scrollDirection: Axis.vertical,
    //       )
    //     : CustomScrollView(
    //         slivers: [_buildImageViews(mangaPages)],
    //         scrollDirection: Axis.vertical,
    //       );
    return ListView(
        scrollDirection: Axis.vertical,
        children: mangaPages['pages'].map<Widget>(
          (pageUrl) {
            return CachedNetworkImage(
              imageUrl: pageUrl,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  const Center(child: Icon(Icons.error)),
            );
          },
        ).toList());
  }
}
