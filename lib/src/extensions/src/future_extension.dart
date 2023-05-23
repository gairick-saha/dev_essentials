part of '../extensions.dart';

extension FutureExtension on Future {
  Widget toWidget<T>({
    required Widget Function(T data) onSuccess,
    bool showLoadingIndicator = true,
    Widget? onError,
    Widget? defaultWidget,
    dynamic initialData,
  }) {
    return FutureBuilder<dynamic>(
      future: this,
      initialData: initialData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return showLoadingIndicator
                ? const Center(
                    child: LoadingIndictor(),
                  )
                : const SizedBox.shrink();
          case ConnectionState.active:
            return const SizedBox.shrink();
          case ConnectionState.done:
            if (snapshot.hasData) {
              return onSuccess(snapshot.data);
            } else {
              return onError ?? const SizedBox.shrink();
            }
          default:
            return defaultWidget ?? const SizedBox.shrink();
        }
      },
    );
  }
}
