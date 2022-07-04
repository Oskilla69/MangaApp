import 'package:flutter/material.dart';
import 'package:mangaapp/pages/comment_page.dart';
import 'package:mangaapp/widgets/comment.dart';
import 'package:widgetbook/widgetbook.dart';

class WidgetbookHotReload extends StatelessWidget {
  const WidgetbookHotReload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Widgetbook(
      categories: [
        WidgetbookCategory(
          name: 'material',
          widgets: [
            WidgetbookComponent(
              name: 'FAB',
              useCases: [
                WidgetbookUseCase(
                  name: 'Icon',
                  builder: (context) {
                    return FloatingActionButton(
                      onPressed: () {},
                      child: const Icon(Icons.add),
                    );
                  },
                ),
              ],
            ),
            WidgetbookComponent(name: 'comment widgets', useCases: [
              WidgetbookUseCase(
                  name: 'comment overview',
                  builder: (context) {
                    return const Comment(
                        profileUrl:
                            'https://firebasestorage.googleapis.com/v0/b/mangaapp-7bb62.appspot.com/o/profile_images%2Fa@gm.co?alt=media&token=ffb6b919-0ae6-4937-b276-23f046000396',
                        comment:
                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                        username: 'Oskilla',
                        upvotes: 69,
                        downvotes: 12344);
                  }),
              WidgetbookUseCase(
                  name: 'comment page',
                  builder: (context) {
                    return const CommentPage();
                  })
            ])
          ],
        ),
      ],
      appInfo: AppInfo(name: 'widgetbook'),
      themes: [
        WidgetbookTheme(
          name: 'Light',
          data: ThemeData.light(),
        ),
        WidgetbookTheme(
          name: 'Dark',
          data: ThemeData.dark(),
        ),
      ],
    );
  }
}
