part of '../../widgets.dart';

class DevEssentialPageView extends HookWidget {
  DevEssentialPageView({
    Key? key,
    DevEssentialPageViewController? controller,
    required this.children,
    this.onChange,
  })  : _controller = controller ?? DevEssentialPageViewController(),
        super(key: key);

  final DevEssentialPageViewController _controller;
  final List<Widget> children;
  final DevEssentialPageViewOnChangeCallback? onChange;

  @override
  Widget build(BuildContext context) {
    _DevEssentialPageViewState pageViewState = _usePageViewStateHook(
      controller: _controller,
      onChange: onChange,
    );

    return IndexedStack(
      index: pageViewState._lastReportedPage,
      children: children,
    );
  }
}
