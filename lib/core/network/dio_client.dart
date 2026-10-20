import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/env.dart';
import '../storage/token_storage.dart';

part 'dio_client.g.dart';

/// Bertambah setiap kali API membalas 401; sesi mendengarkan ini untuk keluar.
@Riverpod(keepAlive: true)
class UnauthorizedSignal extends _$UnauthorizedSignal {
  @override
  int build() => 0;

  void fire() => state++;
}

/// Satu instance Dio dengan header token dan penanganan 401 (docs/architecture.md).
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final tokens = ref.watch(tokenStorageProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      headers: {'Accept': 'application/json'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = tokens.current;
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
      onError: (error, handler) async {
        final hadToken = error.requestOptions.headers.containsKey('Authorization');
        if (error.response?.statusCode == 401 && hadToken) {
          await tokens.clear();
          ref.read(unauthorizedSignalProvider.notifier).fire();
        }
        handler.next(error);
      },
    ),
  );

  return dio;
}
