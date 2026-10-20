import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../copy/strings.dart';
import '../layout/breakpoints.dart';
import '../network/api_exception.dart';
import '../theme/tokens.dart';
import 'ruki_view.dart';

/// Tiga keadaan setiap daftar: memuat (kerangka), galat (Ruki bingung + coba lagi), data.
class AsyncView<T> extends StatelessWidget {
  const AsyncView({super.key, required this.value, required this.data, required this.onRetry, this.skeleton});

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback onRetry;

  /// Kerangka berbentuk konten; default daftar biasa.
  final Widget? skeleton;

  @override
  Widget build(BuildContext context) {
    // Data lama tetap tampil selama dimuat ulang agar layar (dan isian form) tidak berkedip.
    if (value.hasValue) return data(value.requireValue);
    if (value.hasError) return ErrorView(error: value.error!, onRetry: onRetry);
    return skeleton ?? const SkeletonList();
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final message = switch (error) {
      ApiException(isNotFound: true) => S.errorNotFound,
      ApiException(:final message) => message,
      _ => S.errorGeneric,
    };
    return RukiView(pose: RukiPose.confused, message: message, actionLabel: S.retry, onAction: onRetry);
  }
}

/// Kerangka shimmer untuk daftar; diam saat reduce motion.
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      effect: context.reduceMotion
          ? SolidColorEffect(color: Theme.of(context).colorScheme.surfaceContainerHighest)
          : null,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(Space.lg),
        itemCount: itemCount,
        itemBuilder: (context, _) => const ListTile(
          leading: CircleAvatar(),
          title: Text('Memuat judul item ini'),
          subtitle: Text('Memuat keterangan singkat'),
        ),
      ),
    );
  }
}
