import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mangaapp/helpers/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangaapp/search_page/screens/search_page.dart';
import 'package:mangaapp/search_page/widgets/search_extra_genres.dart';
import 'package:mangaapp/search_page/widgets/search_extra_sortby.dart';
import 'package:mangaapp/shared/muhnga_colors.dart';
import 'package:quiver/iterables.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchExtra extends ModalRoute<int> {
  Map<String, dynamic> filters;

  SearchExtra({super.settings, super.filter, required this.filters});

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
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
        title: Center(
            child: Text(
          'Search Settings',
          style: Theme.of(context).textTheme.titleMedium,
        )),
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
      // body:
      //     SafeArea(child: OrientationBuilder(builder: (context, orientation) {
      //   // orientation == Orientation.portrait ?
      //   var numButtons = orientation == Orientation.portrait
      //       ? (1.sw / 200.w).round()
      //       : (1.sw / 120.w).round();
      //   var genreRows = partition(GENRES, numButtons);
      //   var sortByRows = partition(SORT_BY, numButtons);
      //   return ListView(
      //       children: _buildList(genreRows, sortByRows, orientation));
      // }))
      body: Container(
        decoration: const BoxDecoration(
            color: MuhngaColors.primary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        // margin: const EdgeInsets.only(top: 20),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchExtraSortBy(filters),
              )),
              SliverToBoxAdapter(child: SearchExtraGenres(filters)),
            ],
          ),
        ),
      ),
    );
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
