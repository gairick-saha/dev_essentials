part of '../../widgets.dart';

class DevEssentialPageView extends HookWidget {
  DevEssentialPageView({
    Key? key,
    DevEssentialPageViewController? controller,
    required this.children,
    Duration? duration,
    this.onPageChanged,
  })  : _controller = controller ?? DevEssentialPageViewController(),
        _duration = duration ?? 600.milliseconds,
        super(key: key);

  final DevEssentialPageViewController _controller;
  final List<Widget> children;
  final Duration _duration;
  final DevEssentialPageViewOnChangeCallback? onPageChanged;

  @override
  Widget build(BuildContext context) {
    _DevEssentialPageViewState pageViewState = _usePageViewStateHook(
      controller: _controller,
      animationDuration: _duration,
      onChange: onPageChanged,
    );

    return AnimatedBuilder(
      animation: pageViewState._animationController,
      builder: (context, child) => SlideTransition(
        position: pageViewState._animationOffset
            .animate(pageViewState._animationController),
        child: child,
      ),
      child: IndexedStack(
        index: pageViewState._currentPage,
        children: children,
      ),
    );
  }
}
