import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MangaImage extends StatefulWidget {
  const MangaImage(this.url, {super.key});
  final String url;

  @override
  State<MangaImage> createState() => _MangaImageState();
}

class _MangaImageState extends State<MangaImage>
    with SingleTickerProviderStateMixin {
  late TransformationController controller;
  late AnimationController animationController;
  Animation<Matrix4>? animation;
  TapDownDetails? tapDownDetails;

  @override
  void initState() {
    super.initState();
    controller = TransformationController();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        controller.value = animation!.value;
      });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
        // clipBehavior: Clip.none,
        transformationController: controller,
        minScale: 1.0,
        maxScale: 4.0,
        constrained: false,
        child: GestureDetector(
          onDoubleTapDown: (details) {
            tapDownDetails = details;
          },
          onDoubleTap: () {
            final position = tapDownDetails!.localPosition;
            const double scale = 3;
            final x = -position.dx * (scale - 1);
            final y = -position.dy * (scale - 1);
            final zoomed = Matrix4.identity()
              ..translate(x, y)
              ..scale(scale);
            final endState =
                controller.value.isIdentity() ? zoomed : Matrix4.identity();
            animation = Matrix4Tween(begin: controller.value, end: endState)
                .animate(CurveTween(curve: Curves.easeOut)
                    .animate(animationController));
            animationController.forward(from: 0);
          },
          child: CachedNetworkImage(
            width: 1.sw,
            fit: BoxFit.contain,
            imageUrl: widget.url,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                const Center(child: Icon(Icons.error)),
          ),
        ));
  }

// TODO: FIX THIS PLEASE. ZOOM OUT IS TAKING ORIGINAL i.e. START ONLY
  // @override
  // Widget build(BuildContext context) {
  //   return InteractiveViewer(
  //     clipBehavior: Clip.none,
  //     transformationController: controller,
  //     minScale: 1.0,
  //     maxScale: 4.0,
  //     constrained: false,
  //     child: SingleChildScrollView(
  //       child: Column(
  //         children: widget.url
  //             .map((e) => GestureDetector(
  //                   onDoubleTapDown: (details) {
  //                     tapDownDetails = details;
  //                   },
  //                   onDoubleTap: () {
  //                     final position = tapDownDetails!.localPosition;
  //                     const double scale = 3;
  //                     final x = -position.dx * (scale - 1);
  //                     final y = -position.dy * (scale - 1);
  //                     // zoomedIn = !zoomedIn;
  //                     final zoomed = Matrix4.identity()
  //                       ..translate(x, y)
  //                       ..scale(scale);
  //                     final identity = Matrix4.identity()
  //                       ..translate(position.dx, position.dy)
  //                       ..scale(1.0);
  //                     final endState =
  //                         controller.value.isIdentity() ? zoomed : identity;
  //                     animation =
  //                         Matrix4Tween(begin: controller.value, end: endState)
  //                             .animate(CurveTween(curve: Curves.easeOut)
  //                                 .animate(animationController));
  //                     animationController.forward(from: 0);
  //                   },
  //                   child: CachedNetworkImage(
  //                     width: 1.sw,
  //                     fit: BoxFit.contain,
  //                     imageUrl: e,
  //                     placeholder: (context, url) =>
  //                         const Center(child: CircularProgressIndicator()),
  //                     errorWidget: (context, url, error) =>
  //                         const Center(child: Icon(Icons.error)),
  //                   ),
  //                 ))
  //             .toList(),
  //       ),
  //     ),
  //   );
  // }
}
