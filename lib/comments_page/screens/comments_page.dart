import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import '../widgets/comment_page_card.dart';
import '../../manga_page/screens/manga_page.dart';
import '../../shared/muhnga_app_bar.dart';
import '../../shared/muhnga_colors.dart';
import '../../shared/muhnga_icon_button.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key});
  static const String routeName = '${MangaPage.routeName}/comments';

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  List<Widget> comments = [];
  final commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    comments.addAll([
      const CommentPageCard(),
      const CommentPageCard(),
      const CommentPageCard(),
      const CommentPageCard()
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MuhngaAppBar(
          "Comments",
          MuhngaIconButton(const Icon(Icons.arrow_back_ios_new), (() {
            Navigator.pop(context);
          })),
          const []),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: CustomRefreshIndicator(
            onRefresh: () async {
              comments.addAll([
                const CommentPageCard(),
                const CommentPageCard(),
                const CommentPageCard(),
                const CommentPageCard(),
              ]);
            },
            reversed: true,
            trailingScrollIndicatorVisible: false,
            leadingScrollIndicatorVisible: true,
            child: CustomScrollView(slivers: [
              SliverToBoxAdapter(
                  child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                          hintText: "Enter a comment",
                          border: const OutlineInputBorder(),
                          fillColor: MuhngaColors.secondary,
                          filled: true,
                          suffixIcon: IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: (() {
                                setState(() {
                                  comments = <Widget>[
                                        Center(
                                            child: Text(commentController.text))
                                      ] +
                                      comments;
                                });
                              }))),
                      maxLength: 500,
                      maxLines: 4)),
              SliverList(
                delegate: SliverChildListDelegate(comments),
              )
            ]),
            builder: (
              BuildContext context,
              Widget child,
              IndicatorController controller,
            ) {
              const height = 200.0;
              return AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) {
                    final dy = controller.value.clamp(0.0, 1.25) *
                        -(height - (height * 0.05));
                    return Stack(
                      children: [
                        Transform.translate(
                          offset: Offset(0.0, dy),
                          child: child,
                        ),
                        Positioned(
                          bottom: -height,
                          left: 0,
                          right: 0,
                          height: height,
                          child: Container(
                            transform: Matrix4.translationValues(0.0, dy, 0.0),
                            padding: const EdgeInsets.only(top: 30.0),
                            constraints: const BoxConstraints.expand(),
                            child: Column(
                              children: [
                                if (controller.isLoading)
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 8.0),
                                    width: 16,
                                    height: 16,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                else
                                  const Icon(
                                    Icons.keyboard_arrow_up,
                                  ),
                                Text(
                                  controller.isLoading
                                      ? "Loading..."
                                      : "Pull to load more comments.",
                                  // style: const TextStyle(),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  });
            },
          ),
        ),
      ),
    );
  }
}
