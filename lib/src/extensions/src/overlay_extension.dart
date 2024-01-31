part of '../extensions.dart';

extension OverlayExt on DevEssential {
  Future<T> showOverlay<T>({
    required Future<T> Function() asyncFunction,
    Color opacityColor = Colors.black,
    Widget? loadingWidget,
    double opacity = .5,
    GlobalKey<NavigatorState>? navigatorKey,
  }) async {
    final navigatorState = navigatorKey?.currentState ??
        Navigator.of(Dev.overlayContext!, rootNavigator: false);

    final overlayState = navigatorState.overlay!;

    final overlayEntryOpacity = OverlayEntry(
      builder: (context) {
        return Opacity(
          opacity: opacity,
          child: Container(
            color: opacityColor,
          ),
        );
      },
    );
    final overlayEntryLoader = OverlayEntry(
      builder: (context) {
        return loadingWidget ??
            Center(
              child: Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox.square(
                      dimension: 40.0, child: LoadingIndictor()),
                ),
              ),
            );
      },
    );
    overlayState.insert(overlayEntryOpacity);
    overlayState.insert(overlayEntryLoader);

    T data;

    try {
      data = await asyncFunction();
      overlayEntryLoader.remove();
      overlayEntryOpacity.remove();
      return data;
    } on Exception catch (_) {
      overlayEntryLoader.remove();
      overlayEntryOpacity.remove();
      rethrow;
    }
  }
}
