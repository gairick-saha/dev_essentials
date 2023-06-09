part of '../network.dart';

class DevEssentialNetworkClient {
  DevEssentialNetworkClient({
    this.baseUrl,
    this.authToken,
    this.defaultConnectTimeout = const Duration(milliseconds: 100000),
    this.defaultReceiveTimeout = const Duration(milliseconds: 100000),
  });

  final String? baseUrl;
  final String? authToken;
  final Duration defaultConnectTimeout;
  final Duration defaultReceiveTimeout;

  Dio get _client {
    final Dio dio = Dio();
    if (baseUrl != null) {
      dio
        ..options = BaseOptions(
          baseUrl: baseUrl!,
          connectTimeout: defaultConnectTimeout,
          receiveTimeout: defaultReceiveTimeout,
          responseType: ResponseType.json,
        )
        ..httpClientAdapter
        ..interceptors.addAll([_LoggingInterceptor(authToken)]);
    }
    return dio;
  }

  Future<Map<String, dynamic>> get({
    required String url,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Response<dynamic> response = await _client.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      Map<String, dynamic> responseData = {};

      if (response.data is List || response.data is String) {
        responseData = {
          'data': response.data,
        };
      } else {
        responseData = response.data ?? {};
      }

      return responseData;
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> post({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Response<dynamic> response = await _client.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      Map<String, dynamic> responseData = {};

      if (response.data is List || response.data is String) {
        responseData = {
          'data': response.data,
        };
      } else {
        responseData = response.data ?? {};
      }

      return responseData;
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> put({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Response<dynamic> response = await _client.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      Map<String, dynamic> responseData = {};

      if (response.data is List || response.data is String) {
        responseData = {
          'data': response.data,
        };
      } else {
        responseData = response.data ?? {};
      }

      return responseData;
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> delete({
    required String url,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      Response<dynamic> response = await _client.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      Map<String, dynamic> responseData = {};

      if (response.data is List || response.data is String) {
        responseData = {
          'data': response.data,
        };
      } else {
        responseData = response.data ?? {};
      }

      return responseData;
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> multipartPost({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Response<dynamic> response = await _client.post(
        url,
        data: FormData.fromMap(data),
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      Map<String, dynamic> responseData = {};

      if (response.data is List || response.data is String) {
        responseData = {
          'data': response.data,
        };
      } else {
        responseData = response.data ?? {};
      }

      return responseData;
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> multipartPut({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Response<dynamic> response = await _client.put(
        url,
        data: FormData.fromMap(data),
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      Map<String, dynamic> responseData = {};

      if (response.data is List || response.data is String) {
        responseData = {
          'data': response.data,
        };
      } else {
        responseData = response.data ?? {};
      }

      return responseData;
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> download(
    String url,
    String savePath, {
    void Function(int, int)? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    dynamic data,
    Options? options,
  }) async {
    final Response response = await _client.download(
      url,
      savePath,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      deleteOnError: deleteOnError,
      lengthHeader: lengthHeader,
      data: data,
      options: options,
    );

    if (response.statusCode == 200) {
      return savePath;
    } else {
      throw Exception('Unable to download the file');
    }
  }
}
