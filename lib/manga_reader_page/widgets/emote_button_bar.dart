import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mangaapp/manga_reader_page/widgets/emote_button.dart';

class EmoteButtonBar extends StatefulWidget {
  const EmoteButtonBar({super.key});

  @override
  State<EmoteButtonBar> createState() => _EmoteButtonBarState();
}

class _EmoteButtonBarState extends State<EmoteButtonBar> {
  double iconOpacity = 1.0;
  int imgSize = 96;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: width > 600 ? 6 : 3,
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        EmoteButton('assets/emotes/laff_${imgSize}x.webp', 'Funny', handleClick,
            iconOpacity, 123),
        EmoteButton('assets/emotes/luvv_${imgSize}x.webp', 'Love', handleClick,
            iconOpacity, 1234),
        EmoteButton('assets/emotes/majj_${imgSize}x.webp', 'Angry', handleClick,
            iconOpacity, 12),
        EmoteButton('assets/emotes/nise_${imgSize}x.webp', 'Upvote',
            handleClick, iconOpacity, 88),
        EmoteButton('assets/emotes/pogg_${imgSize}x.webp', 'Awesome',
            handleClick, iconOpacity, 99999),
        EmoteButton('assets/emotes/sajj_${imgSize}x.webp', 'Sad', handleClick,
            iconOpacity, 0),
      ],
    );
  }

  void handleClick() {
    setState(() {
      if (iconOpacity == 1.0) {
        iconOpacity = 0.5;
      } else if (iconOpacity == 0.5) {
        iconOpacity = 1.0;
      }
    });
  }
}
