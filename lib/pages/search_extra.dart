import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mangaapp/helpers/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangaapp/pages/search_page.dart';
import 'package:quiver/iterables.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchExtra extends ModalRoute<int> {
  Map<String, dynamic> filters;

  SearchExtra({super.settings, super.filter, required this.filters});

  @override
  Duration get transitionDuration => Duration(milliseconds: 0);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  // TODO: implement barrierLabel
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Search Settings')),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                // searchCallback(context, filters);
                Navigator.pop(context, 1);
              },
            ),
          ],
        ),
        body:
            SafeArea(child: OrientationBuilder(builder: (context, orientation) {
          // orientation == Orientation.portrait ?
          var numButtons = orientation == Orientation.portrait
              ? (1.sw / 200.w).round()
              : (1.sw / 120.w).round();
          var genreRows = partition(GENRES, numButtons);
          var sortByRows = partition(SORT_BY, numButtons);
          return ListView(
              children: _buildList(genreRows, sortByRows, orientation));
        })));
  }

  List<Widget> _buildList(Iterable<List<dynamic>> gRows,
      Iterable<List<dynamic>> sbRows, orientation) {
    List<Widget> genreRows = gRows.map((row) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: row.map((genre) {
          bool clicked = filters['genres'].contains(genre);
          return StatefulBuilder(builder: ((context, setState) {
            return Container(
              width: .4.sw,
              margin: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 5.h),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: clicked ? Colors.transparent : Colors.red,
                ),
                onPressed: () {
                  if (clicked) {
                    setState(() {
                      clicked = false;
                      filters['genres'].remove(genre);
                    });
                  } else {
                    setState(() {
                      clicked = true;
                      filters['genres'].add(genre);
                    });
                  }
                  print(filters);
                },
                icon: const Icon(Icons.abc_outlined),
                label: Text(genre),
              ),
            );
          }));
        }).toList(),
      );
    }).toList();

    var sortOrderRow = StatefulBuilder(builder: (context, setState) {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        // radio buttons for ascending and descending options
        SizedBox(
          width: .5.sw,
          child: RadioListTile(
            title: const Text('Descending'),
            value: true,
            groupValue: filters['descending'],
            onChanged: (value) {
              setState(() {
                filters['descending'] = value;
              });
            },
          ),
        ),
        SizedBox(
          width: .5.sw,
          child: RadioListTile(
            title: const Text('Ascending'),
            value: false,
            groupValue: filters['descending'],
            onChanged: (value) {
              setState(() {
                filters['descending'] = value;
              });
            },
          ),
        ),
      ]);
    });

    // var sortByRows = StatefulBuilder(builder: (context, setState) {});

    var sortByRows = StatefulBuilder(builder: ((context, setState) {
      return Column(
          children: sbRows.map((row) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((sortBy) {
              return SizedBox(
                width: .5.sw,
                child: RadioListTile<String>(
                    tileColor: Colors.black,
                    value: sortBy,
                    groupValue: filters['sort'],
                    onChanged: (value) {
                      setState(() {
                        filters['sort'] = value;
                      });
                    },
                    title: Text(sortBy)),
              );
            }).toList());
      }).toList());
    }));
    return genreRows;
    // return filters['sort'] == SORT_BY[0]
    //     ? [...genreRows, sortByRows]
    //     : [...genreRows, sortOrderRow, sortByRows];
    // var sortByRow = StatefulBuilder(builder: (context, setState) {
    //   return
    // });
  }
}

// return Scaffold(
//       appBar: AppBar(
//         title: Text('Search Settings'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.check),
//             onPressed: () {
//               searchCallback(context, filters);
//               Navigator.pop(context);
//             },
//           ),
//         ],
//       ),
//       body: SafeArea(child: OrientationBuilder(
//         builder: (context, orientation) {
//           // orientation == Orientation.portrait ?
//           var numButtons = orientation == Orientation.portrait
//               ? (1.sw / 200.w).round()
//               : (1.sw / 120.w).round();
//           var rows = partition(GENRES, numButtons);

//           return ListView(children: _buildList(rows, orientation));

//           // //       StatefulBuilder(builder: (context, setState) {
//           // //         return GridView.count(
//           // //             // shrinkWrap: true,
//           // //             // scrollDirection: Axis.vertical,
//           // //             crossAxisCount: orientation == Orientation.portrait
//           // //                 ? (1.sw / 200.w).round()
//           // //                 : (1.sw / 120.w).round(),
//           // //             childAspectRatio: orientation == Orientation.portrait
//           // //                 ? 50.w / 16.5.h
//           // //                 : 20.w / 18.h,
//           // //             children: SORT_BY.map((element) {
//           // //               return RadioListTile<String>(
//           // //                   tileColor: Colors.black,
//           // //                   value: element,
//           // //                   groupValue: filters['sort'],
//           // //                   onChanged: (value) {
//           // //                     setState(() {
//           // //                       filters['sort'] = value;
//           // //                     });
//           // //                   },
//           // //                   title: Text(element));
//           // //             }).toList());
//           // //       }),
//           //     ],
//           //   ),
//           // );
//         },
//       )),
//     );

//     rowView.add(

//     return rowView;
//   }
