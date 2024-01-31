part of '../../network.dart';

class DevEssentialNetworkToken {
  DevEssentialNetworkToken({
    this.access,
    this.refresh,
  });

  final String? access;
  final String? refresh;

  DevEssentialNetworkToken copyWith({
    String? access,
    String? refresh,
  }) =>
      DevEssentialNetworkToken(
        access: access ?? this.access,
        refresh: refresh ?? this.refresh,
      );

  factory DevEssentialNetworkToken.fromJson(Map<String, dynamic> json) =>
      DevEssentialNetworkToken(
        access: json['accessToken'],
        refresh: json['refreshToken'],
      );

  DevEssentialNetworkToken copyWithfromJson(Map<String, dynamic> json) =>
      copyWith(
        access: json['accessToken'] ?? access,
        refresh: json['refreshToken'] ?? refresh,
      );

  Map<String, dynamic> toJson() => {
        'accessToken': access,
        'refreshToken': refresh,
      };

  String get token => 'Bearer $access';

  @override
  String toString() {
    return {'accessToken': access, 'refreshToken': refresh}.toString();
  }

  bool get isAccessTokenNull => access == null;

  bool get isRefreshTokenNull => refresh == null;

  bool get isAccessTokenExpired {
    assert(access != null, 'Access token cannot be null');
    return JwtDecoder.isExpired(access!);
  }

  bool get isRefreshTokenExpired {
    assert(refresh != null, 'Refresh token cannot be null');
    return JwtDecoder.isExpired(refresh!);
  }
}
