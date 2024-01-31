part of '../extensions.dart';

extension DialogExtension on DevEssential {
  Future<T?> dialog<T>(
    WidgetBuilder widget, {
    bool barrierDismissible = true,
    Color? barrierColor,
    bool useSafeArea = true,
    GlobalKey<NavigatorState>? navigatorKey,
    Object? arguments,
    Duration? transitionDuration,
    Curve? transitionCurve,
    String? name,
    RouteSettings? routeSettings,
    String? id,
  }) {
    assert(debugCheckHasMaterialLocalizations(context));

    final theme = Theme.of(context);
    return generalDialog<T>(
      pageBuilder: (context, animation, secondaryAnimation) {
        Widget dialog = Builder(builder: (context) {
          return Theme(data: theme, child: widget.call(context));
        });
        if (useSafeArea) {
          dialog = SafeArea(child: dialog);
        }
        return dialog;
      },
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: barrierColor ?? Colors.black54,
      transitionDuration: transitionDuration ?? defaultDialogTransitionDuration,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: transitionCurve ?? defaultDialogTransitionCurve,
          ),
          child: child,
        );
      },
      navigatorKey: navigatorKey,
      routeSettings:
          routeSettings ?? RouteSettings(arguments: arguments, name: name),
      id: id,
    );
  }

  Future<T?> generalDialog<T>(
      {required RoutePageBuilder pageBuilder,
      bool barrierDismissible = false,
      String? barrierLabel,
      Color barrierColor = const Color(0x80000000),
      Duration transitionDuration = const Duration(milliseconds: 200),
      RouteTransitionsBuilder? transitionBuilder,
      GlobalKey<NavigatorState>? navigatorKey,
      RouteSettings? routeSettings,
      String? id}) {
    assert(!barrierDismissible || barrierLabel != null);
    final key = navigatorKey ?? Dev.nestedKey(id)?.navigatorKey;
    final nav =
        key?.currentState ?? Navigator.of(overlayContext!, rootNavigator: true);
    return nav.push<T>(
      DevEssentialDialogRoute<T>(
        pageBuilder: pageBuilder,
        barrierDismissible: barrierDismissible,
        barrierLabel: barrierLabel,
        barrierColor: barrierColor,
        transitionDuration: transitionDuration,
        transitionBuilder: transitionBuilder,
        settings: routeSettings,
      ),
    );
  }

  Future<T?> defaultDialog<T>({
    String title = "Alert",
    EdgeInsetsGeometry? titlePadding,
    TextStyle? titleStyle,
    Widget? content,
    String? id,
    EdgeInsetsGeometry? contentPadding,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    VoidCallback? onCustom,
    Color? cancelTextColor,
    Color? confirmTextColor,
    String? textConfirm,
    String? textCancel,
    String? textCustom,
    Widget? confirm,
    Widget? cancel,
    Widget? custom,
    Color? backgroundColor,
    bool barrierDismissible = true,
    Color? buttonColor,
    String middleText = "\n",
    TextStyle? middleTextStyle,
    double radius = 20.0,
    List<Widget>? actions,
    bool canPop = true,
    PopInvokedCallback? onPopInvoked,
    GlobalKey<NavigatorState>? navigatorKey,
  }) {
    var leanCancel = onCancel != null || textCancel != null;
    var leanConfirm = onConfirm != null || textConfirm != null;
    actions ??= [];

    if (cancel != null) {
      actions.add(cancel);
    } else {
      if (leanCancel) {
        actions.add(TextButton(
          style: TextButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: buttonColor ?? theme.colorScheme.secondary,
                    width: 2,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(radius)),
          ),
          onPressed: () {
            onCancel?.call();
            back();
          },
          child: Text(
            textCancel ?? "Cancel",
            style: TextStyle(
                color: cancelTextColor ?? theme.colorScheme.secondary),
          ),
        ));
      }
    }
    if (confirm != null) {
      actions.add(confirm);
    } else {
      if (leanConfirm) {
        actions.add(TextButton(
            style: TextButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: buttonColor ?? theme.colorScheme.secondary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius)),
            ),
            child: Text(
              textConfirm ?? "Ok",
              style: TextStyle(
                  color: confirmTextColor ?? theme.colorScheme.background),
            ),
            onPressed: () {
              onConfirm?.call();
            }));
      }
    }

    Widget baseAlertDialog = AlertDialog(
      titlePadding: titlePadding ?? const EdgeInsets.all(8),
      contentPadding: contentPadding ?? const EdgeInsets.all(8),
      backgroundColor: backgroundColor ?? theme.dialogBackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius))),
      title: Text(title, textAlign: TextAlign.center, style: titleStyle),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          content ??
              Text(middleText,
                  textAlign: TextAlign.center, style: middleTextStyle),
          const SizedBox(height: 16),
          ButtonTheme(
            minWidth: 78.0,
            height: 34.0,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: actions,
            ),
          )
        ],
      ),
      buttonPadding: EdgeInsets.zero,
    );

    return dialog<T>(
      (context) => PopScope(
        canPop: canPop,
        onPopInvoked: onPopInvoked,
        child: baseAlertDialog,
      ),
      barrierDismissible: barrierDismissible,
      navigatorKey: navigatorKey,
      id: id,
    );
  }
}
