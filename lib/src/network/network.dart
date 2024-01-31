import 'dart:async';
import 'dart:convert';

import 'package:dev_essentials/dev_essentials.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

part 'src/token/dev_essential_network_token.dart';
part 'src/interceptor/logging_interceptor.dart';
part 'src/response/dev_essential_network_data_response.dart';
part 'src/dev_essential_network_client.dart';

typedef DevEssentialNetworkOptions = Options;
typedef DevEssentialNetworkCancelToken = CancelToken;
typedef DevEssentialNetworkProgressCallback = ProgressCallback;
typedef DevEssentialNetworkMultipartFile = MultipartFile;
