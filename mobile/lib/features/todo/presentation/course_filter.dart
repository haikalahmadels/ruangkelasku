import 'package:material_ui/material_ui.dart';

import '../../../core/copy/strings.dart';
import '../../courses/data/course.dart';

/// Pilihan "Semua kelas" atau satu kelas, seperti filter di Google Classroom.
class CourseFilter extends StatelessWidget {
  const CourseFilter({super.key, required this.courses, required this.value, required this.onChanged});

  final List<Course> courses;
  final int? value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<int?>(
      // Kelas yang dipilih bisa hilang dari daftar (mis. diarsipkan).
      key: ValueKey(value),
      initialSelection: courses.any((c) => c.id == value) ? value : null,
      label: const Text(S.filterClass),
      expandedInsets: EdgeInsets.zero,
      requestFocusOnTap: false,
      onSelected: onChanged,
      dropdownMenuEntries: [
        const DropdownMenuEntry(value: null, label: S.allClasses),
        for (final course in courses) DropdownMenuEntry(value: course.id, label: course.name),
      ],
    );
  }
}
