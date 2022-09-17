import 'package:flutter/material.dart';
import 'package:mangaapp/shared/muhnga_colors.dart';

class MuhngaBottomBar extends StatelessWidget {
  MuhngaBottomBar(this.currIndex, this.onIconTapped, {Key? key})
      : super(key: key);
  int currIndex;
  final void Function(int) onIconTapped;

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
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  activeIcon:
                      Icon(Icons.favorite, color: MuhngaColors.heartRed),
                  label: 'Favorites'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  activeIcon: Icon(
                    Icons.account_circle,
                    color: MuhngaColors.lightPink,
                  ),
                  label: 'Settings')
            ],
            fixedColor: MuhngaColors.neon,
            unselectedItemColor: MuhngaColors.grey,
            currentIndex: currIndex,
            onTap: onIconTapped,
          ),
        ));
  }
}
