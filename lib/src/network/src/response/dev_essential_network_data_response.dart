part of '../../network.dart';

class DevEssentialNetworkDataRespone {
  DevEssentialNetworkDataRespone({
    required this.statusCode,
    required this.data,
    required this.isSuccess,
  });

  int? statusCode;
  Object? data;
  bool isSuccess;

  factory DevEssentialNetworkDataRespone.empty() =>
      DevEssentialNetworkDataRespone(
        data: null,
        statusCode: null,
        isSuccess: false,
      );
}
