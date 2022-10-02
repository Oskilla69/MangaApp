import 'dart:typed_data';

import 'package:algolia/algolia.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mangaapp/components/search_list_item.dart';
import 'package:mangaapp/main.dart';
import 'package:mangaapp/manga_page/screens/manga_page.dart';
import 'package:mangaapp/search_page/screens/search_extra.dart';
// import 'package:mangaapp/pages/search_extra.dart';

// maybe have history. Who knows
class SearchPageDelegate extends SearchDelegate<int?> {
  var test = 0;
  final _storage = FirebaseStorage.instance;

  Map<String, dynamic> filters = {
    'genres': [],
    'descending': true,
    'sort': 'Best Match'
  };

  List<String> buildAlgoliaFilters(List filters) {
    if (filters.isEmpty) {
      return [""];
    } else {
      return filters.map((e) {
        return 'genre:$e';
      }).toList();
    }
  }

  Future<AlgoliaQuerySnapshot> getSearchResults(String searchQuery) async {
    Algolia algolia = Application.algolia;
    List<String> algoliaFilters = buildAlgoliaFilters(filters['genres']);
    AlgoliaQuery query = algolia.instance
        .index('manga')
        .query(searchQuery)
        .facetFilter(algoliaFilters);
    AlgoliaQuerySnapshot snap = await query.getObjects();
    return snap;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
      IconButton(
          onPressed: () {
            // showFilterDialog(context);
            Navigator.push<int>(context, SearchExtra(filters: filters))
                .then((value) {
              if (value == 1) {
                query = query;
              }
            });
          },
          icon: const Icon(Icons.filter_list_rounded)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const BackButtonIcon(),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
        future: getSearchResults(query),
        builder: (BuildContext context,
            AsyncSnapshot<AlgoliaQuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const ListTile(title: Text('None'));
            case ConnectionState.waiting:
              return const ListTile(title: Text('Waiting..'));
            case ConnectionState.active:
              return const ListTile(title: Text('Active..'));
            case ConnectionState.done:
              List<Widget> results = snapshot.data!.hits.map((element) {
                return FutureBuilder(
                  future: _storage
                      .refFromURL(element.data['cover'])
                      .getData(1028 * 1028),
                  builder: (BuildContext context,
                      AsyncSnapshot<Uint8List?> snapshot) {
                    Widget leadingWidget;
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      leadingWidget = Image.memory(
                        snapshot.data!,
                        fit: BoxFit.fill,
                        height: 120,
                        width: 80,
                      );
                      // leadingWidget = CachedNetworkImage(
                      //   imageUrl: snapshot.data!,
                      //   fit: BoxFit.fill,
                      //   height: 120,
                      //   width: 80,
                      //   progressIndicatorBuilder:
                      //       (context, url, downloadProgress) => Center(
                      //           child: CircularProgressIndicator(
                      //               value: downloadProgress.progress)),
                      //   errorWidget: (context, url, error) =>
                      //       const Icon(Icons.error),
                      //   alignment: FractionalOffset.topCenter,
                      // );
                    } else if (snapshot.connectionState ==
                            ConnectionState.waiting ||
                        !snapshot.hasData) {
                      leadingWidget =
                          const Center(child: CircularProgressIndicator());
                    } else {
                      leadingWidget = const Text('Error');
                    }
                    return SearchListItem(
                      title: element.data['title'],
                      leading: leadingWidget,
                      synopsis: element.data['synopsis'],
                      onClick: () {
                        close(context, 0);
                      },
                    );
                  },
                );
              }).toList();
              return ListView(children: results);
          }
        });
  }
}
