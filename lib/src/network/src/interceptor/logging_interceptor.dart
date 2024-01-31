part of '../../network.dart';

class _LoggingInterceptor extends Interceptor {
  _LoggingInterceptor({
    this.tokenInstance,
    this.onTokenExpired,
    this.globalHeaders,
  });

  final DevEssentialNetworkToken? tokenInstance;
  final OnTokenExpiredCallback? onTokenExpired;
  final Map<String, dynamic>? globalHeaders;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final defaultHeaders = {
      ...options.headers,
      if (globalHeaders != null) ...globalHeaders!,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    if (tokenInstance != null) {
      if (onTokenExpired != null) {
        Dev.print('Token expired => ${tokenInstance!.isAccessTokenExpired}');
        if (tokenInstance!.isAccessTokenExpired) {
          Dev.print('Refreshing expired token...');
          defaultHeaders['Authorization'] = await onTokenExpired
              ?.call(tokenInstance!)
              .then((DevEssentialNetworkToken? updatedToken) =>
                  updatedToken?.token ?? tokenInstance!.token);
        } else {
          defaultHeaders['Authorization'] = tokenInstance!.token;
        }
      } else {
        defaultHeaders['Authorization'] = tokenInstance!.token;
      }
    }

    options.headers = defaultHeaders;

    if (kDebugMode) {
      if (options.data != null) {
        if (options.data.runtimeType == FormData) {
          Dev.print('FormData fields => ${options.data.fields}');
          Dev.print('FormData files => ${options.data.files}');
        } else {
          Dev.print('Data => ${jsonEncode(options.data).toString()}');
        }
      }

      Dev.print('URL => ${options.uri}');
      Dev.print('Headers => ${options.headers}');
      Dev.print('Method => ${options.method.toString()}');
    } else if (options.data.runtimeType == FormData) {
      options.headers = {
        'Authorization': tokenInstance!.token,
      };
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    switch (err.type) {
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.connectionTimeout:
        break;
      case DioExceptionType.unknown:
        break;
      case DioExceptionType.receiveTimeout:
        break;
      case DioExceptionType.badResponse:
        // if (kDebugMode) {
        //   Dev.print(
        //       'From OnError interceptor headers => ${err.requestOptions.headers}');
        //   Dev.print(
        //       'From OnError interceptor method => ${err.requestOptions.method}');
        //   Dev.print(
        //       'From OnError interceptor url => ${err.requestOptions.uri}');
        //   Dev.print('From OnError interceptor error => ${err.error}');
        //   Dev.print(
        //       'From OnError interceptor error response => ${err.response}');
        // }
        return handler.resolve(err.response!);
      case DioExceptionType.badCertificate:
        break;
      case DioExceptionType.connectionError:
        break;
      case DioExceptionType.sendTimeout:
        break;
    }
    return handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }
}
