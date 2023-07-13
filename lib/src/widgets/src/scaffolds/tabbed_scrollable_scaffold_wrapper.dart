part of '../../widgets.dart';

// class ScrollTabBarConfiguration {
//   final Key? key;
//   final Widget? leading;
//   final bool automaticallyImplyLeading;
//   final Widget? title;
//   final List<Widget>? actions;
//   final Widget? flexibleSpace;
//   final Color? tabBackgroundColor;
//   final Color? labelColor;
//   final Color? unselectedLabelColor;
//   final Color? selectedLabelColor;
//   final Color? indicatorColor;
//   final double indicatorWeight;
//   final EdgeInsetsGeometry indicatorPadding;
//   final TabBarIndicatorSize indicatorSize;
//   final double tabElevation;
//   final double? elevation;
//   final Color? shadowColor;
//   final Color? backgroundColor;
//   final Color? foregroundColor;
//   final IconThemeData? iconTheme;
//   final IconThemeData? actionsIconTheme;
//   final bool primary = true;
//   final bool? centerTitle;
//   final bool excludeHeaderSemantics = false;
//   final double? titleSpacing;
//   final double? collapsedHeight;
//   final double? expandedHeight;
//   final bool floating = true;
//   final bool pinned = true;
//   final bool snap = true;
//   final bool stretch = false;
//   final double stretchTriggerOffset = 100.0;
//   final Future<void> Function()? onStretchTrigger;
//   final ShapeBorder? shape;
//   final double toolbarHeight;
//   final double? leadingWidth;
//   final TextStyle? toolbarTextStyle;
//   final TextStyle? titleTextStyle;
//   final SystemUiOverlayStyle? systemOverlayStyle;
//   final PreferredSizeWidget Function(
//     TabController tabController,
//     List<Widget> tabs,
//     ScrollTabBarConfiguration configuration,
//   )? tabBarBuilder;

//   const ScrollTabBarConfiguration({
//     this.key,
//     this.leading,
//     this.title,
//     this.actions,
//     this.flexibleSpace,
//     this.tabBackgroundColor,
//     this.labelColor,
//     this.unselectedLabelColor,
//     this.selectedLabelColor,
//     this.indicatorColor,
//     this.indicatorWeight = 4,
//     this.indicatorPadding = const EdgeInsets.only(left: 32.0, right: 32.0),
//     this.indicatorSize = TabBarIndicatorSize.tab,
//     this.tabElevation = 0,
//     this.elevation,
//     this.shadowColor,
//     this.backgroundColor,
//     this.foregroundColor,
//     this.iconTheme,
//     this.actionsIconTheme,
//     this.centerTitle,
//     this.titleSpacing,
//     this.collapsedHeight,
//     this.expandedHeight,
//     this.onStretchTrigger,
//     this.shape,
//     this.leadingWidth,
//     this.toolbarTextStyle,
//     this.titleTextStyle,
//     this.systemOverlayStyle,
//     this.automaticallyImplyLeading = true,
//     this.tabBarBuilder,
//     this.toolbarHeight = kToolbarHeight,
//   });
// }

// class ScrollTabViewBuilder extends StatelessWidget {
//   final Widget? child;
//   final List<Widget> slivers;
//   final bool shrinkWrap;
//   final bool allowPagination;
//   final Future<void> Function()? onPaginate;
//   final ScrollController? scrollController;
//   final ScrollPhysics? physics;
//   final Future<void> Function()? onRefresh;
//   final bool isLoading;
//   final double? materialLoadingValue;
//   final Color? materialLoadingBackgroundColor;
//   final Color? loadingColor;
//   final Animation<Color?>? materialLoadingValueColor;
//   final double materialLoadingStrokeWidth;
//   final String? materialLoadingSemanticsLabel;
//   final String? materialLoadingSemanticsValue;
//   final bool isCupertionAnimating;
//   final double cupertionLoadingRadius;
//   final bool reverse;

//   const ScrollTabViewBuilder({
//     Key? key,
//     this.child,
//     this.slivers = const [],
//     this.onRefresh,
//     this.shrinkWrap = false,
//     this.allowPagination = false,
//     this.onPaginate,
//     this.physics,
//     this.scrollController,
//     this.isLoading = false,
//     this.materialLoadingValue,
//     this.materialLoadingBackgroundColor,
//     this.loadingColor,
//     this.materialLoadingValueColor,
//     this.materialLoadingStrokeWidth = 4.0,
//     this.materialLoadingSemanticsLabel,
//     this.materialLoadingSemanticsValue,
//     this.isCupertionAnimating = true,
//     this.cupertionLoadingRadius = 10.0,
//     this.reverse = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return _BuildBody(
//       key: PageStorageKey(UniqueKey()),
//       childrens: [
//         SliverOverlapInjector(
//           handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
//         ),
//         if (child == null)
//           ...slivers
//         else
//           SliverToBoxAdapter(
//             child: SizedBox(
//               height: Dev.height,
//               width: Dev.width,
//               child: child,
//             ),
//           ),
//       ],
//       onRefresh: onRefresh,
//       scrollController: scrollController,
//       shrinkWrap: shrinkWrap,
//       physics: physics,
//       hasAppbar: false,
//       reverse: reverse,
//     );
//   }
// }

