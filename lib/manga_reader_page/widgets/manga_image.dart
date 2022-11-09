import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
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
  // Animation<double>? animation;
  Animation<Matrix4>? animation;
  TapDownDetails? tapDownDetails;
  final GlobalKey<ExtendedImageGestureState> gestureKey =
      GlobalKey<ExtendedImageGestureState>();
  late void Function() animationListener;
  List<double> doubleTapScales = <double>[1.0, 2.0];

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
    // return ExtendedImage.network(
    //   widget.url,
    //   cache: true,
    //   mode: ExtendedImageMode.gesture,
    //   initGestureConfigHandler: (state) {
    //     return GestureConfig(
    //       minScale: 1.0,
    //       animationMinScale: 0.7,
    //       maxScale: 3.0,
    //       animationMaxScale: 3.5,
    //       speed: 1.0,
    //       inertialSpeed: 100.0,
    //       initialScale: 1.0,
    //       inPageView: true,
    //       initialAlignment: InitialAlignment.center,
    //     );
    //   },
    //   extendedImageGestureKey: gestureKey,
    //   onDoubleTap: (ExtendedImageGestureState state) {
    //     ///you can use define pointerDownPosition as you can,
    //     ///default value is double tap pointer down postion.
    //     var pointerDownPosition = state.pointerDownPosition;
    //     double? begin = state.gestureDetails?.totalScale;
    //     double end;

    //     //remove old
    //     animation?.removeListener(animationListener);

    //     //stop pre
    //     animationController.stop();

    //     //reset to use
    //     animationController.reset();

    //     if (begin == doubleTapScales[0]) {
    //       end = doubleTapScales[1];
    //     } else {
    //       end = doubleTapScales[0];
    //     }

    //     animationListener = () {
    //       //print(animation.value);
    //       state.handleDoubleTap(
    //           scale: animation!.value, doubleTapPosition: pointerDownPosition);
    //     };
    //     animation =
    //         animationController.drive(Tween<double>(begin: begin, end: end));

    //     animation!.addListener(animationListener);

    //     animationController.forward();
    //   },
    // );
    return InteractiveViewer(
        // clipBehavior: Clip.none,
        transformationController: controller,
        minScale: 1.0,
        maxScale: 3.0,
        constrained: false,
        child: GestureDetector(
          onDoubleTapDown: (details) {
            tapDownDetails = details;
          },
          onDoubleTap: () {
            final position = tapDownDetails!.localPosition;
            const double scale = 2;
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
            // fit: BoxFit.contain,
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
