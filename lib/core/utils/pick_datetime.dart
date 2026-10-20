import 'package:material_ui/material_ui.dart';

import '../copy/strings.dart';
import 'format.dart';

/// Memilih tanggal dan jam dalam WIB, apa pun zona waktu perangkat; hasilnya UTC.
Future<DateTime?> pickWibDateTime(BuildContext context, {DateTime? initialUtc, TimeOfDay? defaultTime}) async {
  final now = Wib.now;
  final initial = initialUtc == null ? now : Wib.of(initialUtc);

  final date = await showDatePicker(
    context: context,
    initialDate: initial.isBefore(now) ? now : initial,
    firstDate: DateTime(now.year, now.month, now.day),
    lastDate: now.add(const Duration(days: 365)),
    helpText: S.pickDate,
  );
  if (date == null || !context.mounted) return null;

  final time = await showTimePicker(
    context: context,
    initialTime: initialUtc == null
        ? defaultTime ?? TimeOfDay(hour: (now.hour + 1) % 24, minute: 0)
        : TimeOfDay(hour: initial.hour, minute: initial.minute),
    helpText: S.pickTime,
  );
  if (time == null) return null;

  return DateTime.utc(date.year, date.month, date.day, time.hour, time.minute).subtract(const Duration(hours: 7));
}
