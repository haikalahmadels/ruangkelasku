import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/uploads.dart';
import 'user.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._dio);

  final Dio _dio;

  Future<(String token, User user)> login({required String email, required String password}) => apiCall(() async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': email, 'password': password, 'device_name': Env.deviceName},
    );
    return _tokenAndUser(response.data!);
  });

  Future<(String token, User user)> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) => apiCall(() async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'device_name': Env.deviceName,
      },
    );
    return _tokenAndUser(response.data!);
  });

  Future<void> logout() => apiCall(() => _dio.post<void>('/auth/logout'));

  Future<User> me() => apiCall(() async {
    final response = await _dio.get<Map<String, dynamic>>('/me');
    return User.fromJson(response.data!['data'] as Map<String, dynamic>);
  });

  Future<User> updateName(String name) => apiCall(() async {
    final response = await _dio.patch<Map<String, dynamic>>('/me', data: {'name': name});
    return User.fromJson(response.data!['data'] as Map<String, dynamic>);
  });

  /// jpg/png maksimal 2 MB (docs/api.md, POST /me/avatar).
  Future<User> uploadAvatar(PickedUpload photo) => apiCall(() async {
    final form = FormData()..files.add(MapEntry('avatar', photo.toMultipart()));
    final response = await _dio.post<Map<String, dynamic>>('/me/avatar', data: form);
    return User.fromJson(response.data!['data'] as Map<String, dynamic>);
  });

  (String, User) _tokenAndUser(Map<String, dynamic> body) {
    final data = body['data'] as Map<String, dynamic>;
    return (data['token'] as String, User.fromJson(data['user'] as Map<String, dynamic>));
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => AuthRepository(ref.watch(dioProvider));
