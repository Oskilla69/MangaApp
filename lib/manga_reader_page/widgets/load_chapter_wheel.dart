import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadChapterWheel extends StatelessWidget {
  const LoadChapterWheel(
    this.controller,
    this.child, {
    super.key,
    required this.vertical,
    required this.start,
  });
  final IndicatorController controller;
  final Widget child;
  final bool start;
  final bool vertical;
  @override
  Widget build(BuildContext context) {
    return vertical ? buildVertical(context) : buildHorizontal(context);
  }

  Widget buildVertical(BuildContext context) {
    const height = 200.0;
    num startMultiplier = start ? 1 : -1;
    return AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final dy = controller.value.clamp(0.0, 1.25) *
              (0.95 * height) *
              startMultiplier;
          return Stack(
            children: [
              Transform.translate(
                offset: Offset(0.0, dy),
                child: child,
              ),
              Positioned(
                top: start ? height * -0.36 : null,
                bottom: start ? null : height * -0.85,
                left: 0,
                right: 0,
                height: height,
                child: Container(
                  transform: Matrix4.translationValues(0.0, dy, 0.0),
                  padding: start
                      ? const EdgeInsets.only(bottom: 32.0)
                      : const EdgeInsets.only(top: 32.0),
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
                            : start
                                ? "Pull up to go to the previous chapter."
                                : "Pull up to go to the next chapter.",
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget buildHorizontal(BuildContext context) {
    const width = 120.0;
    num startMultiplier = start ? 1 : -1;
    return AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final dx = controller.value.clamp(0.0, 6.9) *
              (0.75 * width) *
              startMultiplier;
          return Stack(
            children: [
              Transform.translate(
                offset: Offset(-dx, 0.0),
                child: child,
              ),
              Positioned(
                top: .46.sh,
                left: start ? null : -width,
                right: start ? -width : null,
                width: width,
                height: width,
                child: Container(
                  transform: Matrix4.translationValues(-dx, 0.0, 0.0),
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
                          Icons.keyboard_arrow_right,
                        ),
                      Text(
                        controller.isLoading
                            ? "Loading..."
                            : start
                                ? "Pull right to go to the previous chapter."
                                : "Pull right to go to the next chapter.",
                        // style: const TextStyle(),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}
