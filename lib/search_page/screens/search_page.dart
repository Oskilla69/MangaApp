import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mangaapp/shared/muhnga_constants.dart';
import 'package:mangaapp/shared/muhnga_icon_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../components/search_list_item.dart';
import 'search_extra.dart';
// import 'package:mangaapp/pages/search_extra.dart';

// maybe have history. Who knows
class SearchPageDelegate extends SearchDelegate<int?> {
  final _supabase = Supabase.instance.client;

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

  String buildSupaGenreFilter(List genres) {
    return genres.map((genre) => '$genre').join(',');
  }

  String buildSupaQuery(String query) {
    return query.split(" ").map((e) => "$e:*").join(" | ");
  }

  Future<PostgrestResponse<dynamic>> getSearchResults(
      String searchQuery) async {
    PostgrestFilterBuilder searchFilter;
    if (searchQuery.length < 3) {
      searchFilter = _supabase
          .from("manga_search")
          .select("id, cover, synopsis, title, avg_ratings, num_ratings");
    } else {
      searchFilter = _supabase
          .from("manga_search")
          .select("id, cover, synopsis, title, avg_ratings, num_ratings")
          .textSearch("fts", buildSupaQuery(searchQuery.trim()));
    }
    if (filters["genres"].length > 0) {
      searchFilter = searchFilter.overlaps(
          'genres', "{${filters['genres'].map((genre) => genre).join(',')}}");
    }
    if (filters['sort'] == SearchSettings.BEST_MATCH) {
      print("BEST MATCH");
    } else if (filters['sort'] == SearchSettings.TOTAL_VIEWS) {
      print("total views");
    } else if (filters['sort'] == SearchSettings.UPDATE_DATE) {
      print("update date");
    } else if (filters['sort'] == SearchSettings.FAVOURITES) {
      print("favourites");
    } else if (filters['sort'] == SearchSettings.RATING) {
      searchFilter.order('avg_ratings', ascending: !filters['descending']);
    }
    Future<PostgrestResponse<dynamic>> searchResults = searchFilter.execute();
    return searchResults;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      MuhngaIconButton(const Icon(Icons.clear), () {
        query = '';
      }),
      const SizedBox(
        width: 18,
      ),
      MuhngaIconButton(
        const Icon(Icons.filter_list_rounded),
        () {
          // showFilterDialog(context);
          Navigator.push<int>(context, SearchExtra(filters: filters))
              .then((value) {
            if (value == 1) {
              query = query;
            }
          });
        },
      ),
      const SizedBox(
        width: 18,
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: MuhngaIconButton(const Icon(Icons.arrow_back_ios_new), () {
        Navigator.pop(context);
      }),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<PostgrestResponse<dynamic>>(
        future: getSearchResults(query),
        builder: (BuildContext context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const ListTile(title: Text('None'));
            case ConnectionState.waiting:
              return const ListTile(title: Text('Waiting..'));
            case ConnectionState.active:
              return const ListTile(title: Text('Active..'));
            case ConnectionState.done:
              try {
                if (snapshot.data!.data != null) {
                  final setData = {...List.from(snapshot.data!.data)};
                  List<Widget> results = setData.map<Widget>((element) {
                    return SearchListItem(
                      manga: element,
                      leading: Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                              imageUrl: element['cover'],
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress)),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error)),
                        ),
                      ),
                      synopsis: element["synopsis"],
                      onClick: () => {close(context, 0)},
                    );
                  }).toList();
                  return ListView(children: results);
                } else {
                  return const ListTile(title: Text('Error'));
                }
              } catch (e) {
                return ListTile(title: Text('Error: $e'));
              }
          }
        });
  }
}
