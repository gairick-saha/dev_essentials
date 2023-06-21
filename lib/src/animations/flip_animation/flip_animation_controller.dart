part of '../dev_animations.dart';

class FlipAnimationController extends ValueNotifier<bool> {
  FlipAnimationController({bool isFront = true}) : super(isFront);

  bool get isFront => value;

  set isFront(v) => value = v;

  void flip() => value = !value;
}
