import 'package:flutter/material.dart';
import 'package:mangaapp/shared/muhnga_constants.dart';
import 'package:mangaapp/shared/muhnga_colors.dart';

class SearchExtraGenres extends StatefulWidget {
  const SearchExtraGenres(this.filters, {super.key});
  final Map<String, dynamic> filters;
  @override
  State<SearchExtraGenres> createState() => _SearchExtraGenresState();
}

class _SearchExtraGenresState extends State<SearchExtraGenres> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Wrap(
        spacing: 5,
        children: GENRES.map((genre) {
          bool clicked = widget.filters['genres'].contains(genre);
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  clicked ? MuhngaColors.contrast : MuhngaColors.secondary,
            ),
            onPressed: () {
              if (clicked) {
                setState(() {
                  clicked = false;
                  widget.filters['genres'].remove(genre);
                });
              } else {
                setState(() {
                  clicked = true;
                  widget.filters['genres'].add(genre);
                });
              }
              print(widget.filters);
            },
            child: Text(
              genre,
              style: TextStyle(
                  color:
                      clicked ? MuhngaColors.secondary : MuhngaColors.contrast),
            ),
          );
        }).toList(),
      ),
    );
  }
}
