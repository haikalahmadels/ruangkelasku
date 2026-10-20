import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

/// Menyimpan file buatan aplikasi (mis. ekspor CSV): di Chrome lewat unduhan browser,
/// di Android lewat lembar bagikan (docs/design.md, Catatan Chrome).
///
/// Mengembalikan `true` bila file langsung diunduh (web).
Future<bool> saveOrShareFile({required Uint8List bytes, required String name, required String mimeType}) async {
  final file = XFile.fromData(bytes, name: name, mimeType: mimeType);
  if (kIsWeb) {
    await file.saveTo(name);
    return true;
  }
  await SharePlus.instance.share(ShareParams(files: [file], fileNameOverrides: [name]));
  return false;
}
