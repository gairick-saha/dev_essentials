part of '../dropdown.dart';

Widget kDefaultUnderline = Container(
  height: 1.0,
  decoration: const BoxDecoration(
    border: Border(
      bottom: BorderSide(
        color: Color(0xFFBDBDBD),
        width: 0.0,
      ),
    ),
  ),
);

const Duration _kDropdownMenuDuration = Duration(milliseconds: 300);
const double _kMenuItemHeight = kMinInteractiveDimension;
const double _kDenseButtonHeight = 24.0;
const EdgeInsets _kMenuItemPadding = EdgeInsets.symmetric(horizontal: 16.0);
const EdgeInsetsGeometry _kAlignedButtonPadding =
    EdgeInsetsDirectional.only(start: 16.0, end: 4.0);
const EdgeInsets _kUnalignedButtonPadding = EdgeInsets.zero;

typedef MenuItemBuilder = Widget Function(BuildContext context, Widget child);

typedef OnMenuStateChangeFn = void Function(bool isOpen);

typedef SearchMatchFn<T> = bool Function(
  DevEssentialDropdownMenuItem<T> item,
  String searchValue,
);

SearchMatchFn<T> _defaultSearchMatchFn<T>() =>
    (DevEssentialDropdownMenuItem<T> item, String searchValue) =>
        item.value.toString().toLowerCase().contains(searchValue.toLowerCase());

class _DropdownMenuPainter extends CustomPainter {
  _DropdownMenuPainter({
    this.color,
    this.elevation,
    this.selectedIndex,
    required this.resize,
    required this.itemHeight,
    this.dropdownDecoration,
  })  : _painter = dropdownDecoration
                ?.copyWith(
                  color: dropdownDecoration.color ?? color,
                  boxShadow: dropdownDecoration.boxShadow ??
                      kElevationToShadow[elevation],
                )
                .createBoxPainter(() {}) ??
            BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(2.0)),
              boxShadow: kElevationToShadow[elevation],
            ).createBoxPainter(),
        super(repaint: resize);

  final Color? color;
  final int? elevation;
  final int? selectedIndex;
  final Animation<double> resize;
  final double itemHeight;
  final BoxDecoration? dropdownDecoration;

  final BoxPainter _painter;

  @override
  void paint(Canvas canvas, Size size) {
    final Tween<double> top = Tween<double>(
      begin: 0.0,
      end: 0.0,
    );

    final Tween<double> bottom = Tween<double>(
      begin: DevEssentialUtility.clampDouble(top.begin! + itemHeight,
          math.min(itemHeight, size.height), size.height),
      end: size.height,
    );

    final Rect rect = Rect.fromLTRB(
        0.0, top.evaluate(resize), size.width, bottom.evaluate(resize));

    _painter.paint(canvas, rect.topLeft, ImageConfiguration(size: rect.size));
  }

  @override
  bool shouldRepaint(_DropdownMenuPainter oldPainter) {
    return oldPainter.color != color ||
        oldPainter.elevation != elevation ||
        oldPainter.selectedIndex != selectedIndex ||
        oldPainter.dropdownDecoration != dropdownDecoration ||
        oldPainter.itemHeight != itemHeight ||
        oldPainter.resize != resize;
  }
}

class _DropdownMenuItemButton<T> extends StatefulWidget {
  const _DropdownMenuItemButton({
    super.key,
    required this.route,
    required this.textDirection,
    required this.buttonRect,
    required this.constraints,
    required this.mediaQueryPadding,
    required this.itemIndex,
    required this.enableFeedback,
  });

  final _DropdownRoute<T> route;
  final TextDirection? textDirection;
  final Rect buttonRect;
  final BoxConstraints constraints;
  final EdgeInsets mediaQueryPadding;
  final int itemIndex;
  final bool enableFeedback;

  @override
  _DropdownMenuItemButtonState<T> createState() =>
      _DropdownMenuItemButtonState<T>();
}

class _DropdownMenuItemButtonState<T>
    extends State<_DropdownMenuItemButton<T>> {
  void _handleFocusChange(bool focused) {
    final bool inTraditionalMode;
    switch (FocusManager.instance.highlightMode) {
      case FocusHighlightMode.touch:
        inTraditionalMode = false;

        break;
      case FocusHighlightMode.traditional:
        inTraditionalMode = true;
        break;
    }

    if (focused && inTraditionalMode) {
      final _MenuLimits menuLimits = widget.route.getMenuLimits(
        widget.buttonRect,
        widget.constraints.maxHeight,
        widget.mediaQueryPadding,
        widget.itemIndex,
      );
      widget.route.scrollController!.animateTo(
        menuLimits.scrollOffset,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 100),
      );
    }
  }

  void _handleOnTap() {
    final DevEssentialDropdownMenuItem<T> dropdownMenuItem =
        widget.route.items[widget.itemIndex].item!;

    dropdownMenuItem.onTap?.call();

    Navigator.pop(
      context,
      _DropdownRouteResult<T>(dropdownMenuItem.value),
    );
  }

  static const Map<ShortcutActivator, Intent> _webShortcuts =
      <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.arrowDown):
        DirectionalFocusIntent(TraversalDirection.down),
    SingleActivator(LogicalKeyboardKey.arrowUp):
        DirectionalFocusIntent(TraversalDirection.up),
  };

  DevEssentialDropdownMenuItemStyleData get menuItemStyle =>
      widget.route.menuItemStyle;

  @override
  Widget build(BuildContext context) {
    final double menuCurveEnd = widget.route.dropdownStyle.openInterval.end;

    final DevEssentialDropdownMenuItem<T> dropdownMenuItem =
        widget.route.items[widget.itemIndex].item!;
    final double unit = 0.5 / (widget.route.items.length + 1.5);
    final double start = DevEssentialUtility.clampDouble(
        menuCurveEnd + (widget.itemIndex + 1) * unit, 0.0, 1.0);
    final double end =
        DevEssentialUtility.clampDouble(start + 1.5 * unit, 0.0, 1.0);
    final CurvedAnimation opacity = CurvedAnimation(
        parent: widget.route.animation!, curve: Interval(start, end));

    Widget child = Container(
      padding: (menuItemStyle.padding ?? _kMenuItemPadding)
          .resolve(widget.textDirection),
      height: menuItemStyle.customHeights == null
          ? menuItemStyle.height
          : menuItemStyle.customHeights![widget.itemIndex],
      color: widget.route.items[widget.itemIndex].item?.backgroundColor,
      child: widget.route.items[widget.itemIndex],
    );

    if (dropdownMenuItem.enabled) {
      final bool isSelectedItem = !widget.route.isNoSelectedItem &&
          widget.itemIndex == widget.route.selectedIndex;
      child = InkWell(
        autofocus: isSelectedItem,
        enableFeedback: widget.enableFeedback,
        onTap: _handleOnTap,
        onFocusChange: _handleFocusChange,
        overlayColor: menuItemStyle.overlayColor,
        child: isSelectedItem
            ? menuItemStyle.selectedMenuItemBuilder?.call(context, child) ??
                menuItemStyle.menuItemBuilder?.call(context, child) ??
                child
            : menuItemStyle.menuItemBuilder?.call(context, child) ?? child,
      );
    }
    child = FadeTransition(opacity: opacity, child: child);
    if (kIsWeb && dropdownMenuItem.enabled) {
      child = Shortcuts(
        shortcuts: _webShortcuts,
        child: child,
      );
    }
    return child;
  }
}

