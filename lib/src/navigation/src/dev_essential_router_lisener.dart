part of '../navigation.dart';

mixin DevEssentialRouterListenerMixin<T extends StatefulWidget> on State<T> {
  RouterDelegate? delegate;

  void _listener() {
    setState(() {});
  }

  VoidCallback? disposer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    disposer?.call();
    final router = Router.of(context);
    delegate ??= router.routerDelegate as DevEssentialRouterDelegate;

    delegate?.addListener(_listener);
    disposer = () => delegate?.removeListener(_listener);
  }

  @override
  void dispose() {
    super.dispose();
    disposer?.call();
  }
}

class DevEssentialRouterListener extends StatefulWidget {
  const DevEssentialRouterListener({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final WidgetBuilder builder;

  @override
  State<DevEssentialRouterListener> createState() => RouteListenerState();
}

class RouteListenerState extends State<DevEssentialRouterListener>
    with DevEssentialRouterListenerMixin {
  @override
  Widget build(BuildContext context) => Builder(builder: widget.builder);
}