// class TabbedScaffold {
//   const TabbedScaffold({
//     required this.tabButton,
//     required this.tabView,
//   });

//   final Tab tabButton;
//   final ScrollTabViewBuilder tabView;
// }

// class TabbedScrollableScaffoldWrapper extends HookWidget {
//   const TabbedScrollableScaffoldWrapper({
//     Key? key,
//     this.scaffoldKey,
//     this.tabBarConfiguration = const ScrollTabBarConfiguration(),
//     this.floatingActionButtonLocation,
//     this.floatingActionButton,
//     this.onRefresh,
//     this.scrollController,
//     this.color,
//     this.bottomBar,
//     this.extendBodyBehindAppBar = false,
//     this.onWillPop,
//     this.physics,
//     this.bottomBarcolor,
//     this.elevation,
//     this.shape,
//     this.clipBehavior,
//     this.notchMargin = 4.0,
//     this.shrinkWrap = false,
//     this.isLoading = false,
//     this.onTabChanged,
//     this.reverse = false,
//     this.drawer,
//     this.endDrawer,
//     this.onDrawerChanged,
//     this.onEndDrawerChanged,
//     required this.tabs,
//   }) : super(key: key);

//   final GlobalKey<ScaffoldState>? scaffoldKey;
//   final FloatingActionButtonLocation? floatingActionButtonLocation;
//   final Widget? floatingActionButton;
//   final Future<void> Function()? onRefresh;
//   final ScrollController? scrollController;
//   final Color? color;
//   final Widget? bottomBar;
//   final bool extendBodyBehindAppBar;
//   final Future<bool> Function()? onWillPop;
//   final ScrollPhysics? physics;
//   final bool isLoading;
//   final Color? bottomBarcolor;
//   final double? elevation;
//   final NotchedShape? shape;
//   final Clip? clipBehavior;
//   final double notchMargin;
//   final bool shrinkWrap;
//   final ValueChanged<int>? onTabChanged;
//   final bool reverse;
//   final Widget? drawer;
//   final Widget? endDrawer;
//   final ValueChanged<bool>? onDrawerChanged;
//   final ValueChanged<bool>? onEndDrawerChanged;
//   final ScrollTabBarConfiguration tabBarConfiguration;
//   final List<TabbedScaffold> tabs;

//   @override
//   Widget build(BuildContext context) {
//     final TabController tabController =
//         useTabController(initialLength: tabs.map((e) => e.tabButton).length);

//     tabController.addListener(() {
//       if (onTabChanged != null &&
//           tabController.previousIndex != tabController.index) {
//         onTabChanged!(tabController.index);
//       }
//     });

