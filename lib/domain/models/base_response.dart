import 'package:dio/dio.dart';

/// Tùy vào response mà API trả về để thay đổi lại cho phù hợp
class BaseResponse {
  int? code;
  dynamic data;
  String? message;
  bool? result;
  String? errorCode;

  Response? dioResponse;

  BaseResponse({this.code, this.data, this.message, this.result, this.errorCode});

  factory BaseResponse.fromJson(Map<String, dynamic> json, Function? create) {
    return BaseResponse(
      code: json['code'],
      data: create != null ? create(json['data']) : json['data'],
      message: json['message'],
      result: json['result'],
      errorCode: json['errorCode'],
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'data': data,
    'message': message,
    'result': result,
    'errorCode': errorCode,
  };
}
