import 'package:flutter/material.dart';
import '../../shared/muhnga_colors.dart';

class EmoteCounter {
  static Map<String, Color> highlightColor = {
    "background": MuhngaColors.neon,
    "text": MuhngaColors.primary
  };

  static Map<String, Color> defaultColor = {
    "background": MuhngaColors.secondary,
    "text": Colors.white
  };
}

class EmoteButton extends StatefulWidget {
  const EmoteButton(this.emote, this.emoteTitle, this.handleClick,
      this.iconOpacity, this.reactionCount, this.selected,
      {super.key});
  final String emote;
  final String emoteTitle;
  final VoidCallback handleClick;
  final double iconOpacity;
  final int reactionCount;
  final bool selected;
  @override
  State<EmoteButton> createState() => _EmoteButtonState();
}

class _EmoteButtonState extends State<EmoteButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          Stack(children: [
            Opacity(
              opacity: widget.iconOpacity,
              child: Image.asset(widget.emote),
            ),
            if (widget.iconOpacity != 1.0)
              Positioned(
                  right: 00,
                  top: 5,
                  child: Container(
                      decoration: BoxDecoration(
                          color: widget.selected
                              ? EmoteCounter.highlightColor["background"]
                              : EmoteCounter.defaultColor["background"],
                          borderRadius: BorderRadius.circular(50)),
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        widget.reactionCount.toString(),
                        style: Theme.of(context).textTheme.bodyMedium!.apply(
                              color: widget.selected
                                  ? EmoteCounter.highlightColor["text"]
                                  : EmoteCounter.defaultColor["text"],
                            ),
                      )))
          ]),
          const SizedBox(height: 10),
          Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                widget.emoteTitle,
                style: Theme.of(context).textTheme.titleMedium,
              )),
        ],
      ),
      onTap: () {
        widget.handleClick();
      },
    );
  }
}
