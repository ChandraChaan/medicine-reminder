import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/l10n.dart';

/// Shows loading, error (with a retry) or the data of an [AsyncValue].
class AsyncView<T> extends StatelessWidget {
  const AsyncView({
    required this.value,
    required this.onRetry,
    required this.builder,
    super.key,
  });

  final AsyncValue<T> value;
  final VoidCallback onRetry;
  final Widget Function(BuildContext context, T data) builder;

  @override
  Widget build(BuildContext context) => switch (value) {
    AsyncValue(:final value?, hasValue: true) => builder(context, value),
    AsyncError() => ErrorRetry(onRetry: onRetry),
    _ => const Center(child: CircularProgressIndicator()),
  };
}

class ErrorRetry extends StatelessWidget {
  const ErrorRetry({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.errorGeneric,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: Text(context.l10n.retry)),
        ],
      ),
    ),
  );
}
