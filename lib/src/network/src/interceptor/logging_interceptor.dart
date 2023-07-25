part of '../../network.dart';

class _LoggingInterceptor extends Interceptor {
  _LoggingInterceptor({
    this.tokenInstance,
    this.onTokenExpired,
  });

  final DevEssentialNetworkToken? tokenInstance;
  final OnTokenExpiredCallback? onTokenExpired;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (tokenInstance != null) {
      if (tokenInstance!.isAccessTokenExpired && onTokenExpired != null) {
        Dev.print('Expired token refreshing...');
        options.headers = {
          ...options.headers,
          'Content-type': 'application/json',
          'Authorization':
              (await onTokenExpired?.call(tokenInstance!))?.token ??
                  tokenInstance!.token,
        };
      } else {
        options.headers = {
          ...options.headers,
          'Content-type': 'application/json',
          'Authorization': tokenInstance!.token,
        };
      }
    } else {
      options.headers = {
        ...options.headers,
        'Content-type': 'application/json',
      };
    }

    if (kDebugMode) {
      Dev.print('Method => ${(options.method).toString()}');
      Dev.print('URL => ${options.uri}');
      Dev.print('Headers => ${options.headers}');

      if (options.data != null) {
        if (options.data.runtimeType == FormData) {
          Dev.print(
              'FormData fields => ${jsonEncode(options.data.fields).toString()}');
          Dev.print('FormData files => ${options.data.files}');
        } else {
          Dev.print('Data => ${jsonEncode(options.data).toString()}');
        }
      }
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
        if (kDebugMode) {
          Dev.print(
              'From OnError interceptor headers => ${err.requestOptions.headers}');
          Dev.print(
              'From OnError interceptor method => ${err.requestOptions.method}');
          Dev.print(
              'From OnError interceptor url => ${err.requestOptions.uri}');
          Dev.print('From OnError interceptor error => ${err.error}');
          Dev.print(
              'From OnError interceptor error response => ${err.response}');
        }
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
