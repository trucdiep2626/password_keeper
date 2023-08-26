import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:password_keeper/common/config/network/network_config.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/models/base_response.dart';

class ApiClient {
  static const contentType = 'Content-Type';
  static const contentTypeJson = 'application/json; charset=utf-8';

  static final BaseOptions defaultOptions = BaseOptions(
    connectTimeout: Duration(milliseconds: 90000),
    sendTimeout: Duration(milliseconds: 90000),
    receiveTimeout: Duration(milliseconds: 90000),
    responseType: ResponseType.json,
    baseUrl: NetworkConfig.baseUrl,
  );

  Dio _dio = Dio();

  static final Map<BaseOptions, ApiClient> _instanceMap = {};

  factory ApiClient({BaseOptions? options}) {
    options ??= defaultOptions;
    if (_instanceMap.containsKey(options)) {
      return _instanceMap[options] ?? ApiClient();
    }
    final ApiClient apiClient = ApiClient._create(options: options);
    _instanceMap[options] = apiClient;
    return apiClient;
  }

  ApiClient._create({BaseOptions? options}) {
    options ??= defaultOptions;
    _dio = Dio(options);
    // _dio.interceptors.add(lo(
    //     requestHeader: true,
    //     requestBody: true,
    //     responseBody: true,
    //     responseHeader: true,
    //     error: true,
    //     compact: true,
    //     maxWidth: 90));
  }

  static ApiClient get instance => ApiClient();

  String _getMethod(NetworkMethod method) {
    switch (method) {
      case NetworkMethod.get:
        return 'GET';
      case NetworkMethod.post:
        return 'POST';
      case NetworkMethod.delete:
        return 'DELETE';
      case NetworkMethod.path:
        return 'PATH';
      case NetworkMethod.put:
        return 'PUT';
      default:
        return 'GET';
    }
  }

  Future<BaseResponse> request(
      {String? path,
      NetworkMethod method = NetworkMethod.get,
      String? data,
      Function? fromJsonModel,
      Map<String, dynamic>? formData,
      Map<String, dynamic>? queryParameters,
      String? basicAuthen,
      bool getFullResponse = false}) async {
    // Kiểm tra có kết nối internet hay không
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return BaseResponse(
        result: false,
        data: null,
        message: TranslationConstants.noConnectionError,
        code: 2106,
      );
    }
    // Kiểm tra có link API hay không
    if (isNullEmpty(path)) {
      logger('!!!!!!EMPTY URL!!!!!! - data: $data');
    }

    /// Config header truyền vào
    /// Tùy vào header của API để truyền vào
    Map<String, dynamic> headerMap = {};
    // Map<String, dynamic> headerMap = {
    //   "From": deviceId,
    //   if (basicAuthen != null) "Authorization": 'Basic $basicAuthen',
    //   "Accept-Language": getX.Get.locale.toString() == 'en_US' ? 'en' : 'vi',
    //   "user-agent": 'vimo-work-app/1.0.0 $deviceType/${SessionData.appVersion}',
    //   "auth-token": SessionData.authToken ?? '',
    // };
    headerMap.putIfAbsent("accept", () => "*/*");
    Response response;
    try {
      var strMethod = _getMethod(method);
      response = await _dio.request(path ?? '',
          data: formData != null
              ? FormData.fromMap(formData)
              : data ?? jsonEncode({}),
          options: Options(
              method: strMethod,
              sendTimeout: Duration(milliseconds: 10000),
              receiveTimeout: Duration(milliseconds: 10000),
              headers: headerMap,
              contentType: formData != null ? 'multipart/form-data' : null),
          queryParameters: queryParameters);
      if (_isSuccessful(response.statusCode ?? -1)) {
        dynamic dataResult = response.data;
        logger('---Data Encoder For Parser---: ${json.encode(dataResult)}');
        return BaseResponse(
          result: true,
          data: dataResult,
          message: '',
          code: 1000,
        );
      }
    } on DioError catch (e) {
      if (e.response != null) {
        dynamic dataResultError = e.response!.data;
        String errorMessage = dataResultError != null &&
                dataResultError.runtimeType.toString().contains('Map') &&
                !isNullEmpty(dataResultError['message'])
            ? dataResultError['message']
            : !isNullEmpty(e.response?.statusMessage)
                ? e.response?.statusMessage
                : e.message;
        String errorCode = dataResultError != null &&
                dataResultError.runtimeType.toString().contains('Map') &&
                !isNullEmpty(dataResultError['error'])
            ? dataResultError['error']
            : !isNullEmpty(e.response?.statusMessage)
                ? e.response?.statusMessage
                : e.message;
        return BaseResponse(
          result: false,
          data: dataResultError,
          message: errorMessage,
          code: e.response?.statusCode,
          errorCode: errorCode,
        );
      }
      if (e.error is SocketException) {
        SocketException socketException = e.error as SocketException;
        return BaseResponse(
          result: false,
          data: null,
          message: socketException.osError?.message ?? "",
          code: socketException.osError?.errorCode ?? 0,
        );
      }
      return BaseResponse(
        result: false,
        data: null,
        message: e.error != null ? e.error.toString() : "",
        code: -9999,
      );
    }
    throw ('Request NOT successful');
  }

  bool _isSuccessful(int i) {
    return i >= 200 && i <= 299;
  }
}
