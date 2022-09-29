// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

class Manga {
  int id;
  String title;
  String synopsis;
  double rating;
  String status;
  String updateSchedule;
  int views;
  String cover;
  int publisherId;
  String publisher;
  Manga({
    required this.id,
    required this.title,
    required this.synopsis,
    required this.rating,
    required this.status,
    required this.updateSchedule,
    required this.views,
    required this.cover,
    required this.publisherId,
    required this.publisher,
  });

  Manga copyWith({
    int? id,
    String? title,
    String? synopsis,
    double? rating,
    String? status,
    String? updateSchedule,
    int? views,
    String? cover,
    int? publisherId,
    String? publisher,
  }) {
    return Manga(
      id: id ?? this.id,
      title: title ?? this.title,
      synopsis: synopsis ?? this.synopsis,
      rating: rating ?? this.rating,
      status: status ?? this.status,
      updateSchedule: updateSchedule ?? this.updateSchedule,
      views: views ?? this.views,
      cover: cover ?? this.cover,
      publisherId: publisherId ?? this.publisherId,
      publisher: publisher ?? this.publisher,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'synopsis': synopsis,
      'rating': rating,
      'status': status,
      'updateSchedule': updateSchedule,
      'views': views,
      'cover': cover,
      'publisherId': publisherId,
      'publisher': publisher,
    };
  }

  factory Manga.fromMap(Map<String, dynamic> map) {
    return Manga(
      id: map['id'] as int,
      title: map['title'] as String,
      synopsis: map['synopsis'] as String,
      rating: map['rating'] as double,
      status: map['status'] as String,
      updateSchedule: map['updateSchedule'] as String,
      views: map['views'] as int,
      cover: map['cover'] as String,
      publisherId: map['publisherId'] as int,
      publisher: map['publisher'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Manga.fromJson(String source) =>
      Manga.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Manga(id: $id, title: $title, synopsis: $synopsis, rating: $rating, status: $status, updateSchedule: $updateSchedule, views: $views, cover: $cover, publisherId: $publisherId, publisher: $publisher)';
  }

  @override
  bool operator ==(covariant Manga other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.synopsis == synopsis &&
        other.rating == rating &&
        other.status == status &&
        other.updateSchedule == updateSchedule &&
        other.views == views &&
        other.cover == cover &&
        other.publisherId == publisherId &&
        other.publisher == publisher;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        synopsis.hashCode ^
        rating.hashCode ^
        status.hashCode ^
        updateSchedule.hashCode ^
        views.hashCode ^
        cover.hashCode ^
        publisherId.hashCode ^
        publisher.hashCode;
  }
}

class Authors {
  int id;
  int name;
  Authors({
    required this.id,
    required this.name,
  });

  Authors copyWith({
    int? id,
    int? name,
  }) {
    return Authors(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Authors.fromMap(Map<String, dynamic> map) {
    return Authors(
      id: map['id'] as int,
      name: map['name'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Authors.fromJson(String source) =>
      Authors.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Authors(id: $id, name: $name)';

  @override
  bool operator ==(covariant Authors other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

class Chapter {
  int id;
  DateTime uploadDate;
  int mangaId;
  int chapterId;
  String chapterName;
  List<String> pages;
  int views;
  int upvoteReact;
  int awesomeReact;
  int funnyReact;
  int loveReact;
  int angryReact;
  int sadReact;
  Chapter({
    required this.id,
    required this.uploadDate,
    required this.mangaId,
    required this.chapterId,
    required this.chapterName,
    required this.pages,
    required this.views,
    required this.upvoteReact,
    required this.awesomeReact,
    required this.funnyReact,
    required this.loveReact,
    required this.angryReact,
    required this.sadReact,
  });

  Chapter copyWith({
    int? id,
    DateTime? uploadDate,
    int? mangaId,
    int? chapterId,
    String? chapterName,
    List<String>? pages,
    int? views,
    int? upvoteReact,
    int? awesomeReact,
    int? funnyReact,
    int? loveReact,
    int? angryReact,
    int? sadReact,
  }) {
    return Chapter(
      id: id ?? this.id,
      uploadDate: uploadDate ?? this.uploadDate,
      mangaId: mangaId ?? this.mangaId,
      chapterId: chapterId ?? this.chapterId,
      chapterName: chapterName ?? this.chapterName,
      pages: pages ?? this.pages,
      views: views ?? this.views,
      upvoteReact: upvoteReact ?? this.upvoteReact,
      awesomeReact: awesomeReact ?? this.awesomeReact,
      funnyReact: funnyReact ?? this.funnyReact,
      loveReact: loveReact ?? this.loveReact,
      angryReact: angryReact ?? this.angryReact,
      sadReact: sadReact ?? this.sadReact,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uploadDate': uploadDate.millisecondsSinceEpoch,
      'mangaId': mangaId,
      'chapterId': chapterId,
      'chapterName': chapterName,
      'pages': pages,
      'views': views,
      'upvoteReact': upvoteReact,
      'awesomeReact': awesomeReact,
      'funnyReact': funnyReact,
      'loveReact': loveReact,
      'angryReact': angryReact,
      'sadReact': sadReact,
    };
  }

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
      id: map['id'] as int,
      uploadDate: DateTime.fromMillisecondsSinceEpoch(map['uploadDate'] as int),
      mangaId: map['mangaId'] as int,
      chapterId: map['chapterId'] as int,
      chapterName: map['chapterName'] as String,
      pages: List<String>.from((map['pages'] as List<String>)),
      views: map['views'] as int,
      upvoteReact: map['upvoteReact'] as int,
      awesomeReact: map['awesomeReact'] as int,
      funnyReact: map['funnyReact'] as int,
      loveReact: map['loveReact'] as int,
      angryReact: map['angryReact'] as int,
      sadReact: map['sadReact'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Chapter.fromJson(String source) =>
      Chapter.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Chapter(id: $id, uploadDate: $uploadDate, mangaId: $mangaId, chapterId: $chapterId, chapterName: $chapterName, pages: $pages, views: $views, upvoteReact: $upvoteReact, awesomeReact: $awesomeReact, funnyReact: $funnyReact, loveReact: $loveReact, angryReact: $angryReact, sadReact: $sadReact)';
  }

  @override
  bool operator ==(covariant Chapter other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.uploadDate == uploadDate &&
        other.mangaId == mangaId &&
        other.chapterId == chapterId &&
        other.chapterName == chapterName &&
        listEquals(other.pages, pages) &&
        other.views == views &&
        other.upvoteReact == upvoteReact &&
        other.awesomeReact == awesomeReact &&
        other.funnyReact == funnyReact &&
        other.loveReact == loveReact &&
        other.angryReact == angryReact &&
        other.sadReact == sadReact;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uploadDate.hashCode ^
        mangaId.hashCode ^
        chapterId.hashCode ^
        chapterName.hashCode ^
        pages.hashCode ^
        views.hashCode ^
        upvoteReact.hashCode ^
        awesomeReact.hashCode ^
        funnyReact.hashCode ^
        loveReact.hashCode ^
        angryReact.hashCode ^
        sadReact.hashCode;
  }
}
