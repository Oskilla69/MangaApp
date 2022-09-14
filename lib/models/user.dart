import 'package:mangaapp/models/chapter.dart';
import 'package:mangaapp/models/manga.dart';

class User {
  String? id;
  String? username;
  bool? subscribed;
  List<Manga>? favourites;
  List<Chapter>? history;
}
