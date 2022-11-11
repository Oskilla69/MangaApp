import 'package:extended_image/extended_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mangaapp/shared/muhnga_colors.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class VerticalScroll extends StatefulWidget {
  const VerticalScroll(
      {super.key,
      required this.pageUrls,
      required this.pageTapCallback,
      required this.commentSection});
  final List<dynamic> pageUrls;
  final Function(BuildContext context, TapUpDetails tapUpDetails,
      PhotoViewControllerValue photoViewControllerValue) pageTapCallback;
  final List<Widget> commentSection;

  @override
  State<VerticalScroll> createState() => _VerticalScrollState();
}

class _VerticalScrollState extends State<VerticalScroll> {
  late final ScrollController commentController;
  late final PageController photoGalleryController;

  late ScrollController activeScrollController;
  Drag? drag;

  @override
  void initState() {
    super.initState();
    photoGalleryController = PageController();
    commentController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    photoGalleryController.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        VerticalDragGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer(),
                (VerticalDragGestureRecognizer instance) {
          instance
            ..onStart = _handleDragStart
            ..onUpdate = _handleDragUpdate
            ..onEnd = _handleDragEnd
            ..onCancel = _handleDragCancel;
        })
      },
      behavior: HitTestBehavior.opaque,
      child: PhotoViewGallery.builder(
        backgroundDecoration:
            const BoxDecoration(color: MuhngaColors.secondaryShade),
        scrollDirection: Axis.vertical,
        pageController: photoGalleryController,
        itemCount: widget.pageUrls.length + 1,
        scrollPhysics: const NeverScrollableScrollPhysics(),
        builder: (context, index) {
          if (index == widget.pageUrls.length) {
            return PhotoViewGalleryPageOptions.customChild(
              disableGestures: true,
              child: SingleChildScrollView(
                  controller: commentController,
                  physics: const NeverScrollableScrollPhysics(),
                  child: SafeArea(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(children: widget.commentSection),
                  ))),
            );
          }
          return PhotoViewGalleryPageOptions(
              onTapUp: widget.pageTapCallback,
              initialScale: 1.0,
              minScale: 1.0,
              maxScale: 3.2,
              imageProvider: ExtendedNetworkImageProvider(
                  widget.pageUrls[index],
                  cache: true));
        },
      ),
    );
  }

  void _handleDragStart(DragStartDetails details) {
    if (commentController.hasClients &&
        commentController.position.context.storageContext != null) {
      final RenderBox renderBox =
          commentController.position.context.storageContext.findRenderObject()
              as RenderBox;
      if (renderBox.paintBounds
          .shift(renderBox.localToGlobal(Offset.zero))
          .contains(details.globalPosition)) {
        activeScrollController = commentController;
        drag = activeScrollController.position.drag(details, _disposeDrag);
        return;
      }
    }
    activeScrollController = photoGalleryController;
    drag = photoGalleryController.position.drag(details, _disposeDrag);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (activeScrollController == commentController &&
        details.primaryDelta! < 0 &&
        activeScrollController.position.pixels ==
            activeScrollController.position.maxScrollExtent) {
      activeScrollController = photoGalleryController;
      drag?.cancel();
      drag = photoGalleryController.position.drag(
          DragStartDetails(
              globalPosition: details.globalPosition,
              localPosition: details.localPosition),
          _disposeDrag);
    } else if (activeScrollController == commentController &&
        details.primaryDelta! > 0 &&
        (activeScrollController.position.pixels ==
            activeScrollController.position.minScrollExtent)) {
      activeScrollController = photoGalleryController;
      drag?.cancel();
      drag = photoGalleryController.position.drag(
          DragStartDetails(
              globalPosition: details.globalPosition,
              localPosition: details.localPosition),
          _disposeDrag);
    }
    drag?.update(details);
  }

  void _handleDragEnd(DragEndDetails details) {
    drag?.end(details);
  }

  void _handleDragCancel() {
    drag?.cancel();
  }

  void _disposeDrag() {
    drag = null;
  }
}
