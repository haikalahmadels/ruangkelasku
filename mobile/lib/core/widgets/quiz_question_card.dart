import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../copy/strings.dart';
import '../models/display_status.dart';
import '../theme/app_colors.dart';
import '../theme/tokens.dart';

class QuizOptionView {
  const QuizOptionView({required this.id, required this.label, this.isCorrect});

  final int id;
  final String label;
  final bool? isCorrect;
}

/// Kartu soal pilihan ganda: nomor, teks, opsi radio besar.
/// Mode tinjau menandai jawaban benar/salah setelah dikembalikan.
class QuizQuestionCard extends StatelessWidget {
  const QuizQuestionCard({
    super.key,
    required this.number,
    required this.prompt,
    required this.points,
    required this.options,
    required this.selected,
    this.onSelected,
    this.review = false,
  });

  final int number;
  final String prompt;
  final int points;
  final List<QuizOptionView> options;
  final int? selected;

  /// `null` = baca-saja (sudah diserahkan).
  final ValueChanged<int?>? onSelected;
  final bool review;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Space.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(S.questionNumber(number), style: theme.textTheme.labelLarge)),
                Text(S.pointsLabel(points), style: theme.textTheme.labelMedium),
              ],
            ),
            const SizedBox(height: Space.sm),
            Text(prompt, style: theme.textTheme.titleMedium),
            const SizedBox(height: Space.sm),
            RadioGroup<int>(
              groupValue: selected,
              onChanged: onSelected ?? (_) {},
              child: Column(
                children: [
                  for (final option in options)
                    RadioListTile<int>(
                      value: option.id,
                      enabled: onSelected != null,
                      title: Text(option.label),
                      contentPadding: EdgeInsets.zero,
                      secondary: review && option.isCorrect != null ? _mark(option, colors) : null,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Ikon + label teks agar benar/salah tidak hanya dibedakan lewat warna.
  Widget? _mark(QuizOptionView option, AppColors colors) {
    if (option.isCorrect == true) {
      return Semantics(
        label: S.correct,
        child: Icon(Symbols.check_circle, fill: 1, color: colors.status[DisplayStatus.turnedIn]!.foreground),
      );
    }
    if (option.id == selected) {
      return Semantics(
        label: S.wrong,
        child: Icon(Symbols.cancel, fill: 1, color: colors.late),
      );
    }
    return null;
  }
}
