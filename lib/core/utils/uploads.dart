import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

/// File yang dipilih pengguna, selalu sebagai bytes agar sama di Android dan Web.
class PickedUpload {
  const PickedUpload({required this.name, required this.bytes});

  final String name;
  final Uint8List bytes;

  int get size => bytes.lengthInBytes;

  MultipartFile toMultipart() => MultipartFile.fromBytes(bytes, filename: name);
}

/// Batas dan tipe file sesuai docs/api.md.
const maxUploadBytes = 10 * 1024 * 1024;
const allowedUploadExtensions = ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx', 'jpg', 'jpeg', 'png', 'zip'];

Future<List<PickedUpload>> pickDocuments() async {
  final files = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: allowedUploadExtensions);
  return [for (final f in files) PickedUpload(name: f.name, bytes: await f.xFile.readAsBytes())];
}

/// Batas foto profil (docs/api.md, POST /me/avatar).
const maxAvatarBytes = 2 * 1024 * 1024;

/// Foto profil dari galeri (Android) atau pemilih file (Chrome), diperkecil dulu.
Future<PickedUpload?> pickAvatar() async {
  final photo = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85, maxWidth: 512);
  if (photo == null) return null;
  return PickedUpload(name: photo.name, bytes: await photo.readAsBytes());
}

/// Foto kamera dikompres sebelum diunggah (product brief: hemat kuota).
Future<PickedUpload?> takePhoto() async {
  final photo = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 70, maxWidth: 1920);
  if (photo == null) return null;
  return PickedUpload(name: photo.name, bytes: await photo.readAsBytes());
}
