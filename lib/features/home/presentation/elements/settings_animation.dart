import 'package:flutter/material.dart';

class ProgressAnimation {
  final TickerProvider vsync;
  final void Function() onUpdate;
  late final AnimationController controller;
  late final Animation<double> animation;

  ProgressAnimation({
    required this.vsync,
    required this.onUpdate,
    double targetProgress = 46 / 60,
    Duration duration = const Duration(seconds: 2),
  }) {
    controller = AnimationController(vsync: vsync, duration: duration);
    animation = Tween<double>(begin: 0.0, end: targetProgress).animate(controller)
      ..addListener(onUpdate);
    controller.forward();
  }

  void dispose() {
    controller.dispose();
  }
}
