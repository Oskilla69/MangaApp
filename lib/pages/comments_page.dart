import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mangaapp/manga_reader_page/screens/manga_reader_page.dart';
import 'package:mangaapp/manga_page/screens/manga_page.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({Key? key, required this.mangaData}) : super(key: key);
  static const routeName = '${MangaPage.routeName}/comments';
  final Map<String, dynamic> mangaData;

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final _firestore = FirebaseFirestore.instance;

  bool next = false;
  late Map<String, dynamic> nextChapter;

  @override
  void initState() {
    super.initState();
    _firestore
        .collection('manga')
        .doc(widget.mangaData['manga'])
        .collection('chapters')
        .get()
        .then((value) {
      setState(() {
        next = value.docs.length > widget.mangaData['chapter'] ? true : false;
        nextChapter = value.docs[widget.mangaData['chapter']].data();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chapter ${widget.mangaData['chapter']}'),
        actions: next
            ? [
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, MangaReader.routeName, arguments: {
                        'chapter': nextChapter,
                        'title': widget.mangaData['manga']
                      });
                    },
                    child: const Text('Next'))
              ]
            : [],
      ),
    );
  }
}
