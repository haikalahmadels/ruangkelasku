import 'package:dio/dio.dart';

import '../copy/strings.dart';

/// Galat API dalam satu bentuk untuk lapisan application dan presentation.
class ApiException implements Exception {
  ApiException({required this.message, this.statusCode, this.code, this.fieldErrors = const {}});

  factory ApiException.fromDio(DioException e) {
    final response = e.response;
    if (response == null) {
      return ApiException(message: S.errorNetwork);
    }

    final data = response.data;
    final body = data is Map<String, dynamic> ? data : const <String, dynamic>{};
    final errors = body['errors'];

    return ApiException(
      statusCode: response.statusCode,
      // Kode 409 dari docs/api.md, mis. already_member.
      code: body['code'] as String?,
      message: body['message'] as String? ?? S.errorGeneric,
      fieldErrors: errors is Map<String, dynamic>
          ? errors.map((key, value) => MapEntry(key, (value as List).cast<String>()))
          : const {},
    );
  }

  final String message;
  final int? statusCode;
  final String? code;
  final Map<String, List<String>> fieldErrors;

  bool get isNetwork => statusCode == null;
  bool get isUnauthorized => statusCode == 401;
  bool get isNotFound => statusCode == 404;
  bool get isValidation => statusCode == 422;

  /// Pesan pertama untuk satu field form, bila ada.
  String? fieldError(String field) => fieldErrors[field]?.first;

  @override
  String toString() => 'ApiException($statusCode, $code): $message';
}

/// Menjalankan panggilan Dio dan mengubah [DioException] menjadi [ApiException].
Future<T> apiCall<T>(Future<T> Function() request) async {
  try {
    return await request();
  } on DioException catch (e) {
    throw ApiException.fromDio(e);
  }
}