class _DropdownMenu<T> extends StatefulWidget {
  const _DropdownMenu({
    super.key,
    required this.route,
    required this.textDirection,
    required this.buttonRect,
    required this.constraints,
    required this.mediaQueryPadding,
    required this.enableFeedback,
  });

  final _DropdownRoute<T> route;
  final TextDirection? textDirection;
  final Rect buttonRect;
  final BoxConstraints constraints;
  final EdgeInsets mediaQueryPadding;
  final bool enableFeedback;

  @override
  _DropdownMenuState<T> createState() => _DropdownMenuState<T>();
}

class _DropdownMenuState<T> extends State<_DropdownMenu<T>> {
  late CurvedAnimation _fadeOpacity;
  late CurvedAnimation _resize;
  late List<Widget> _children;
  late SearchMatchFn<T> _searchMatchFn;

  DevEssentialDropdownStyleData get dropdownStyle => widget.route.dropdownStyle;

  DevEssentialDropdownSearchData<T>? get searchData => widget.route.searchData;

  @override
  void initState() {
    super.initState();

    _fadeOpacity = CurvedAnimation(
      parent: widget.route.animation!,
      curve: const Interval(0.0, 0.25),
      reverseCurve: const Interval(0.75, 1.0),
    );
    _resize = CurvedAnimation(
      parent: widget.route.animation!,
      curve: dropdownStyle.openInterval,
      reverseCurve: const Threshold(0.0),
    );

    if (searchData?.searchController == null) {
      _children = <Widget>[
        for (int index = 0; index < widget.route.items.length; ++index)
          _DropdownMenuItemButton<T>(
            route: widget.route,
            textDirection: widget.textDirection,
            buttonRect: widget.buttonRect,
            constraints: widget.constraints,
            mediaQueryPadding: widget.mediaQueryPadding,
            itemIndex: index,
            enableFeedback: widget.enableFeedback,
          ),
      ];
    } else {
      _searchMatchFn = searchData?.searchMatchFn ?? _defaultSearchMatchFn();
      _children = _getSearchItems();

      searchData?.searchController?.addListener(_updateSearchItems);
    }
  }

  void _updateSearchItems() {
    _children = _getSearchItems();
    setState(() {});
  }

  List<Widget> _getSearchItems() {
    final String currentSearch = searchData!.searchController!.text;
    return <Widget>[
      for (int index = 0; index < widget.route.items.length; ++index)
        if (_searchMatchFn(widget.route.items[index].item!, currentSearch))
          _DropdownMenuItemButton<T>(
            route: widget.route,
            textDirection: widget.textDirection,
            buttonRect: widget.buttonRect,
            constraints: widget.constraints,
            mediaQueryPadding: widget.mediaQueryPadding,
            itemIndex: index,
            enableFeedback: widget.enableFeedback,
          ),
    ];
  }

  @override
  void dispose() {
    _fadeOpacity.dispose();
    _resize.dispose();
    searchData?.searchController?.removeListener(_updateSearchItems);
    super.dispose();
  }

  final _states = <MaterialState>{
    MaterialState.dragged,
    MaterialState.hovered,
  };

  bool get _isIOS => Theme.of(context).platform == TargetPlatform.iOS;

  ScrollbarThemeData? get _scrollbarTheme => dropdownStyle.scrollbarTheme;

  bool? get _iOSThumbVisibility =>
      _scrollbarTheme?.thumbVisibility?.resolve(_states);

  Widget get _materialScrollBar => Theme(
        data: Theme.of(context).copyWith(
          scrollbarTheme: dropdownStyle.scrollbarTheme,
        ),
        child: Scrollbar(
          thumbVisibility: true,
          child: ListView(
            primary: true,
            padding: dropdownStyle.padding ?? kMaterialListPadding,
            shrinkWrap: true,
            children: _children,
          ),
        ),
      );

