part of '../../widgets.dart';

class ScrollableScaffoldWrapper extends StatelessWidget {
  const ScrollableScaffoldWrapper({
    Key? key,
    this.scaffoldKey,
    this.appBar,
    this.slivers,
    this.floatingActionButtonLocation,
    this.floatingActionButton,
    this.onRefresh,
    this.scrollController,
    this.color,
    this.bottomBar,
    this.extendBodyBehindAppBar = false,
    this.onWillPop,
    this.physics,
    this.bottomBarcolor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.notchMargin = 4.0,
    this.shrinkWrap = false,
    this.isLoading = false,
    this.reverse = false,
    this.child,
    this.drawer,
    this.endDrawer,
    this.onDrawerChanged,
    this.onEndDrawerChanged,
  }) : super(key: key);

  final GlobalKey<ScaffoldState>? scaffoldKey;
  final PreferredSizeWidget? appBar;
  final List<Widget>? slivers;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? floatingActionButton;
  final Future<void> Function()? onRefresh;
  final ScrollController? scrollController;
  final Color? color;
  final Widget? bottomBar;
  final bool extendBodyBehindAppBar;
  final Future<bool> Function()? onWillPop;
  final ScrollPhysics? physics;
  final bool isLoading;
  final Color? bottomBarcolor;
  final double? elevation;
  final NotchedShape? shape;
  final Clip? clipBehavior;
  final double notchMargin;
  final bool shrinkWrap;
  final bool reverse;
  final Widget? child;
  final Widget? drawer;
  final Widget? endDrawer;
  final ValueChanged<bool>? onDrawerChanged;
  final ValueChanged<bool>? onEndDrawerChanged;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop ?? () async => true,
      child: KeyboardDismisser(
        gestures: const [
          GestureType.onTap,
          GestureType.onPanUpdateDownDirection,
        ],
        child: Scaffold(
          key: scaffoldKey,
          extendBodyBehindAppBar: extendBodyBehindAppBar,
          backgroundColor: color,
          appBar: appBar,
          floatingActionButtonLocation: floatingActionButtonLocation,
          floatingActionButton: floatingActionButton,
          drawer: drawer,
          endDrawer: endDrawer,
          onDrawerChanged: onDrawerChanged,
          onEndDrawerChanged: onEndDrawerChanged,
          bottomNavigationBar: bottomBar == null
              ? null
              : BottomAppBar(
                  color: bottomBarcolor ?? Colors.transparent,
                  elevation: elevation ?? 0,
                  shape: shape,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  notchMargin: notchMargin,
                  child: bottomBar,
                ),
          body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: isLoading
                ? const Center(
                    child: LoadingIndictor(),
                  )
                : child != null
                    ? SingleChildScrollView(
                        physics: physics,
                        reverse: reverse,
                        child: child,
                      )
                    : _BuildBody(
                        childrens: slivers ?? [],
                        onRefresh: onRefresh,
                        scrollController: scrollController,
                        shrinkWrap: shrinkWrap,
                        hasAppbar: appBar == null,
                        physics: physics,
                        reverse: reverse,
                      ),
          ),
        ),
      ),
    );
  }
}
