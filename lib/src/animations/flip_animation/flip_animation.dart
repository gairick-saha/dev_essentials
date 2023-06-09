part of '../dev_animations.dart';

class FlipAnimationWrapper extends HookWidget {
  const FlipAnimationWrapper({
    Key? key,
    required this.controller,
    required this.firstChild,
    required this.secondChild,
    this.flipDuration = const Duration(milliseconds: 300),
    this.flipDirection = Axis.horizontal,
  }) : super(key: key);

  final FlipAnimationController controller;
  final Widget firstChild;
  final Widget secondChild;
  final Duration flipDuration;
  final Axis flipDirection;

  @override
  Widget build(BuildContext context) {
    final FlipAnimationHookState flipAnimationHookState = useFlipAnimationHook(
      controller: controller,
      flipDuration: flipDuration,
    );
    return AnimatedBuilder(
      animation: flipAnimationHookState.flipAnimationController,
      builder: (context, child) => Transform(
        transform: _buildAnimatedMatrix4(
          flipAnimationHookState.flipAnimationController.value,
        ),
        alignment: AlignmentDirectional.center,
        child: child,
      ),
      child: IndexedStack(
        index: flipAnimationHookState.isFront ? 0 : 1,
        alignment: AlignmentDirectional.center,
        children: [
          firstChild,
          Transform(
            transform: _buildSecondChildMatrix4(),
            alignment: AlignmentDirectional.center,
            child: secondChild,
          ),
        ],
      ),
    );
  }

  Matrix4 _buildAnimatedMatrix4(double value) {
    final matrix = Matrix4.identity()..setEntry(3, 2, 0.002);
    if (flipDirection == Axis.horizontal) {
      matrix.rotateY(value * pi);
    } else {
      matrix.rotateX(value * pi);
    }
    return matrix;
  }

  Matrix4 _buildSecondChildMatrix4() {
    if (flipDirection == Axis.horizontal) {
      return Matrix4.identity()..rotateY(pi);
    } else {
      return Matrix4.identity()..rotateX(pi);
    }
  }
}