  Widget get _cupertinoScrollBar => Theme(
        data: Theme.of(context).copyWith(
          scrollbarTheme: dropdownStyle.scrollbarTheme,
        ),
        child: Scrollbar(
          thumbVisibility: _iOSThumbVisibility ?? true,
          thickness: _scrollbarTheme?.thickness?.resolve(_states),
          radius: _scrollbarTheme?.radius,
          child: ListView(
            primary: true,
            padding: dropdownStyle.padding ?? kMaterialListPadding,
            shrinkWrap: true,
            children: _children,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final _DropdownRoute<T> route = widget.route;

    return FadeTransition(
      opacity: _fadeOpacity,
      child: CustomPaint(
        painter: _DropdownMenuPainter(
          color: Theme.of(context).canvasColor,
          elevation: dropdownStyle.elevation,
          selectedIndex: route.selectedIndex,
          resize: _resize,
          itemHeight: route.menuItemStyle.height,
          dropdownDecoration: dropdownStyle.decoration,
        ),
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          label: localizations.popupMenuLabel,
          child: ClipRRect(
            clipBehavior: dropdownStyle.decoration?.borderRadius != null
                ? Clip.antiAlias
                : Clip.none,
            borderRadius: dropdownStyle.decoration?.borderRadius
                    ?.resolve(Directionality.of(context)) ??
                BorderRadius.zero,
            child: Material(
              type: MaterialType.transparency,
              textStyle: route.style,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (searchData?.searchInnerWidget != null)
                    searchData!.searchInnerWidget!,
                  Flexible(
                    child: Padding(
                      padding: dropdownStyle.scrollPadding ?? EdgeInsets.zero,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          scrollbars: false,
                          overscroll: false,
                          physics: const ClampingScrollPhysics(),
                          platform: Theme.of(context).platform,
                        ),
                        child: PrimaryScrollController(
                          controller: route.scrollController!,
                          child:
                              _isIOS ? _cupertinoScrollBar : _materialScrollBar,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DropdownMenuRouteLayout<T> extends SingleChildLayoutDelegate {
  _DropdownMenuRouteLayout({
    required this.route,
    required this.buttonRect,
    required this.availableHeight,
    required this.mediaQueryPadding,
    required this.textDirection,
  });

  final _DropdownRoute<T> route;
  final Rect buttonRect;
  final double availableHeight;
  final EdgeInsets mediaQueryPadding;
  final TextDirection? textDirection;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final double? itemWidth = route.dropdownStyle.width;
    double maxHeight =
        route.getMenuAvailableHeight(availableHeight, mediaQueryPadding);
    final double? preferredMaxHeight = route.dropdownStyle.maxHeight;
    if (preferredMaxHeight != null && preferredMaxHeight <= maxHeight) {
      maxHeight = preferredMaxHeight;
    }

    final double width =
        math.min(constraints.maxWidth, itemWidth ?? buttonRect.width);
    return BoxConstraints(
      minWidth: width,
      maxWidth: width,
      maxHeight: maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final _MenuLimits menuLimits = route.getMenuLimits(
      buttonRect,
      availableHeight,
      mediaQueryPadding,
      route.selectedIndex,
    );

    assert(() {
      final Rect container = Offset.zero & size;
      if (container.intersect(buttonRect) == buttonRect) {
        assert(menuLimits.top >= 0.0);
        assert(menuLimits.top + menuLimits.height <= size.height);
      }
      return true;
    }());
    assert(textDirection != null);

    final Offset offset = route.dropdownStyle.offset;
    final double left;

    switch (route.dropdownStyle.direction) {
      case DropdownDirection.textDirection:
        switch (textDirection!) {
          case TextDirection.rtl:
            left = DevEssentialUtility.clampDouble(
              buttonRect.right - childSize.width + offset.dx,
              0.0,
              size.width - childSize.width,
            );
            break;
          case TextDirection.ltr:
            left = DevEssentialUtility.clampDouble(
              buttonRect.left + offset.dx,
              0.0,
              size.width - childSize.width,
            );
            break;
        }
        break;
      case DropdownDirection.right:
        left = DevEssentialUtility.clampDouble(
          buttonRect.left + offset.dx,
          0.0,
          size.width - childSize.width,
        );
        break;
      case DropdownDirection.left:
        left = DevEssentialUtility.clampDouble(
          buttonRect.right - childSize.width + offset.dx,
          0.0,
          size.width - childSize.width,
        );
        break;
    }

    return Offset(left, menuLimits.top);
  }

  @override
  bool shouldRelayout(_DropdownMenuRouteLayout<T> oldDelegate) {
    return buttonRect != oldDelegate.buttonRect ||
        textDirection != oldDelegate.textDirection;
  }
}

@immutable
class _DropdownRouteResult<T> {
  const _DropdownRouteResult(this.result);

  final T? result;

  @override
  bool operator ==(Object other) {
    return other is _DropdownRouteResult<T> && other.result == result;
  }

  @override
  int get hashCode => result.hashCode;
}

class _MenuLimits {
  const _MenuLimits(this.top, this.bottom, this.height, this.scrollOffset);

  final double top;
  final double bottom;
  final double height;
  final double scrollOffset;
}

class _DropdownRoute<T> extends PopupRoute<_DropdownRouteResult<T>> {
  _DropdownRoute({
    required this.items,
    required this.buttonRect,
    required this.selectedIndex,
    required this.isNoSelectedItem,
    required this.capturedThemes,
    required this.style,
    required this.barrierDismissible,
    this.barrierColor,
    this.barrierLabel,
    required this.enableFeedback,
    required this.dropdownStyle,
    required this.menuItemStyle,
    required this.searchData,
  }) : itemHeights = menuItemStyle.customHeights ??
            List<double>.filled(items.length, menuItemStyle.height);

  final List<_MenuItem<T>> items;
  final ValueNotifier<Rect?> buttonRect;
  final int selectedIndex;
  final bool isNoSelectedItem;
  final CapturedThemes capturedThemes;
  final TextStyle style;
  final bool enableFeedback;
  final DevEssentialDropdownStyleData dropdownStyle;
  final DevEssentialDropdownMenuItemStyleData menuItemStyle;
  final DevEssentialDropdownSearchData<T>? searchData;

  final List<double> itemHeights;
  ScrollController? scrollController;

  @override
  Duration get transitionDuration => _kDropdownMenuDuration;

  @override
  final bool barrierDismissible;

  @override
  final Color? barrierColor;

  @override
  final String? barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return LayoutBuilder(
      builder: (BuildContext ctx, BoxConstraints constraints) {
        final MediaQueryData mediaQuery = MediaQuery.of(ctx);
        final BoxConstraints actualConstraints = constraints.copyWith(
            maxHeight: constraints.maxHeight - mediaQuery.viewInsets.bottom);
        final EdgeInsets mediaQueryPadding =
            dropdownStyle.useSafeArea ? mediaQuery.padding : EdgeInsets.zero;
        return ValueListenableBuilder<Rect?>(
          valueListenable: buttonRect,
          builder: (BuildContext context, Rect? rect, _) {
            return _DropdownRoutePage<T>(
              route: this,
              constraints: actualConstraints,
              mediaQueryPadding: mediaQueryPadding,
              buttonRect: rect!,
              selectedIndex: selectedIndex,
              capturedThemes: capturedThemes,
              style: style,
              enableFeedback: enableFeedback,
            );
          },
        );
      },
    );
  }

  void _dismiss() {
    if (isActive) {
      navigator?.removeRoute(this);
    }
  }

  double getItemOffset(int index, double paddingTop) {
    double offset = paddingTop;
    if (items.isNotEmpty && index > 0) {
      assert(items.length == itemHeights.length);
      offset += itemHeights
          .sublist(0, index)
          .reduce((double total, double height) => total + height);
    }
    return offset;
  }

  _MenuLimits getMenuLimits(
    Rect buttonRect,
    double availableHeight,
    EdgeInsets mediaQueryPadding,
    int index,
  ) {
    double maxHeight =
        getMenuAvailableHeight(availableHeight, mediaQueryPadding);

    final double? preferredMaxHeight = dropdownStyle.maxHeight;
    if (preferredMaxHeight != null) {
      maxHeight = math.min(maxHeight, preferredMaxHeight);
    }

    double actualMenuHeight =
        dropdownStyle.padding?.vertical ?? kMaterialListPadding.vertical;
    final double innerWidgetHeight = searchData?.searchInnerWidgetHeight ?? 0.0;
    actualMenuHeight += innerWidgetHeight;
    if (items.isNotEmpty) {
      actualMenuHeight +=
          itemHeights.reduce((double total, double height) => total + height);
    }

    final double menuHeight = math.min(maxHeight, actualMenuHeight);

    double menuTop = dropdownStyle.isOverButton
        ? buttonRect.top - dropdownStyle.offset.dy
        : buttonRect.bottom - dropdownStyle.offset.dy;
    double menuBottom = menuTop + menuHeight;

    final double topLimit = mediaQueryPadding.top;
    final double bottomLimit = availableHeight - mediaQueryPadding.bottom;
    if (menuTop < topLimit) {
      menuTop = topLimit;
      menuBottom = menuTop + menuHeight;
    } else if (menuBottom > bottomLimit) {
      menuBottom = bottomLimit;
      menuTop = menuBottom - menuHeight;
    }

    double scrollOffset = 0;

    if (actualMenuHeight > maxHeight) {
      final double menuNetHeight = menuHeight - innerWidgetHeight;
      final double actualMenuNetHeight = actualMenuHeight - innerWidgetHeight;

      final double paddingTop = dropdownStyle.padding != null
          ? dropdownStyle.padding!.resolve(null).top
          : kMaterialListPadding.top;
      final double selectedItemOffset = getItemOffset(index, paddingTop);
      scrollOffset = math.max(
          0.0,
          selectedItemOffset -
              (menuNetHeight / 2) +
              (itemHeights[selectedIndex] / 2));

      final double maxScrollOffset = actualMenuNetHeight - menuNetHeight;
      scrollOffset = math.min(scrollOffset, maxScrollOffset);
    }

    assert((menuBottom - menuTop - menuHeight).abs() < precisionErrorTolerance);
    return _MenuLimits(menuTop, menuBottom, menuHeight, scrollOffset);
  }

  double getMenuAvailableHeight(
    double availableHeight,
    EdgeInsets mediaQueryPadding,
  ) {
    return math.max(
      0.0,
      availableHeight - mediaQueryPadding.vertical - _kMenuItemHeight,
    );
  }
}

class _DropdownRoutePage<T> extends StatelessWidget {
  const _DropdownRoutePage({
    super.key,
    required this.route,
    required this.constraints,
    required this.mediaQueryPadding,
    required this.buttonRect,
    required this.selectedIndex,
    this.elevation = 8,
    required this.capturedThemes,
    this.style,
    required this.enableFeedback,
  });

  final _DropdownRoute<T> route;
  final BoxConstraints constraints;
  final EdgeInsets mediaQueryPadding;
  final Rect buttonRect;
  final int selectedIndex;
  final int elevation;
  final CapturedThemes capturedThemes;
  final TextStyle? style;
  final bool enableFeedback;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));

    if (route.scrollController == null) {
      final _MenuLimits menuLimits = route.getMenuLimits(
        buttonRect,
        constraints.maxHeight,
        mediaQueryPadding,
        selectedIndex,
      );
      route.scrollController =
          ScrollController(initialScrollOffset: menuLimits.scrollOffset);
    }

    final TextDirection? textDirection = Directionality.maybeOf(context);
    final Widget menu = _DropdownMenu<T>(
      route: route,
      textDirection: textDirection,
      buttonRect: buttonRect,
      constraints: constraints,
      mediaQueryPadding: mediaQueryPadding,
      enableFeedback: enableFeedback,
    );

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (BuildContext context) {
          return CustomSingleChildLayout(
            delegate: _DropdownMenuRouteLayout<T>(
              route: route,
              textDirection: textDirection,
              buttonRect: buttonRect,
              availableHeight: constraints.maxHeight,
              mediaQueryPadding: mediaQueryPadding,
            ),
            child: capturedThemes.wrap(menu),
          );
        },
      ),
    );
  }
}

class _MenuItem<T> extends SingleChildRenderObjectWidget {
  const _MenuItem({
    super.key,
    required this.onLayout,
    required this.item,
  }) : super(child: item);

  final ValueChanged<Size> onLayout;
  final DevEssentialDropdownMenuItem<T>? item;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMenuItem(onLayout);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderMenuItem renderObject) {
    renderObject.onLayout = onLayout;
  }
}

class _RenderMenuItem extends RenderProxyBox {
  _RenderMenuItem(this.onLayout, [RenderBox? child]) : super(child);

  ValueChanged<Size> onLayout;

  @override
  void performLayout() {
    super.performLayout();
    onLayout(size);
  }
}

class _DropdownMenuItemContainer extends StatelessWidget {
  const _DropdownMenuItemContainer({
    Key? key,
    this.alignment = AlignmentDirectional.centerStart,
    required this.child,
    this.backgroundColor,
  }) : super(key: key);

  final Widget child;

  final AlignmentGeometry alignment;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: _kMenuItemHeight),
      alignment: alignment,
      child: child,
    );
  }
}

