import 'package:material_ui/material_ui.dart';

import 'tokens.dart';

/// Motif pola geometris header kelas.
enum CoursePattern { leaves, waves, sun, stars, circles, dots, triangles, diagonals }

/// Delapan tema header kelas; nilai `courses.theme` (docs/design.md, bagian Tema kelas).
@immutable
class CourseTheme {
  const CourseTheme({required this.key, required this.header, required this.onHeader, required this.pattern});

  final String key;
  final Color header;
  final Color onHeader;
  final CoursePattern pattern;

  static const _white = Color(0xFFFFFFFF);

  static const all = <CourseTheme>[
    CourseTheme(key: 'forest', header: Color(0xFF268359), onHeader: _white, pattern: CoursePattern.leaves),
    CourseTheme(key: 'ocean', header: Color(0xFF2F6FDE), onHeader: _white, pattern: CoursePattern.waves),
    CourseTheme(key: 'sunset', header: Color(0xFFCD4521), onHeader: _white, pattern: CoursePattern.sun),
    CourseTheme(key: 'grape', header: Color(0xFF7E57C2), onHeader: _white, pattern: CoursePattern.stars),
    CourseTheme(key: 'rose', header: Color(0xFFC94374), onHeader: _white, pattern: CoursePattern.circles),
    CourseTheme(key: 'lagoon', header: Color(0xFF12808C), onHeader: _white, pattern: CoursePattern.dots),
    CourseTheme(key: 'mango', header: Color(0xFFF2A93B), onHeader: Color(0xFF3A2600), pattern: CoursePattern.triangles),
    CourseTheme(key: 'slate', header: Color(0xFF4E5D78), onHeader: _white, pattern: CoursePattern.diagonals),
  ];

  static CourseTheme of(String key) => all.firstWhere((t) => t.key == key, orElse: () => all.first);

  /// Mode gelap: warna yang sama dengan lapisan hitam agar tidak menyilaukan.
  Color headerFor(Brightness brightness) => brightness == Brightness.dark
      ? Color.alphaBlend(Colors.black.withValues(alpha: Sizes.darkHeaderScrim), header)
      : header;
}
