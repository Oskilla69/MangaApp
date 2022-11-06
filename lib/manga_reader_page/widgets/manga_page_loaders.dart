import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mangaapp/manga_reader_page/widgets/load_chapter_wheel.dart';

class MangaPageLoaders extends StatelessWidget {
  const MangaPageLoaders(this.loadChapterCallback,
      {super.key, required this.child, required this.vertical});
  final Widget child;
  final Future<void> Function(bool) loadChapterCallback;
  final bool vertical;
  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      onRefresh: () => loadChapterCallback(false),
      reversed: true,
      trailingScrollIndicatorVisible: false,
      leadingScrollIndicatorVisible: true,
      child: CustomRefreshIndicator(
          onRefresh: () => loadChapterCallback(true),
          reversed: false,
          trailingScrollIndicatorVisible: false,
          leadingScrollIndicatorVisible: true,
          child: child,
          builder: (context, child, controller) => LoadChapterWheel(
              controller, child,
              vertical: vertical, start: true)),
      builder: (context, child, controller) =>
          LoadChapterWheel(controller, child, vertical: vertical, start: false),
    );
  }
}
