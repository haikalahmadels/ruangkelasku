import 'dart:async';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../copy/strings.dart';
import '../network/api_exception.dart';
import '../theme/tokens.dart';
import '../utils/format.dart';

enum _SaveState { idle, saving, saved, failed }

/// Kolom nilai "__/100": simpan otomatis sebagai nilai draf 600 ms setelah berhenti
/// mengetik, dengan status "Menyimpan..." / "Tersimpan" / "Coba lagi".
class GradeInput extends StatefulWidget {
  const GradeInput({super.key, required this.initial, required this.maxPoints, required this.onSave, this.label});

  final double? initial;
  final int maxPoints;
  final Future<void> Function(num? value) onSave;
  final String? label;

  @override
  State<GradeInput> createState() => _GradeInputState();
}

class _GradeInputState extends State<GradeInput> {
  late final _controller = TextEditingController(text: widget.initial == null ? '' : formatGrade(widget.initial!));
  Timer? _debounce;
  _SaveState _save = _SaveState.idle;
  String? _error;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  num? _parse(String text) => text.trim().isEmpty ? null : num.tryParse(text.trim().replaceAll(',', '.'));

  void _onChanged(String text) {
    _debounce?.cancel();
    final value = _parse(text);
    final invalid = text.trim().isNotEmpty && value == null;
    final tooHigh = value != null && (value < 0 || value > widget.maxPoints);
    setState(() => _error = invalid ? S.notNumber : (tooHigh ? S.maxPoints(widget.maxPoints) : null));
    if (_error != null) return;
    _debounce = Timer(Motion.autosaveDebounce, () => _persist(value));
  }

  Future<void> _persist(num? value) async {
    setState(() => _save = _SaveState.saving);
    try {
      await widget.onSave(value);
      if (mounted) setState(() => _save = _SaveState.saved);
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _save = _SaveState.failed;
          _error = e.fieldError('draft_grade');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = switch (_save) {
      _SaveState.idle => null,
      _SaveState.saving => Text(S.saving, style: theme.textTheme.labelSmall),
      _SaveState.saved => Text(S.saved, style: theme.textTheme.labelSmall),
      _SaveState.failed => TextButton(
        onPressed: () => _persist(_parse(_controller.text)),
        child: Text('${S.saveFailed}. ${S.retry}'),
      ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _controller,
          onChanged: _onChanged,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
          decoration: InputDecoration(
            labelText: widget.label ?? S.draftGrade,
            suffixText: '/${widget.maxPoints}',
            errorText: _error,
            isDense: true,
          ),
        ),
        if (status != null) Semantics(liveRegion: true, child: status),
      ],
    );
  }
}
