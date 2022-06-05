import 'package:mangaapp/models/chapter.dart';
import 'package:mangaapp/models/manga.dart';

class User {
  String? id;
  String? username;
  bool? subscribed;
  List<Manga>? bookmarks;
  List<Chapter>? history;
}