class DevEssentialDropdownMenuItem<T> extends _DropdownMenuItemContainer {
  const DevEssentialDropdownMenuItem({
    super.key,
    this.onTap,
    this.value,
    this.enabled = true,
    super.alignment,
    required super.child,
    super.backgroundColor,
  });

  final VoidCallback? onTap;
  final T? value;
  final bool enabled;
}

class DevEssentialDropdownButton<T> extends StatefulWidget {
  DevEssentialDropdownButton({
    super.key,
    required this.items,
    this.selectedItemBuilder,
    this.value,
    this.hint,
    this.disabledHint,
    this.onChanged,
    this.onMenuStateChange,
    this.style,
    this.underline,
    this.isDense = false,
    this.isExpanded = false,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback,
    this.alignment = AlignmentDirectional.centerStart,
    this.buttonStyleData,
    this.iconStyleData = const DevEssentialDropdownIconStyleData(),
    this.dropdownStyleData = const DevEssentialDropdownStyleData(),
    this.menuItemStyleData = const DevEssentialDropdownMenuItemStyleData(),
    this.dropdownSearchData,
    this.customButton,
    this.openWithLongPress = false,
    this.barrierDismissible = true,
    this.barrierColor,
    this.barrierLabel,
  })  : assert(
          items == null ||
              items.isEmpty ||
              value == null ||
              items.where((DevEssentialDropdownMenuItem<T> item) {
                    return item.value == value;
                  }).length ==
                  1,
          "There should be exactly one item with [DropdownButton]'s value: "
          '$value. \n'
          'Either zero or 2 or more [DropdownMenuItem]s were detected '
          'with the same value',
        ),
        assert(
          menuItemStyleData.customHeights == null ||
              items == null ||
              items.isEmpty ||
              menuItemStyleData.customHeights?.length == items.length,
          'customHeights list should have the same length of items list',
        ),
        _inputDecoration = null,
        _isEmpty = false,
        _isFocused = false;

