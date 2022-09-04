import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mangaapp/pages/manga_page.dart';
import 'package:mangaapp/widgets/read_more.dart';

class SearchListItem extends StatefulWidget {
  SearchListItem({
    Key? key,
    required this.title,
    required this.leading,
    required this.synopsis,
  }) : super(key: key);

  final String title;
  final Widget leading;
  final String? synopsis;

  @override
  State<SearchListItem> createState() => _SearchListItemState();
}

class _SearchListItemState extends State<SearchListItem> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _firestore.collection('manga').doc(widget.title).get().then((manga) {
          Navigator.pushNamed(context, MangaPage.routeName,
              arguments: manga.data());
        });
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
        child: SizedBox(
          height: 120,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            child:
                Row(children: [widget.leading, buildMangaDescription(context)]),
          ),
        ),
      ),
    );
  }

  Widget buildMangaDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 6, bottom: 6),
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.69,
            child: Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              maxLines: 2,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.69,
            child: Text(
              widget.synopsis ?? "",
              maxLines: 3,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
    );
  }
}
