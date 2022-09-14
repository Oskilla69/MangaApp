import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chapters extends StatelessWidget {
  Chapters(this.manga, {Key? key}) : super(key: key);
  final Map<String, dynamic> manga;
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _firestore
            .collection('manga')
            .doc(manga['title'])
            .collection('chapters')
            .get(),
        builder: ((context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            return Column(
                // shrinkWrap: true,
                children: snapshot.data!.docs.map((chapter) {
              return ListTile(
                title: Text('Chapter ${chapter['chapter']}'),
              );
            }).toList());
          }
          return const Center(child: CircularProgressIndicator());
        }));
  }
}
