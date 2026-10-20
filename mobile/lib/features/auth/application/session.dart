import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/storage/token_storage.dart';
import '../../../core/utils/uploads.dart';
import '../data/auth_repository.dart';
import '../data/user.dart';

part 'session.g.dart';

/// Pengguna yang sedang login; `null` berarti belum login.
@Riverpod(keepAlive: true)
class Session extends _$Session {
  @override
  Future<User?> build() async {
    // Token kedaluwarsa di request mana pun membuat sesi berakhir.
    ref.listen(unauthorizedSignalProvider, (_, _) => state = const AsyncData(null));

    final token = await ref.read(tokenStorageProvider).read();
    if (token == null) return null;

    try {
      return await ref.read(authRepositoryProvider).me();
    } on ApiException catch (e) {
      if (e.isUnauthorized) return null;
      rethrow;
    }
  }

  Future<void> login({required String email, required String password}) async {
    final (token, user) = await ref.read(authRepositoryProvider).login(email: email, password: password);
    await ref.read(tokenStorageProvider).write(token);
    state = AsyncData(user);
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final (token, user) = await ref
        .read(authRepositoryProvider)
        .register(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation);
    await ref.read(tokenStorageProvider).write(token);
    state = AsyncData(user);
  }

  Future<void> updateName(String name) async {
    state = AsyncData(await ref.read(authRepositoryProvider).updateName(name));
  }

  Future<void> updateAvatar(PickedUpload photo) async {
    state = AsyncData(await ref.read(authRepositoryProvider).uploadAvatar(photo));
  }

  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).logout();
    } on ApiException {
      // Token tetap dihapus di perangkat walau server tidak terjangkau.
    }
    await ref.read(tokenStorageProvider).clear();
    state = const AsyncData(null);
  }
}

/// ID pengguna aktif; provider data lain mengawasinya agar cache direset saat ganti akun.
@Riverpod(keepAlive: true)
int? currentUserId(Ref ref) => ref.watch(sessionProvider.select((s) => s.value?.id));
