part of '../../widgets.dart';

typedef DevEssentialPageViewOnChangeCallback = void Function(int index);

_DevEssentialPageViewState _usePageViewStateHook({
  required DevEssentialPageViewController controller,
  required DevEssentialPageViewOnChangeCallback? onChange,
}) =>
    use(_DevEssentialPageViewHook(controller: controller));

class _DevEssentialPageViewHook extends Hook<_DevEssentialPageViewState> {
  const _DevEssentialPageViewHook({
    required this.controller,
  });

  final DevEssentialPageViewController controller;

  @override
  HookState<_DevEssentialPageViewState, Hook<_DevEssentialPageViewState>>
      createState() => _DevEssentialPageViewState();
}

class _DevEssentialPageViewState
    extends HookState<_DevEssentialPageViewState, _DevEssentialPageViewHook> {
  int _lastReportedPage = 0;

  @override
  void initHook() {
    _lastReportedPage = hook.controller.index;
    super.initHook();
  }

  @override
  _DevEssentialPageViewState build(BuildContext context) => this;
}
