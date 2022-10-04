import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'muhnga_colors.dart';

class MuhngaBottomBar extends StatelessWidget {
  MuhngaBottomBar(this.currIndex, this.onIconTapped, {Key? key})
      : super(key: key);
  int currIndex;
  final void Function(int) onIconTapped;
  final double size = 24.0;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: MuhngaColors.black,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    size: size,
                  ),
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                    size: size,
                  ),
                  label: 'Search'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite,
                    size: size,
                  ),
                  activeIcon: Icon(
                    Icons.favorite,
                    color: MuhngaColors.heartRed,
                    size: size,
                  ),
                  label: 'Favorites'),
              // BottomNavigationBarItem(
              //     icon: Icon(
              //       Icons.account_circle,
              //       size: size,
              //     ),
              //     activeIcon: Icon(
              //       Icons.account_circle,
              //       color: MuhngaColors.lightPink,
              //       size: size,
              //     ),
              //     label: 'Settings'),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/crown.svg',
                    color: MuhngaColors.grey,
                    height: size,
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/icons/crown.svg',
                    height: size,
                    color: MuhngaColors.star,
                  ),
                  label: 'Premium'),
            ],
            fixedColor: MuhngaColors.contrast,
            unselectedItemColor: MuhngaColors.grey,
            currentIndex: currIndex,
            onTap: onIconTapped,
          ),
        ));
  }
}
