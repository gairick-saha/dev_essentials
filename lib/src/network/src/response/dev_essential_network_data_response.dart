part of '../../network.dart';

class DevEssentialNetworkDataRespone {
  DevEssentialNetworkDataRespone({
    required this.statusCode,
    required this.data,
    required this.isSuccess,
    required this.error,
  });

  int? statusCode;
  dynamic data;
  bool isSuccess;
  dynamic error;

  factory DevEssentialNetworkDataRespone.empty() =>
      DevEssentialNetworkDataRespone(
        data: null,
        statusCode: null,
        error: "Something went wrong",
        isSuccess: false,
      );

  @override
  String toString() {
    return {
      'data': data,
      'statusCode': statusCode,
      'error': error,
      'isSuccess': isSuccess,
    }.toString();
  }
}
