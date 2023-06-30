part of '../../widgets.dart';

typedef DevEssentialPageViewOnChangeCallback = void Function(int index);

_DevEssentialPageViewState _usePageViewStateHook({
  required DevEssentialPageViewController controller,
  required Duration animationDuration,
  required DevEssentialPageViewOnChangeCallback? onChange,
}) {
  final TickerProvider vsync = useSingleTickerProvider();
  return use(_DevEssentialPageViewHook(
    controller: controller,
    vsync: vsync,
    animationDuration: animationDuration,
    onChange: onChange,
  ));
}

class _DevEssentialPageViewHook extends Hook<_DevEssentialPageViewState> {
  const _DevEssentialPageViewHook({
    required this.controller,
    required this.vsync,
    required this.animationDuration,
    required this.onChange,
  });

  final DevEssentialPageViewController controller;
  final TickerProvider vsync;
  final Duration animationDuration;
  final DevEssentialPageViewOnChangeCallback? onChange;

  @override
  HookState<_DevEssentialPageViewState, Hook<_DevEssentialPageViewState>>
      createState() => _DevEssentialPageViewState();
}

class _DevEssentialPageViewState
    extends HookState<_DevEssentialPageViewState, _DevEssentialPageViewHook> {
  late AnimationController _animationController;
  late Tween<Offset> _animationOffset;
  int _currentPage = 0;
  int _lastReportedPage = 0;

  @override
  void initHook() {
    _currentPage = hook.controller.index;
    _lastReportedPage = _currentPage;
    _animationController = AnimationController(
      vsync: hook.vsync,
      duration: hook.animationDuration,
    );
    _animationOffset = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    );
    _animationController.addListener(_listenAnimationController);
    hook.controller.addListener(_listenPageChange);
    super.initHook();
  }

  @override
  void didUpdateHook(_DevEssentialPageViewHook oldHook) {
    if (oldHook.animationDuration != hook.animationDuration) {
      _animationController.duration = hook.animationDuration;
    }
    super.didUpdateHook(oldHook);
  }

  @override
  void dispose() {
    _animationController.removeListener(_listenAnimationController);
    _animationController.dispose();
    hook.controller.removeListener(_listenPageChange);
    super.dispose();
  }

  void _listenPageChange() {
    _lastReportedPage = _currentPage;
    _currentPage = hook.controller.index;

    if (_lastReportedPage == _currentPage) {
      return;
    }

    if (_lastReportedPage < _currentPage) {
      _animationOffset = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-1.0, 0.0),
      );
      _animationController.forward().whenComplete(
            () => _animationOffset = Tween<Offset>(
              begin: Offset.zero,
              end: Offset.zero,
            ),
          );
    } else {
      _animationOffset = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      );
      _animationController.reverse().whenComplete(
            () => _animationOffset = Tween<Offset>(
              begin: Offset.zero,
              end: Offset.zero,
            ),
          );
    }
  }

  void _listenAnimationController() {
    if (_animationController.status == AnimationStatus.completed ||
        _animationController.status == AnimationStatus.dismissed) {
      hook.onChange?.call(_currentPage);
      setState(() {});
    }
  }

  @override
  _DevEssentialPageViewState build(BuildContext context) => this;
}