  DevEssentialDropdownButton._formField({
    super.key,
    required this.items,
    this.selectedItemBuilder,
    this.value,
    this.hint,
    this.disabledHint,
    required this.onChanged,
    this.onMenuStateChange,
    this.style,
    this.underline,
    this.isDense = false,
    this.isExpanded = false,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback,
    this.alignment = AlignmentDirectional.centerStart,
    this.buttonStyleData,
    required this.iconStyleData,
    required this.dropdownStyleData,
    required this.menuItemStyleData,
    this.dropdownSearchData,
    this.customButton,
    this.openWithLongPress = false,
    this.barrierDismissible = true,
    this.barrierColor,
    this.barrierLabel,
    required InputDecoration inputDecoration,
    required bool isEmpty,
    required bool isFocused,
  })  : assert(
          items == null ||
              items.isEmpty ||
              value == null ||
              items.where((DevEssentialDropdownMenuItem<T> item) {
                    return item.value == value;
                  }).length ==
                  1,
          "There should be exactly one item with [DropdownButtonFormField]'s value: "
          '$value. \n'
          'Either zero or 2 or more [DropdownMenuItem]s were detected '
          'with the same value',
        ),
        assert(
          menuItemStyleData.customHeights == null ||
              items == null ||
              items.isEmpty ||
              menuItemStyleData.customHeights?.length == items.length,
          'customHeights list should have the same length of items list',
        ),
        _inputDecoration = inputDecoration,
        _isEmpty = isEmpty,
        _isFocused = isFocused;

  final List<DevEssentialDropdownMenuItem<T>>? items;

  final DropdownButtonBuilder? selectedItemBuilder;

  final T? value;

  final Widget? hint;

  final Widget? disabledHint;

  final ValueChanged<T?>? onChanged;

  final OnMenuStateChangeFn? onMenuStateChange;

  final TextStyle? style;

  final Widget? underline;

  final bool isDense;

  final bool isExpanded;

  final FocusNode? focusNode;

  final bool autofocus;

  final bool? enableFeedback;

  final AlignmentGeometry alignment;

  final DevEssentialDropdownButtonStyleData? buttonStyleData;

  final DevEssentialDropdownIconStyleData iconStyleData;

  final DevEssentialDropdownStyleData dropdownStyleData;

  final DevEssentialDropdownMenuItemStyleData menuItemStyleData;

  final DevEssentialDropdownSearchData<T>? dropdownSearchData;

  final Widget? customButton;

  final bool openWithLongPress;

  final bool barrierDismissible;

  final Color? barrierColor;

  final String? barrierLabel;

  final InputDecoration? _inputDecoration;

  final bool _isEmpty;

  final bool _isFocused;

