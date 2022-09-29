import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:mangaapp/shared/supabase/supabase_constants.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Supabasing {
  final client =
      SupabaseClient(SupabaseConstants.projectUrl, SupabaseConstants.apiKey);
  // Supabasing() {}

  static SupabaseClient get instance {
    return SupabaseClient(
        SupabaseConstants.projectUrl, SupabaseConstants.apiKey);
  }

  void migrateManga() async {
    int findGenre(List<dynamic> data, String genre) {
      for (var i = 0; i < data.length; i++) {
        if (genre == data[i]['genres']) {
          return data[i]['id'];
        }
      }
      return 36;
    }

    const covers = [
      "https://bmhrqpbhhvpbybrjiesv.supabase.co/storage/v1/object/public/manga/test/cover_1.jpeg",
      "https://bmhrqpbhhvpbybrjiesv.supabase.co/storage/v1/object/public/manga/test/cover_2.jpeg",
      "https://bmhrqpbhhvpbybrjiesv.supabase.co/storage/v1/object/public/manga/test/cover_3.jpeg"
    ];
    const pages = [
      "https://bmhrqpbhhvpbybrjiesv.supabase.co/storage/v1/object/public/manga/test/1.png",
      "https://bmhrqpbhhvpbybrjiesv.supabase.co/storage/v1/object/public/manga/test/2.png",
      "https://bmhrqpbhhvpbybrjiesv.supabase.co/storage/v1/object/public/manga/test/3.png",
      "https://bmhrqpbhhvpbybrjiesv.supabase.co/storage/v1/object/public/manga/test/4.png",
      "https://bmhrqpbhhvpbybrjiesv.supabase.co/storage/v1/object/public/manga/test/5.png",
      "https://bmhrqpbhhvpbybrjiesv.supabase.co/storage/v1/object/public/manga/test/6.png",
      "https://bmhrqpbhhvpbybrjiesv.supabase.co/storage/v1/object/public/manga/test/7.png",
      "https://bmhrqpbhhvpbybrjiesv.supabase.co/storage/v1/object/public/manga/test/8.png",
      "https://bmhrqpbhhvpbybrjiesv.supabase.co/storage/v1/object/public/manga/test/9.png",
    ];
    final getGenres = await client.from("genres").select().execute();
    dynamic genres = getGenres.data;
    // final getManga = await client.from("manga").select().execute();
    // dynamic manga = getManga.data;
    // for (var mangaData in manga) {}
    rootBundle.loadString('assets/manga_data.json').then((data) async {
      for (var manga in json.decode(data)) {
        final mangaInsertion = await client.from("manga").insert([
          {
            "title": manga['title'],
            "synopsis": manga['synopsis'],
            "rating": manga['rating'],
            "status": manga['status'] ?? "ongoing",
            "update_schedule": "every week tuesday",
            "views": manga['views'],
            "publisher": 1,
            "cover": covers[Random().nextInt(3)]
          },
        ]).execute();
        if (mangaInsertion.data == null) {
          print('response error: ${mangaInsertion.error}');
        }
        final mangaData = mangaInsertion.data[0];

        final authorInsert = await client.from("authors").insert([
          {"name": manga['author']}
        ]).execute();
        if (authorInsert.data == null) {
          print('response error: ${authorInsert.error}');
        }

        final authorMangaInsert = await client.from("manga_authors").insert([
          {"manga": mangaData['id'], "author": authorInsert.data[0]['id']}
        ]).execute();
        List chapters = [];
        int chapterCount = (Random().nextInt(12) + 6);
        for (var i = 1; i < chapterCount; i++) {
          chapters.add({
            "upload_date": DateTime.parse(manga['last_updated'])
                .subtract(Duration(days: chapterCount - i))
                .toIso8601String(),
            "manga": mangaData['id'],
            "chapter": i,
            "chapter_name": "wow",
            "pages": pages,
            "views": (manga['views'] / chapterCount).round()
          });
        }

        manga['genre'].forEach((genre) async {
          final genreInsertion = await client.from("manga_genres").insert([
            {"manga": mangaData['id'], "genre": findGenre(genres, genre)}
          ]).execute();
          if (genreInsertion.data == null) {
            print('response error: ${genreInsertion.error}');
          }
        });

        final chapterInsertion =
            await client.from("chapter").insert(chapters).execute();
        if (chapterInsertion.data == null) {
          print('response error: ${chapterInsertion.error}');
        }
      }
    });
  }
}
