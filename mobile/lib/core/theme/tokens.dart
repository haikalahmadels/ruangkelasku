import 'package:material_ui/material_ui.dart';

/// Token desain dari docs/design.md. Layar fitur hanya boleh memakai konstanta ini.
abstract final class Space {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

abstract final class Radii {
  /// Chip, input.
  static const double sm = 8;

  /// Item daftar, lampiran.
  static const double md = 12;

  /// Kartu kelas, kartu posting.
  static const double lg = 16;

  /// Bottom sheet, dialog, FAB besar.
  static const double xl = 28;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
}

abstract final class Motion {
  static const Duration short = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration long = Duration(milliseconds: 450);

  /// Jeda per item saat daftar masuk, maksimal [staggerMaxItems] item.
  static const Duration stagger = Duration(milliseconds: 40);
  static const int staggerMaxItems = 8;

  /// Perayaan (konfeti, Ruki bersorak) tidak lebih dari ini.
  static const Duration celebration = Duration(seconds: 2);

  /// Simpan otomatis nilai draf setelah berhenti mengetik.
  static const Duration autosaveDebounce = Duration(milliseconds: 600);

  /// Memuat lebih lama dari ini menampilkan Ruki berpikir.
  static const Duration slowLoading = Duration(milliseconds: 1500);

  static const Curve standard = Easing.standard;
  static const Curve enter = Easing.emphasizedDecelerate;
  static const Curve exit = Easing.emphasizedAccelerate;

  /// Skala saat kartu atau tombol ditekan.
  static const double pressedScale = 0.98;

  /// Jarak naik item saat masuk daftar.
  static const double enterOffset = 12;
}

abstract final class Sizes {
  static const double touchTarget = 48;
  static const double icon = 24;
  static const double iconInChip = 20;
  static const double courseCardHeader = 96;
  static const double courseHeaderExpanded = 160;
  static const double avatarSm = 32;
  static const double avatarMd = 40;
  static const double avatarLg = 72;
  static const double contentMaxWidth = 1040;
  static const double navDrawerWidth = 280;
  static const double sidePanelWidth = 260;

  /// Pola dua panel (daftar di kiri, detail di kanan) aktif bila area konten minimal selebar ini.
  static const double listDetailMinWidth = 720;
  static const double listPaneWidth = 340;

  /// Grid Tab Nilai: kolom nama siswa tetap, kolom tugas bergulir mendatar.
  static const double gradeNameColumnWidth = 200;
  static const double gradeColumnWidth = 128;
  static const double gradeHeaderHeight = 112;
  static const double gradeRowHeight = 56;
  static const double attachmentMaxWidth = 320;
  static const double formMaxWidth = 560;
  static const double focusRingWidth = 2;
  static const double rukiSm = 96;
  static const double rukiMd = 140;
  static const double rukiLg = 180;

  /// Opasitas pola geometris pada header kelas.
  static const double patternOpacity = 0.12;

  /// Lapisan hitam di atas header kelas pada mode gelap.
  static const double darkHeaderScrim = 0.16;

  /// Lebar pola dari sisi kanan header (sisanya bebas untuk teks).
  static const double patternWidthFactor = 0.4;

  /// Batas baris isi posting sebelum "Lihat selengkapnya".
  static const int postPreviewLines = 5;
}
