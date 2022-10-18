import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../shared/muhnga_constants.dart';

// class SortBy {
//   String value;
//   String order;
// }

class SearchExtraSortBy extends StatefulWidget {
  const SearchExtraSortBy(this.filters, {super.key});
  final Map<String, dynamic> filters;

  @override
  State<SearchExtraSortBy> createState() => _SearchExtraSortByState();
}

class _SearchExtraSortByState extends State<SearchExtraSortBy> {
  final Map<String, dynamic> data = {
    "Best Match": {
      "order": "descending",
      "value": SearchSettings.BEST_MATCH,
      "display": "Best Match"
    },
    "Most Views": {
      "order": "descending",
      "value": SearchSettings.TOTAL_VIEWS,
      "display": "Most Views",
    },
    "Least Views": {
      "order": "ascending",
      "value": SearchSettings.TOTAL_VIEWS,
      "display": "Least Views",
    },
    "Latest Update": {
      "order": "descending",
      "value": SearchSettings.UPDATE_DATE,
      "display": "Latest Update"
    },
    "Oldest Update": {
      "order": "ascending",
      "value": SearchSettings.UPDATE_DATE,
      "display": "Oldest Update"
    },
    "Most Favorites": {
      "order": "descending",
      "value": SearchSettings.FAVOURITES,
      "display": "Most Favorites"
    },
    "Least Favorites": {
      "order": "ascending",
      "value": SearchSettings.FAVOURITES,
      "display": "Least Favorites"
    },
    "Highest Rating": {
      "order": "descending",
      "value": SearchSettings.RATING,
      "display": "Highest Rating"
    },
    "Lowest Rating": {
      "order": "descending",
      "value": SearchSettings.RATING,
      "display": "Lowest Rating"
    }
  };

  @override
  Widget build(BuildContext context) {
    String dropdownValue = widget.filters['display'] ?? "Best Match";
    bool showOrderOptions = widget.filters['sort'] != "Best Match";

    return Align(
      alignment: Alignment.topLeft,
      child: DropdownButton<String>(
        value: dropdownValue,
        items: const [
          DropdownMenuItem(
            value: "Best Match",
            child: Text("Best Match"),
          ),
          DropdownMenuItem(
            value: "Most Views",
            child: Text("Most Views"),
          ),
          DropdownMenuItem(
            value: "Least Views",
            child: Text("Least Views"),
          ),
          DropdownMenuItem(
            value: "Latest Update",
            child: Text("Latest Update"),
          ),
          DropdownMenuItem(
            value: "Oldest Update",
            child: Text("Oldest Update"),
          ),
          DropdownMenuItem(
            value: "Most Favorites",
            child: Text("Most Favorites"),
          ),
          DropdownMenuItem(
            value: "Least Favorites",
            child: Text("Least Favorites"),
          ),
          DropdownMenuItem(
            value: "Highest Rating",
            child: Text("Highest Rating"),
          ),
          DropdownMenuItem(
            value: "Lowest Rating",
            child: Text("Lowest Rating"),
          ),
        ],
        onChanged: (value) {
          setState(() {
            widget.filters['sort'] = data[value]['value'];
            widget.filters['display'] = value;
            widget.filters['descending'] = data[value]['order'] == 'descending';
            dropdownValue = value!;
          });
        },
      ),
    );

    return DropdownButton(
      value: dropdownValue,
      items: const [
        DropdownMenuItem(
          value: {
            "order": "descending",
            "value": "Best Match",
            "display": "Best Match"
          },
          child: Text("Best Match"),
        ),
        DropdownMenuItem(
          value: {
            "order": "descending",
            "value": "Total Views",
            "display": "Most Views"
          },
          child: Text("Most Views"),
        ),
        DropdownMenuItem(
          value: {
            "order": "ascending",
            "value": "Total Views",
            "display": "Least Views"
          },
          child: Text("Least Views"),
        ),
        DropdownMenuItem(
          value: {
            "order": "descending",
            "value": "Update Date",
            "display": "Latest Update"
          },
          child: Text("Latest Update"),
        ),
        DropdownMenuItem(
          value: {
            "order": "ascending",
            "value": "Update Date",
            "display": "Oldest Update"
          },
          child: Text("Oldest Update"),
        ),
        DropdownMenuItem(
          value: {
            "order": "descending",
            "value": "Favorites",
            "display": "Most Favorites"
          },
          child: Text("Most Favorites"),
        ),
        DropdownMenuItem(
          value: {
            "order": "ascending",
            "value": "Favorites",
            "display": "Least Favorites"
          },
          child: Text("Least Favorites"),
        ),
        DropdownMenuItem(
          value: {
            "order": "descending",
            "value": "Rating",
            "display": "Highest Rating"
          },
          child: Text("Highest Rating"),
        ),
        DropdownMenuItem(
          value: {
            "order": "descending",
            "value": "Rating",
            "display": "Lowest Rating"
          },
          child: Text("Lowest Rating"),
        ),
      ],
      onChanged: (dynamic value) {
        setState(() {
          widget.filters['sort'] = value['value'];
          widget.filters['descending'] = value['order'] == 'descending';
        });
      },
    );
    return Wrap(
      children: [
        showOrderOptions
            ? Row(
                children: [
                  SizedBox(
                    width: 0.5.sw,
                    child: RadioListTile(
                      title: const Text('Descending'),
                      value: true,
                      groupValue: widget.filters['descending'],
                      onChanged: (value) {
                        setState(() {
                          widget.filters['descending'] = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 0.5.sw,
                    child: RadioListTile(
                      title: const Text('Ascending'),
                      value: false,
                      groupValue: widget.filters['descending'],
                      onChanged: (value) {
                        setState(() {
                          widget.filters['descending'] = value;
                        });
                      },
                    ),
                  )
                ],
              )
            : Container(),
        ...SORT_BY.map((sortBy) {
          return SizedBox(
            width: 0.5.sw,
            child: RadioListTile<String>(
                value: sortBy,
                groupValue: widget.filters['sort'],
                onChanged: (value) {
                  setState(() {
                    if (value != "Best Match") {}
                    widget.filters['sort'] = value;
                  });
                },
                title: Text(sortBy)),
          );
        })
      ],
    );
  }
}