  @override
  State<DevEssentialDropdownButton<T>> createState() =>
      DevEssentialDropdownButtonState<T>();
}

class DevEssentialDropdownButtonState<T>
    extends State<DevEssentialDropdownButton<T>> with WidgetsBindingObserver {
  int? _selectedIndex;
  _DropdownRoute<T>? _dropdownRoute;
  Orientation? _lastOrientation;
  FocusNode? _internalNode;

  DevEssentialDropdownButtonStyleData? get _buttonStyle =>
      widget.buttonStyleData;

  DevEssentialDropdownIconStyleData get _iconStyle => widget.iconStyleData;

  DevEssentialDropdownStyleData get _dropdownStyle => widget.dropdownStyleData;

  DevEssentialDropdownMenuItemStyleData get _menuItemStyle =>
      widget.menuItemStyleData;

  DevEssentialDropdownSearchData<T>? get _searchData =>
      widget.dropdownSearchData;

  FocusNode? get _focusNode => widget.focusNode ?? _internalNode;
  late Map<Type, Action<Intent>> _actionMap;

  final ValueNotifier<bool> _isMenuOpen = ValueNotifier<bool>(false);

  final ValueNotifier<Rect?> _rect = ValueNotifier<Rect?>(null);

  FocusNode _createFocusNode() {
    return FocusNode(debugLabel: '${widget.runtimeType}');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateSelectedIndex();
    if (widget.focusNode == null) {
      _internalNode ??= _createFocusNode();
    }
    _actionMap = <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<ActivateIntent>(
        onInvoke: (ActivateIntent intent) => _handleTap(),
      ),
      ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
        onInvoke: (ButtonActivateIntent intent) => _handleTap(),
      ),
    };
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _removeDropdownRoute();
    _internalNode?.dispose();
    super.dispose();
  }

  void _removeDropdownRoute() {
    _dropdownRoute?._dismiss();
    _dropdownRoute = null;
    _lastOrientation = null;
  }

  @override
  void didUpdateWidget(DevEssentialDropdownButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode == null) {
      _internalNode ??= _createFocusNode();
    }
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    if (widget.items == null ||
        widget.items!.isEmpty ||
        (widget.value == null &&
            widget.items!
                .where((DevEssentialDropdownMenuItem<T> item) =>
                    item.enabled && item.value == widget.value)
                .isEmpty)) {
      _selectedIndex = null;
      return;
    }

    assert(widget.items!
            .where((DevEssentialDropdownMenuItem<T> item) =>
                item.value == widget.value)
            .length ==
        1);
    for (int itemIndex = 0; itemIndex < widget.items!.length; itemIndex++) {
      if (widget.items![itemIndex].value == widget.value) {
        _selectedIndex = itemIndex;
        return;
      }
    }
  }

  @override
  void didChangeMetrics() {
    if (_rect.value == null) {
      return;
    }
    final Rect newRect = _getRect();

    if (_rect.value!.top == newRect.top) {
      return;
    }
    _rect.value = newRect;
  }

  TextStyle? get _textStyle =>
      widget.style ?? Theme.of(context).textTheme.titleMedium;

  Rect _getRect() {
    final TextDirection? textDirection = Directionality.maybeOf(context);
    const EdgeInsetsGeometry menuMargin = EdgeInsets.zero;
    final NavigatorState navigator =
        Navigator.of(context, rootNavigator: _dropdownStyle.useRootNavigator);

    final RenderBox itemBox = context.findRenderObject()! as RenderBox;
    final Rect itemRect = itemBox.localToGlobal(Offset.zero,
            ancestor: navigator.context.findRenderObject()) &
        itemBox.size;

    return menuMargin.resolve(textDirection).inflateRect(itemRect);
  }

  double _getMenuHorizontalPadding() {
    final double menuHorizontalPadding =
        (_menuItemStyle.padding?.horizontal ?? _kMenuItemPadding.horizontal) +
            (_dropdownStyle.padding?.horizontal ?? 0.0) +
            (_dropdownStyle.scrollPadding?.horizontal ?? 0.0);
    return menuHorizontalPadding / 2;
  }

  void _handleTap() {
    final List<_MenuItem<T>> menuItems = [
      for (int index = 0; index < widget.items!.length; index += 1)
        _MenuItem<T>(
          item: widget.items![index],
          onLayout: (Size size) {
            if (_dropdownRoute == null) {
              return;
            }

            _dropdownRoute!.itemHeights[index] = size.height;
          },
        ),
    ];

    final NavigatorState navigator =
        Navigator.of(context, rootNavigator: _dropdownStyle.useRootNavigator);
    assert(_dropdownRoute == null);
    _rect.value = _getRect();
    _dropdownRoute = _DropdownRoute<T>(
      items: menuItems,
      buttonRect: _rect,
      selectedIndex: _selectedIndex ?? 0,
      isNoSelectedItem: _selectedIndex == null,
      capturedThemes:
          InheritedTheme.capture(from: context, to: navigator.context),
      style: _textStyle!,
      barrierDismissible: widget.barrierDismissible,
      barrierColor: widget.barrierColor,
      barrierLabel: widget.barrierLabel ??
          MaterialLocalizations.of(context).modalBarrierDismissLabel,
      enableFeedback: widget.enableFeedback ?? true,
      dropdownStyle: _dropdownStyle,
      menuItemStyle: _menuItemStyle,
      searchData: _searchData,
    );

    _isMenuOpen.value = true;

    Future.delayed(const Duration(milliseconds: 20), () {
      _focusNode?.requestFocus();
    });
    navigator
        .push(_dropdownRoute!)
        .then<void>((_DropdownRouteResult<T>? newValue) {
      _removeDropdownRoute();
      _isMenuOpen.value = false;
      _focusNode?.unfocus();
      widget.onMenuStateChange?.call(false);
      if (!mounted || newValue == null) {
        return;
      }
      widget.onChanged?.call(newValue.result);
    });

    widget.onMenuStateChange?.call(true);
  }

  void callTap() => _handleTap();

  double get _denseButtonHeight {
    final double textScaleFactor = MediaQuery.textScaleFactorOf(context);
    final double fontSize = _textStyle!.fontSize ??
        Theme.of(context).textTheme.titleMedium!.fontSize!;
    final double scaledFontSize = textScaleFactor * fontSize;
    return math.max(
        scaledFontSize, math.max(_iconStyle.iconSize, _kDenseButtonHeight));
  }

  Color get _iconColor {
    if (_enabled) {
      if (_iconStyle.iconEnabledColor != null) {
        return _iconStyle.iconEnabledColor!;
      }

      switch (Theme.of(context).brightness) {
        case Brightness.light:
          return Colors.grey.shade700;
        case Brightness.dark:
          return Colors.white70;
      }
    } else {
      if (_iconStyle.iconDisabledColor != null) {
        return _iconStyle.iconDisabledColor!;
      }

      switch (Theme.of(context).brightness) {
        case Brightness.light:
          return Colors.grey.shade400;
        case Brightness.dark:
          return Colors.white10;
      }
    }
  }

  bool get _enabled =>
      widget.items != null &&
      widget.items!.isNotEmpty &&
      widget.onChanged != null;

  Orientation _getOrientation(BuildContext context) {
    Orientation? result = MediaQuery.maybeOf(context)?.orientation;
    if (result == null) {
      final Size size = View.of(context).physicalSize;
      result = size.width > size.height
          ? Orientation.landscape
          : Orientation.portrait;
    }
    return result;
  }

  BorderRadius? _getButtonBorderRadius(BuildContext context) {
    final buttonRadius = _buttonStyle?.decoration?.borderRadius;
    if (buttonRadius != null) {
      return buttonRadius.resolve(Directionality.of(context));
    }

    final inputBorder = widget._inputDecoration?.border;
    if (inputBorder?.isOutline ?? false) {
      return (inputBorder! as OutlineInputBorder).borderRadius;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));

    final Orientation newOrientation = _getOrientation(context);
    _lastOrientation ??= newOrientation;
    if (newOrientation != _lastOrientation) {
      _removeDropdownRoute();
      _lastOrientation = newOrientation;
    }

    final List<Widget> items = widget.selectedItemBuilder == null
        ? (widget.items != null ? List<Widget>.of(widget.items!) : <Widget>[])
        : List<Widget>.of(widget.selectedItemBuilder!(context));

    int? hintIndex;
    if (widget.hint != null || (!_enabled && widget.disabledHint != null)) {
      final Widget displayedHint =
          _enabled ? widget.hint! : widget.disabledHint ?? widget.hint!;

      hintIndex = items.length;
      items.add(DefaultTextStyle(
        style: _textStyle!.copyWith(color: Theme.of(context).hintColor),
        child: IgnorePointer(
          child: _DropdownMenuItemContainer(
            alignment: widget.alignment,
            child: displayedHint,
          ),
        ),
      ));
    }

    final EdgeInsetsGeometry padding = ButtonTheme.of(context).alignedDropdown
        ? _kAlignedButtonPadding
        : _kUnalignedButtonPadding;

    final Widget innerItemsWidget;
    if (items.isEmpty) {
      innerItemsWidget = const SizedBox.shrink();
    } else {
      innerItemsWidget = Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              _buttonStyle?.width == null && _dropdownStyle.width == null
                  ? _getMenuHorizontalPadding()
                  : 0.0,
        ),
        child: IndexedStack(
          index: _selectedIndex ?? hintIndex,
          alignment: widget.alignment,
          children: widget.isDense
              ? items
              : items.map((Widget item) {
                  return SizedBox(
                    height: widget.menuItemStyleData.height,
                    child: item,
                  );
                }).toList(),
        ),
      );
    }

    Widget result = DefaultTextStyle(
      style: _enabled
          ? _textStyle!
          : _textStyle!.copyWith(color: Theme.of(context).disabledColor),
      child: widget.customButton ??
          Container(
            decoration: _buttonStyle?.decoration?.copyWith(
              boxShadow: _buttonStyle!.decoration!.boxShadow ??
                  kElevationToShadow[_buttonStyle!.elevation ?? 0],
            ),
            padding: _buttonStyle?.padding ??
                padding.resolve(Directionality.of(context)),
            height: _buttonStyle?.height ??
                (widget.isDense ? _denseButtonHeight : null),
            width: _buttonStyle?.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (widget.isExpanded)
                  Expanded(child: innerItemsWidget)
                else
                  innerItemsWidget,
                IconTheme(
                  data: IconThemeData(
                    color: _iconColor,
                    size: _iconStyle.iconSize,
                  ),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _isMenuOpen,
                    builder: (BuildContext context, bool isOpen, _) {
                      return _iconStyle.openMenuIcon != null
                          ? isOpen
                              ? _iconStyle.openMenuIcon!
                              : _iconStyle.icon
                          : _iconStyle.icon;
                    },
                  ),
                ),
              ],
            ),
          ),
    );

    if (!DropdownButtonHideUnderline.at(context)) {
      final double bottom = widget.isDense ? 0.0 : 8.0;
      result = Stack(
        children: <Widget>[
          result,
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: bottom,
            child: widget.underline ?? kDefaultUnderline,
          ),
        ],
      );
    }

    final MouseCursor effectiveMouseCursor =
        MaterialStateProperty.resolveAs<MouseCursor>(
      MaterialStateMouseCursor.clickable,
      <MaterialState>{
        if (!_enabled) MaterialState.disabled,
      },
    );

    if (widget._inputDecoration != null) {
      result = InputDecorator(
        decoration: widget._inputDecoration!,
        isEmpty: widget._isEmpty,
        isFocused: widget._isFocused,
        child: result,
      );
    }

    return Semantics(
      button: true,
      child: Actions(
        actions: _actionMap,
        child: InkWell(
          mouseCursor: effectiveMouseCursor,
          onTap: _enabled && !widget.openWithLongPress ? _handleTap : null,
          onLongPress: _enabled && widget.openWithLongPress ? _handleTap : null,
          canRequestFocus: _enabled,
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          overlayColor: _buttonStyle?.overlayColor,
          enableFeedback: false,
          borderRadius: _getButtonBorderRadius(context),
          child: result,
        ),
      ),
    );
  }
}

