import 'package:flutter/material.dart';
import 'package:mangaapp/manga_reader_page/models/reactions_model.dart';
import 'package:provider/provider.dart';
import 'emote_button.dart';

enum Reactions { upvote, awesome, love, funny, angry, sad }

class EmoteButtonBar extends StatefulWidget {
  const EmoteButtonBar({super.key});

  @override
  State<EmoteButtonBar> createState() => _EmoteButtonBarState();
}

class _EmoteButtonBarState extends State<EmoteButtonBar> {
  double iconOpacity = 1.0;
  int imgSize = 96;
  Reactions? currReaction;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<ReactionsModel>(
      builder: (context, reactions, child) {
        void decrement() {
          if (currReaction == Reactions.upvote) {
            reactions.setUpvotes(reactions.upvotes - 1, false);
          } else if (currReaction == Reactions.awesome) {
            reactions.setAwesome(reactions.awesome - 1, false);
          } else if (currReaction == Reactions.love) {
            reactions.setLove(reactions.love - 1, false);
          } else if (currReaction == Reactions.funny) {
            reactions.setFunny(reactions.funny - 1, false);
          } else if (currReaction == Reactions.angry) {
            reactions.setAngry(reactions.angry - 1, false);
          } else if (currReaction == Reactions.sad) {
            reactions.setSad(reactions.sad - 1, false);
          }
        }

        void handleUpvoteClick() {
          if (iconOpacity == 1.0) {
            iconOpacity = 0.5;
          }
          if (currReaction != Reactions.upvote) {
            decrement();
            reactions.setUpvotes(reactions.upvotes + 1, true);
          }
          // else if (iconOpacity == 0.5) {
          //   iconOpacity = 1.0;
          //   reactions.setUpvotes(reactions.upvotes - 1, true);
          // }
          currReaction = Reactions.upvote;
        }

        void handleAwesomeClick() {
          if (iconOpacity == 1.0) {
            iconOpacity = 0.5;
          }
          if (currReaction != Reactions.awesome) {
            decrement();
            reactions.setAwesome(reactions.awesome + 1, true);
          }
          currReaction = Reactions.awesome;
        }

        void handleLoveClick() {
          if (iconOpacity == 1.0) {
            iconOpacity = 0.5;
          }
          if (currReaction != Reactions.love) {
            decrement();
            reactions.setLove(reactions.love + 1, true);
          }
          currReaction = Reactions.love;
        }

        void handleFunnyClick() {
          if (iconOpacity == 1.0) {
            iconOpacity = 0.5;
          }
          if (currReaction != Reactions.funny) {
            decrement();
            reactions.setFunny(reactions.funny + 1, true);
          }
          currReaction = Reactions.funny;
        }

        void handleAngryClick() {
          if (iconOpacity == 1.0) {
            iconOpacity = 0.5;
          }
          if (currReaction != Reactions.angry) {
            decrement();
            reactions.setAngry(reactions.angry + 1, true);
          }
          currReaction = Reactions.angry;
        }

        void handleSadClick() {
          if (iconOpacity == 1.0) {
            iconOpacity = 0.5;
          }
          if (currReaction != Reactions.sad) {
            decrement();
            reactions.setSad(reactions.sad + 1, true);
          }
          currReaction = Reactions.sad;
        }

        return Column(
          children: [
            Center(
              child: Text(
                '${reactions.total} reactions',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: width > 600 ? 6 : 3,
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                EmoteButton(
                    'assets/emotes/nise_${imgSize}x.webp',
                    'Upvote',
                    handleUpvoteClick,
                    iconOpacity,
                    reactions.upvotes,
                    currReaction == Reactions.upvote),
                EmoteButton(
                    'assets/emotes/pogg_${imgSize}x.webp',
                    'Awesome',
                    handleAwesomeClick,
                    iconOpacity,
                    reactions.awesome,
                    currReaction == Reactions.awesome),
                EmoteButton(
                    'assets/emotes/luvv_${imgSize}x.webp',
                    'Love',
                    handleLoveClick,
                    iconOpacity,
                    reactions.love,
                    currReaction == Reactions.love),
                EmoteButton(
                    'assets/emotes/laff_${imgSize}x.webp',
                    'Funny',
                    handleFunnyClick,
                    iconOpacity,
                    reactions.funny,
                    currReaction == Reactions.funny),
                EmoteButton(
                    'assets/emotes/majj_${imgSize}x.webp',
                    'Angry',
                    handleAngryClick,
                    iconOpacity,
                    reactions.angry,
                    currReaction == Reactions.angry),
                EmoteButton(
                    'assets/emotes/sajj_${imgSize}x.webp',
                    'Sad',
                    handleSadClick,
                    iconOpacity,
                    reactions.sad,
                    currReaction == Reactions.sad),
              ],
            )
          ],
        );
      },
    );
  }
}
