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