//     return WillPopScope(
//       onWillPop: onWillPop ?? () async => true,
//       child: KeyboardDismisser(
//         gestures: const [
//           GestureType.onTap,
//           GestureType.onPanUpdateDownDirection,
//         ],
//         child: Scaffold(
//           key: scaffoldKey,
//           extendBodyBehindAppBar: extendBodyBehindAppBar,
//           backgroundColor: color,
//           floatingActionButtonLocation: floatingActionButtonLocation,
//           floatingActionButton: floatingActionButton,
//           drawer: drawer,
//           endDrawer: endDrawer,
//           onDrawerChanged: onDrawerChanged,
//           onEndDrawerChanged: onEndDrawerChanged,
//           bottomNavigationBar: bottomBar == null
//               ? null
//               : BottomAppBar(
//                   color: bottomBarcolor ?? Colors.transparent,
//                   elevation: elevation ?? 0,
//                   shape: shape,
//                   clipBehavior: Clip.antiAliasWithSaveLayer,
//                   notchMargin: notchMargin,
//                   child: bottomBar,
//                 ),
//           body: SafeArea(
//             child: NotificationListener<OverscrollIndicatorNotification>(
//               onNotification: (overscroll) {
//                 overscroll.disallowIndicator();
//                 return true;
//               },
//               child: isLoading
//                   ? const Center(
//                       child: LoadingIndictor(),
//                     )
//                   : NestedScrollView(
//                       scrollBehavior: const DevEssentialCustomScrollBehavior(),
//                       key: key,
//                       controller: scrollController,
//                       physics: physics,
//                       reverse: reverse,
//                       headerSliverBuilder:
//                           (BuildContext context, bool isInnerBoxScrolled) {
//                         return <Widget>[
//                           SliverOverlapAbsorber(
//                             handle:
//                                 NestedScrollView.sliverOverlapAbsorberHandleFor(
//                                     context),
//                             sliver: _buildAppBar(
//                               context,
//                               tabController,
//                               isInnerBoxScrolled,
//                               tabBarConfiguration.tabBarBuilder,
//                             ),
//                           ),
//                         ];
//                       },
//                       body: TabBarView(
//                         controller: tabController,
//                         children: tabs.map((e) => e.tabView).toList(),
//                       ),
//                     ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAppBar(
//     BuildContext context,
//     TabController tabController,
//     bool isInnerBoxScrolled,
//     final PreferredSizeWidget Function(
//       TabController tabController,
//       List<Widget> tabs,
//       ScrollTabBarConfiguration configuration,
//     )? tabBarBuilder,
//   ) {
//     final List<Widget> allTabs = tabs.map((e) => e.tabButton).toList();
//     return SliverAppBar(
//       key: tabBarConfiguration.key,
//       actions: tabBarConfiguration.actions,
//       actionsIconTheme: tabBarConfiguration.actionsIconTheme,
//       automaticallyImplyLeading: tabBarConfiguration.automaticallyImplyLeading,
//       backgroundColor: tabBarConfiguration.backgroundColor,
//       centerTitle: tabBarConfiguration.centerTitle,
//       collapsedHeight: tabBarConfiguration.collapsedHeight,
//       elevation: tabBarConfiguration.elevation,
//       excludeHeaderSemantics: tabBarConfiguration.excludeHeaderSemantics,
//       expandedHeight: tabBarConfiguration.expandedHeight,
//       flexibleSpace: tabBarConfiguration.flexibleSpace,
//       floating: tabBarConfiguration.floating,
//       forceElevated: isInnerBoxScrolled,
//       foregroundColor: tabBarConfiguration.foregroundColor,
//       iconTheme: tabBarConfiguration.iconTheme,
//       leading: tabBarConfiguration.leading,
//       leadingWidth: tabBarConfiguration.leadingWidth,
//       onStretchTrigger: tabBarConfiguration.onStretchTrigger,
//       pinned: tabBarConfiguration.pinned,
//       primary: tabBarConfiguration.primary,
//       shadowColor: tabBarConfiguration.shadowColor,
//       shape: tabBarConfiguration.shape,
//       snap: tabBarConfiguration.snap,
//       stretch: tabBarConfiguration.stretch,
//       stretchTriggerOffset: tabBarConfiguration.stretchTriggerOffset,
//       systemOverlayStyle: tabBarConfiguration.systemOverlayStyle,
//       title: tabBarConfiguration.title,
//       titleSpacing: tabBarConfiguration.titleSpacing,
//       titleTextStyle: tabBarConfiguration.titleTextStyle,
//       toolbarHeight: tabBarConfiguration.toolbarHeight,
//       toolbarTextStyle: tabBarConfiguration.toolbarTextStyle,
//       bottom: tabBarBuilder == null
//           ? _TabBar(
//               controller: tabController,
//               tabs: allTabs,
//               backgroundColor: tabBarConfiguration.tabBackgroundColor,
//               labelColor: tabBarConfiguration.labelColor,
//               indicatorColor: tabBarConfiguration.indicatorColor,
//               indicatorWeight: tabBarConfiguration.indicatorWeight,
//               unselectedLabelColor: tabBarConfiguration.unselectedLabelColor,
//               selectedLabelColor: tabBarConfiguration.selectedLabelColor,
//               indicatorPadding: tabBarConfiguration.indicatorPadding,
//               indicatorSize: tabBarConfiguration.indicatorSize,
//               tabElevation: tabBarConfiguration.tabElevation,
//             )
//           : tabBarBuilder(tabController, allTabs, tabBarConfiguration),
//     );
//   }
// }

// class _TabBar extends StatelessWidget implements PreferredSizeWidget {
//   final List<Widget> tabs;
//   final Color? backgroundColor;
//   final Color? labelColor;
//   final Color? unselectedLabelColor;
//   final Color? selectedLabelColor;
//   final Color? indicatorColor;
//   final double indicatorWeight;
//   final EdgeInsetsGeometry indicatorPadding;
//   final TabBarIndicatorSize indicatorSize;
//   final double tabElevation;
//   final TabController? controller;

//   const _TabBar({
//     Key? key,
//     required this.tabs,
//     required this.backgroundColor,
//     required this.labelColor,
//     required this.unselectedLabelColor,
//     required this.selectedLabelColor,
//     required this.indicatorColor,
//     required this.indicatorWeight,
//     required this.indicatorPadding,
//     required this.indicatorSize,
//     required this.tabElevation,
//     this.controller,
//   }) : super(key: key);

//   @override
//   Size get preferredSize {
//     double maxHeight = kMinInteractiveDimension;
//     for (final Widget item in tabs) {
//       if (item is PreferredSizeWidget) {
//         final double itemHeight = item.preferredSize.height;
//         maxHeight = math.max(itemHeight, maxHeight);
//       }
//     }
//     return Size.fromHeight(maxHeight);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       elevation: tabElevation,
//       color: backgroundColor,
//       child: TabBar(
//         controller: controller,
//         labelStyle: Dev.theme.tabBarTheme.labelStyle?.copyWith(
//           color: labelColor,
//         ),
//         indicatorColor: indicatorColor,
//         indicatorWeight: indicatorWeight,
//         unselectedLabelColor: unselectedLabelColor,
//         labelColor: selectedLabelColor,
//         indicatorSize: indicatorSize,
//         indicatorPadding: indicatorPadding,
//         tabs: tabs,
//       ),
//     );
//   }
// }
