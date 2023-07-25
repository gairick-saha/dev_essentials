part of '../../network.dart';

class DevEssentialNetworkDataRespone {
  DevEssentialNetworkDataRespone({
    required this.statusCode,
    required this.data,
    required this.isSuccess,
    required this.error,
  });

  int? statusCode;
  Object? data;
  bool isSuccess;
  Object? error;

  factory DevEssentialNetworkDataRespone.empty() =>
      DevEssentialNetworkDataRespone(
        data: null,
        statusCode: null,
        error: null,
        isSuccess: false,
      );
}
