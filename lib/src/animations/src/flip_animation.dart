part of '../dev_animations.dart';

class FlipAnimationWrapper extends HookWidget {
  const FlipAnimationWrapper({
    Key? key,
    required this.firstChild,
    required this.secondChild,
    this.flipDuration = const Duration(milliseconds: 300),
    this.flipDirection = Axis.horizontal,
  }) : super(key: key);

  final FlipAnimationChildBuilder firstChild;
  final FlipAnimationChildBuilder secondChild;
  final Duration flipDuration;
  final Axis flipDirection;

  @override
  Widget build(BuildContext context) {
    final FlipAnimationHookState flipAnimationHookState =
        useFlipAnimationHook(flipDuration: flipDuration);
    var child = AnimatedBuilder(
      animation: flipAnimationHookState.flipAnimationController,
      builder: (context, child) => Transform(
        transform: _buildAnimatedMatrix4(
          flipAnimationHookState.flipAnimationController.value,
        ),
        alignment: Alignment.center,
        child: child,
      ),
      child: IndexedStack(
        index: flipAnimationHookState.isFront ? 0 : 1,
        alignment: Alignment.center,
        children: [
          firstChild(
            context,
            flipAnimationHookState.flipAnimationController,
          ),
          Transform(
            transform: _buildSecondChildMatrix4(),
            alignment: Alignment.center,
            child: secondChild(
              context,
              flipAnimationHookState.flipAnimationController,
            ),
          ),
        ],
      ),
    );
    return child;
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
