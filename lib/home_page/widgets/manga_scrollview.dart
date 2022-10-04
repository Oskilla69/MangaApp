import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mangaapp/home_page/widgets/manga_card.dart';
import 'package:mangaapp/manga_page/screens/manga_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MangaScrollView extends StatefulWidget {
  const MangaScrollView(this.query, this.width, this.height, this.emptyResponse,
      {Key? key})
      : super(key: key);
  final PostgrestTransformBuilder query;
  final double width;
  final double height;
  final Widget Function(BuildContext context) emptyResponse;

  @override
  State<MangaScrollView> createState() => _MangaScrollViewState();
}

class _MangaScrollViewState extends State<MangaScrollView> {
  final limit = 10;

  final _pagingController = PagingController(firstPageKey: 0);
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchMore(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  void _fetchMore(int page) {
    widget.query.range(page, page + limit).execute().then((res) {
      if (mounted) {
        if (res.data != null) {
          var newMangas = res.data;
          if (newMangas.length < limit) {
            _pagingController.appendLastPage(newMangas);
          } else {
            _pagingController.appendPage(newMangas, page + limit);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PagedSliverGrid(
      pagingController: _pagingController,
      builderDelegate:
          PagedChildBuilderDelegate(noItemsFoundIndicatorBuilder: (context) {
        return Column(
          children: [
            SizedBox(height: .32.sh),
            Text(
              'There are no manga!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        );
      }, itemBuilder: ((context, dynamic manga, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, MangaPage.routeName, arguments: manga);
          },
          child: MangaCard(manga, widget.width, widget.height),
        );
      })),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (1.sw / widget.width).round(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: widget.width / widget.height),
    );
  }
}
