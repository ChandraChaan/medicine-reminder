import 'dart:io';

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

/// The strip photo, or a pill icon when there is none.
class MedicinePhoto extends StatelessWidget {
  const MedicinePhoto({
    required this.name,
    required this.path,
    required this.size,
    super.key,
  });

  final String name;
  final String? path;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(size / 6);
    final photo = path;
    if (photo != null) {
      final pixels = (size * MediaQuery.devicePixelRatioOf(context)).round();
      return ClipRRect(
        borderRadius: radius,
        child: Image.file(
          File(photo),
          width: size,
          height: size,
          fit: BoxFit.cover,
          cacheWidth: pixels,
          semanticLabel: context.l10n.medicinePhoto(name),
          errorBuilder: (context, _, _) => _Placeholder(size: size),
        ),
      );
    }
    return ClipRRect(
      borderRadius: radius,
      child: ColoredBox(
        color: scheme.primaryContainer,
        child: _Placeholder(size: size),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: Icon(
      Icons.medication_rounded,
      size: size * 0.6,
      color: Theme.of(context).colorScheme.onPrimaryContainer,
    ),
  );
}
