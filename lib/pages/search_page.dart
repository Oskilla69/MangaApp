import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// maybe have history. Who knows
class SearchPageDelegate<T> extends SearchDelegate<T?> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list_rounded))
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
    // TODO: check ListView.builder. Should I use? what about dynamic lists?
    return ListView(
      children: [
        ListTile(title: Text('1')),
        ListTile(title: Text('2')),
      ],
    );
  }
}
