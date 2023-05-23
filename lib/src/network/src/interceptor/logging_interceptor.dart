part of '../../network.dart';

class _LoggingInterceptor extends Interceptor {
  final String? authToken;
  _LoggingInterceptor(this.authToken);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (authToken != null) {
      options.headers = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ${authToken!}',
      };
    } else {
      options.headers = {
        'Content-type': 'application/json',
      };
    }

    if (kDebugMode) {
      if (options.data != null) {
        if (options.data.runtimeType == FormData) {
          Dev.print('${options.data.fields}');
          Dev.print('${options.data.files}');
        } else {
          Dev.print(jsonEncode(options.data).toString());
        }
      }
      Dev.print('${options.headers}');
      Dev.print((options.method).toString());
      Dev.print('${options.uri}');
    }

    return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    switch (err.type) {
      case DioErrorType.cancel:
        break;
      case DioErrorType.connectionTimeout:
        break;
      case DioErrorType.unknown:
        break;
      case DioErrorType.receiveTimeout:
        break;
      case DioErrorType.badResponse:
        if (kDebugMode) {
          Dev.print(
              'From OnError interceptor method: ${err.requestOptions.method}');
          Dev.print('From OnError interceptor url: ${err.requestOptions.uri}');
          Dev.print('From OnError interceptor: ${err.error}');
          Dev.print('From OnError interceptor: ${err.response}');
        }
        return handler.resolve(err.response!);
      case DioErrorType.badCertificate:
        break;
      case DioErrorType.connectionError:
        break;
      case DioErrorType.sendTimeout:
        break;
    }
    return handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }
}
