part of '../dev_animations.dart';

FlipAnimationHookState useFlipAnimationHook({
  required FlipAnimationController controller,
  required Duration flipDuration,
}) {
  TickerProvider vsync = useSingleTickerProvider();
  return use<FlipAnimationHookState>(
    FlipAnimationHook(
      controller: controller,
      vsync: vsync,
      flipDuration: flipDuration,
    ),
  );
}

class FlipAnimationHook extends Hook<FlipAnimationHookState> {
  const FlipAnimationHook({
    required this.controller,
    required this.vsync,
    required this.flipDuration,
  });

  final FlipAnimationController controller;
  final TickerProvider vsync;
  final Duration flipDuration;

  @override
  HookState<FlipAnimationHookState, Hook<FlipAnimationHookState>>
      createState() => FlipAnimationHookState();
}

class FlipAnimationHookState
    extends HookState<FlipAnimationHookState, FlipAnimationHook> {
  late AnimationController flipAnimationController;
  late bool isFront;

  @override
  void initHook() {
    super.initHook();
    isFront = true;
    flipAnimationController = AnimationController(
      value: isFront ? 0 : 1,
      vsync: hook.vsync,
      duration: hook.flipDuration,
    );
    flipAnimationController.addListener(_listenAnimationController);
    hook.controller.addListener(_listenAnimationFlips);
    setState(() {});
  }

  @override
  void dispose() {
    flipAnimationController.removeListener(_listenAnimationController);
    flipAnimationController.dispose();
    super.dispose();
  }

  void _listenAnimationFlips() {
    if (hook.controller.isFront) {
      flipAnimationController.reverse();
    } else {
      flipAnimationController.forward();
    }
  }

  void _listenAnimationController() {
    if (isFront && flipAnimationController.value > 0.5) {
      isFront = false;
    } else if (!isFront && flipAnimationController.value < 0.5) {
      isFront = true;
    }
    setState(() {});
  }

  @override
  FlipAnimationHookState build(BuildContext context) => this;
}