class DevEssentialDropdownButtonFormField<T> extends FormField<T> {
  DevEssentialDropdownButtonFormField({
    super.key,
    this.dropdownButtonKey,
    required List<DevEssentialDropdownMenuItem<T>>? items,
    DropdownButtonBuilder? selectedItemBuilder,
    T? value,
    Widget? hint,
    Widget? disabledHint,
    this.onChanged,
    OnMenuStateChangeFn? onMenuStateChange,
    TextStyle? style,
    bool isDense = true,
    bool isExpanded = false,
    FocusNode? focusNode,
    bool autofocus = false,
    InputDecoration? decoration,
    super.onSaved,
    super.validator,
    AutovalidateMode? autovalidateMode,
    bool? enableFeedback,
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
    DevEssentialDropdownButtonStyleData? buttonStyleData,
    DevEssentialDropdownIconStyleData iconStyleData =
        const DevEssentialDropdownIconStyleData(),
    DevEssentialDropdownStyleData dropdownStyleData =
        const DevEssentialDropdownStyleData(),
    DevEssentialDropdownMenuItemStyleData menuItemStyleData =
        const DevEssentialDropdownMenuItemStyleData(),
    DevEssentialDropdownSearchData<T>? dropdownSearchData,
    Widget? customButton,
    bool openWithLongPress = false,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
  })  : assert(
          items == null ||
              items.isEmpty ||
              value == null ||
              items.where((DevEssentialDropdownMenuItem<T> item) {
                    return item.value == value;
                  }).length ==
                  1,
          "There should be exactly one item with [DropdownButton]'s value: "
          '$value. \n'
          'Either zero or 2 or more [DropdownMenuItem]s were detected '
          'with the same value',
        ),
        decoration = _getInputDecoration(decoration, buttonStyleData),
        super(
          initialValue: value,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          builder: (FormFieldState<T> field) {
            final _DropdownButtonFormFieldState<T> state =
                field as _DropdownButtonFormFieldState<T>;
            final InputDecoration decorationArg =
                _getInputDecoration(decoration, buttonStyleData);
            final InputDecoration effectiveDecoration =
                decorationArg.applyDefaults(
              Theme.of(field.context).inputDecorationTheme,
            );

            final bool showSelectedItem = items != null &&
                items
                    .where((DevEssentialDropdownMenuItem<T> item) =>
                        item.value == state.value)
                    .isNotEmpty;
            bool isHintOrDisabledHintAvailable() {
              final bool isDropdownDisabled =
                  onChanged == null || (items == null || items.isEmpty);
              if (isDropdownDisabled) {
                return hint != null || disabledHint != null;
              } else {
                return hint != null;
              }
            }

            final bool isEmpty =
                !showSelectedItem && !isHintOrDisabledHintAvailable();

            return Focus(
              canRequestFocus: false,
              skipTraversal: true,
              child: Builder(
                builder: (BuildContext context) {
                  return DropdownButtonHideUnderline(
                    child: DevEssentialDropdownButton<T>._formField(
                      key: dropdownButtonKey,
                      items: items,
                      selectedItemBuilder: selectedItemBuilder,
                      value: state.value,
                      hint: hint,
                      disabledHint: disabledHint,
                      onChanged: onChanged == null ? null : state.didChange,
                      onMenuStateChange: onMenuStateChange,
                      style: style,
                      isDense: isDense,
                      isExpanded: isExpanded,
                      focusNode: focusNode,
                      autofocus: autofocus,
                      enableFeedback: enableFeedback,
                      alignment: alignment,
                      buttonStyleData: buttonStyleData,
                      iconStyleData: iconStyleData,
                      dropdownStyleData: dropdownStyleData,
                      menuItemStyleData: menuItemStyleData,
                      dropdownSearchData: dropdownSearchData,
                      customButton: customButton,
                      openWithLongPress: openWithLongPress,
                      barrierDismissible: barrierDismissible,
                      barrierColor: barrierColor,
                      barrierLabel: barrierLabel,
                      inputDecoration: effectiveDecoration.copyWith(
                          errorText: field.errorText),
                      isEmpty: isEmpty,
                      isFocused: Focus.of(context).hasFocus,
                    ),
                  );
                },
              ),
            );
          },
        );

  final Key? dropdownButtonKey;

  final ValueChanged<T?>? onChanged;

  final InputDecoration decoration;

  static InputDecoration _getInputDecoration(
    InputDecoration? decoration,
    DevEssentialDropdownButtonStyleData? buttonStyleData,
  ) {
    return decoration ??
        InputDecoration(
          focusColor: buttonStyleData?.overlayColor
              ?.resolve(<MaterialState>{MaterialState.focused}),
          hoverColor: buttonStyleData?.overlayColor
              ?.resolve(<MaterialState>{MaterialState.hovered}),
        );
  }

  @override
  FormFieldState<T> createState() => _DropdownButtonFormFieldState<T>();
}

class _DropdownButtonFormFieldState<T> extends FormFieldState<T> {
  @override
  void didChange(T? value) {
    super.didChange(value);
    final DevEssentialDropdownButtonFormField<T> dropdownButtonFormField =
        widget as DevEssentialDropdownButtonFormField<T>;
    assert(dropdownButtonFormField.onChanged != null);
    dropdownButtonFormField.onChanged!(value);
  }

  @override
  void didUpdateWidget(DevEssentialDropdownButtonFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
  }
}
